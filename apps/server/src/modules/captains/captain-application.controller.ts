import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpException,
  HttpStatus,
  Param,
  Post,
  Put,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import {
  CustomerNewUploadDto,
  CustomerUploadDto,
  FilesRefusedError,
  FilesService,
} from '../files/index.js';
import type { AppSession } from '../identity/index.js';
import { vehicles } from '../settings/index.js';
import {
  type Application,
  ApplicationRefusedError,
  type Applicant,
  ApplicationsService,
} from './applications.service.js';
import { applicationDocumentKinds, applicationStages } from './schema.js';

const day = z.iso.date().describe('A calendar day, YYYY-MM-DD.');

const documentKind = z.enum(applicationDocumentKinds);

export const interview = z.object({
  at: z.iso.datetime(),
  place: z.string(),
  latitude: z.number(),
  longitude: z.number(),
});

const application = z.object({
  id: z.uuid(),
  stage: z
    .enum(applicationStages)
    .describe('draft until «إرسال الطلب», then the panel’s stage (CA §5.4).'),
  fullName: z.string(),
  birthDate: day,
  zoneId: z.uuid(),
  vehicle: z.enum(vehicles).nullable(),
  plate: z.string().nullable(),
  documents: z.array(
    z.object({
      kind: documentKind,
      status: z.enum(['pending', 'accepted', 'rejected']),
      reason: z.string().nullable().describe('Why it was rejected.'),
      fileCount: z.int(),
      number: z.string().nullable().describe("The ID's number."),
      issueDate: day.nullable(),
      expiresOn: day.nullable().describe("The criminal record's expiry (C18)."),
      uploadedAt: z.iso.datetime(),
    }),
  ),
  missing: z
    .array(
      z.enum([
        'vehicle',
        ...applicationDocumentKinds.map((kind) => `document:${kind}` as const),
        'terms',
      ]),
    )
    .describe('What «إرسال الطلب» waits for, in the form’s order.'),
  submittedAt: z.iso.datetime().nullable(),
  // The panel's (CA §5.4, slice 2.34b).
  requests: z
    .array(z.object({ kind: documentKind, reason: z.string(), requestedAt: z.iso.datetime() }))
    .describe('What the panel asked for: «يرجى رفع {المستند}: {السبب}».'),
  interview: interview.nullable(),
  rejection: z
    .object({
      reason: z.string(),
      at: z.iso.datetime(),
      reapplyFrom: z.iso.datetime().describe('A new application from then (K11).'),
    })
    .nullable(),
  history: z
    .array(z.object({ stage: z.enum(applicationStages), at: z.iso.datetime() }))
    .describe('The stages since «إرسال الطلب», oldest first.'),
});

class CaptainApplicationDto extends createZodDto(
  z.object({ application: application.nullable() }),
) {}

class CaptainApplicationZonesDto extends createZodDto(
  z.object({
    zones: z.array(
      z.object({ id: z.uuid(), name: z.string(), cityId: z.uuid(), cityName: z.string() }),
    ),
  }),
) {}

class CaptainApplicationPersonalDto extends createZodDto(
  z.object({
    fullName: z.string().max(200).describe('Three parts at least, 80 characters at most.'),
    birthDate: day,
    zoneId: z.uuid().describe('One of GET /v1/captain/application/zones.'),
  }),
) {}

class CaptainApplicationVehicleDto extends createZodDto(
  z.object({
    vehicle: z.enum(vehicles),
    plate: z.string().max(100).nullish().describe('Required for a motorbike or a car.'),
  }),
) {}

class CaptainApplicationDocumentParamsDto extends createZodDto(z.object({ kind: documentKind })) {}

class CaptainApplicationDocumentDto extends createZodDto(
  z.object({
    uploadIds: z
      .array(z.uuid())
      .min(1)
      .max(2)
      .describe('From POST /v1/captain/application/documents/upload, once uploaded.'),
    number: z.string().max(40).nullish().describe('The national ID’s number.'),
    issueDate: day.nullish().describe("The criminal record's issue date."),
  }),
) {}

// CA §5.1–5.3, §15 (slice 2.34a): the application form, saved after every
// step, and «إرسال الطلب». Each step sets its values, and the submission
// answers a repeat with the application sent, so none takes an
// Idempotency-Key; the upload answers a URL to upload with. Every route
// takes an applicant's session; a captain's is `409 already_captain`.
@CaptainController('application')
export class CaptainApplicationController {
  constructor(
    private readonly applications: ApplicationsService,
    private readonly files: FilesService,
  ) {}

  @Get()
  @AppSignedIn({ applicants: true })
  @ZodResponse({ status: 200, type: CaptainApplicationDto })
  async get(@CurrentAppSession() session: AppSession) {
    const found = await this.applications.application(session.accountId);
    return { application: found === null ? null : body(found) };
  }

  @Get('zones')
  @AppSignedIn({ applicants: true })
  @ZodResponse({ status: 200, type: CaptainApplicationZonesDto })
  async zones() {
    return { zones: await this.applications.zones() };
  }

  // Step 1. 400 invalid_name, too_young (`captain.min_age`), unknown_zone;
  // 409 already_captain, application_submitted, reapply_wait with
  // `reapplyFrom` (K11: 30 days after a rejection).
  @Put('personal')
  @AppSignedIn({ applicants: true })
  @ZodResponse({ status: 200, type: CaptainApplicationDto })
  personal(@CurrentAppSession() session: AppSession, @Body() input: CaptainApplicationPersonalDto) {
    return answer(() => this.applications.savePersonal(applicantOf(session), input));
  }

  // Step 2. 400 plate_required; 409 no_application, application_submitted.
  @Put('vehicle')
  @AppSignedIn({ applicants: true })
  @ZodResponse({ status: 200, type: CaptainApplicationDto })
  vehicle(@CurrentAppSession() session: AppSession, @Body() input: CaptainApplicationVehicleDto) {
    return answer(() => this.applications.saveVehicle(applicantOf(session), input));
  }

  // Step 3: a document photo's pre-signed PUT into private-docs, the account
  // as its owner. 429 too_many_uploads.
  @Post('documents/upload')
  @AppSignedIn({ applicants: true })
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  async upload(@CurrentAppSession() session: AppSession, @Body() input: CustomerNewUploadDto) {
    if (session.captain !== null) throw refused(new ApplicationRefusedError('already_captain'));
    try {
      const upload = await this.files.createUpload(
        { ...input, purpose: 'captain_document' },
        session.accountId,
      );
      return { ...upload, expiresAt: upload.expiresAt.toISOString() };
    } catch (error) {
      throw filesRefused(error);
    }
  }

  // Step 3: a document's photos. 400 invalid_files, number_required,
  // issue_date_required, issue_date_in_future, document_expired and the
  // uploads' upload_not_found, upload_wrong_purpose, upload_expired,
  // upload_missing, upload_invalid; 409 no_application,
  // application_submitted (once sent, only a document asked for or rejected
  // is uploaded again), document_not_needed (vehicle papers without a motor
  // vehicle).
  @Put('documents/:kind')
  @AppSignedIn({ applicants: true })
  @ZodResponse({ status: 200, type: CaptainApplicationDto })
  document(
    @CurrentAppSession() session: AppSession,
    @Param() params: CaptainApplicationDocumentParamsDto,
    @Body() input: CaptainApplicationDocumentDto,
  ) {
    return answer(() => this.applications.saveDocument(applicantOf(session), params.kind, input));
  }

  // Step 5 «إرسال الطلب». 409 incomplete with `missing`, no_application.
  @Post('submit')
  @AppSignedIn({ applicants: true })
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainApplicationDto })
  submit(@CurrentAppSession() session: AppSession) {
    return answer(() => this.applications.submit(applicantOf(session)));
  }
}

function applicantOf(session: AppSession): Applicant {
  return { accountId: session.accountId, captain: session.captain !== null };
}

async function answer(run: () => Promise<Application>) {
  try {
    return { application: body(await run()) };
  } catch (error) {
    if (error instanceof ApplicationRefusedError) throw refused(error);
    throw filesRefused(error);
  }
}

function body(found: Application) {
  return {
    ...found,
    documents: found.documents.map((document) => ({
      ...document,
      uploadedAt: document.uploadedAt.toISOString(),
    })),
    submittedAt: found.submittedAt?.toISOString() ?? null,
    requests: found.requests.map((request) => ({
      ...request,
      requestedAt: request.requestedAt.toISOString(),
    })),
    interview: found.interview && { ...found.interview, at: found.interview.at.toISOString() },
    rejection: found.rejection && {
      reason: found.rejection.reason,
      at: found.rejection.at.toISOString(),
      reapplyFrom: found.rejection.reapplyFrom.toISOString(),
    },
    history: found.history.map((entry) => ({ ...entry, at: entry.at.toISOString() })),
  };
}

const conflicts = new Set([
  'already_captain',
  'no_application',
  'application_submitted',
  'document_not_needed',
  'incomplete',
  'reapply_wait',
]);

function refused(error: ApplicationRefusedError): HttpException {
  const response = {
    error: error.refusal,
    ...(error.refusal === 'incomplete' ? { missing: error.missing } : {}),
    ...(error.reapplyFrom === null ? {} : { reapplyFrom: error.reapplyFrom.toISOString() }),
  };
  return conflicts.has(error.refusal)
    ? new ConflictException({ statusCode: HttpStatus.CONFLICT, ...response })
    : new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...response });
}

function filesRefused(error: unknown): unknown {
  if (!(error instanceof FilesRefusedError)) return error;
  if (error.refusal === 'too_many_uploads') {
    return new HttpException(
      { statusCode: HttpStatus.TOO_MANY_REQUESTS, error: error.refusal },
      HttpStatus.TOO_MANY_REQUESTS,
    );
  }
  return error.refusal === 'upload_used'
    ? new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal })
    : new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
}
