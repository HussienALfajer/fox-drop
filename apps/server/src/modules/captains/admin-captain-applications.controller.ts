import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { AuditService } from '../audit/index.js';
import { FilesRefusedError } from '../files/index.js';
import type { AdminSession } from '../identity/index.js';
import { vehicles } from '../settings/index.js';
import {
  ApplicationPipelineService,
  boardStages,
  type PipelineAdmin,
  PipelineRefusedError,
  type Review,
} from './application-pipeline.service.js';
import { ApplicationRefusedError } from './applications.service.js';
import { interview } from './captain-application.controller.js';
import { applicationDocumentKinds, applicationEventKinds, applicationStages } from './schema.js';

const documentKind = z.enum(applicationDocumentKinds);
const stage = z.enum(applicationStages);
const documentStatus = z.enum(['pending', 'accepted', 'rejected']);
const reason = z.string().trim().min(1).max(500);

class AdminCaptainApplicationsQueryDto extends createZodDto(
  z.object({ cityId: z.uuid(), stage: z.enum(boardStages).default('new') }),
) {}

class AdminCaptainApplicationsDto extends createZodDto(
  z.object({
    counts: z
      .partialRecord(z.enum(boardStages), z.int())
      .describe('The applications of each stage; a stage without any is left out.'),
    applications: z.array(
      z.object({
        id: z.uuid(),
        fullName: z.string(),
        vehicle: z.enum(vehicles),
        zoneId: z.uuid(),
        stage,
        submittedAt: z.iso.datetime(),
        updatedAt: z.iso.datetime(),
      }),
    ),
  }),
) {}

class AdminCaptainApplicationParamsDto extends createZodDto(
  z.object({ applicationId: z.uuid() }),
) {}

class AdminCaptainApplicationDocumentParamsDto extends createZodDto(
  z.object({ applicationId: z.uuid(), documentId: z.uuid() }),
) {}

class AdminCaptainApplicationKindParamsDto extends createZodDto(
  z.object({ applicationId: z.uuid(), kind: documentKind }),
) {}

class AdminCaptainApplicationDto extends createZodDto(
  z.object({
    id: z.uuid(),
    stage,
    cityId: z.uuid(),
    fullName: z.string(),
    birthDate: z.iso.date(),
    zoneId: z.uuid(),
    zoneName: z.string().nullable(),
    vehicle: z.enum(vehicles).nullable(),
    plate: z.string().nullable(),
    phone: z
      .string()
      .nullable()
      .describe('In full for captains.manage, masked otherwise (architecture §15.3).'),
    submittedAt: z.iso.datetime().nullable(),
    updatedAt: z.iso.datetime(),
    requiredDocuments: z.array(documentKind).describe('The documents activation waits for (D24).'),
    documents: z
      .array(
        z.object({
          id: z.uuid(),
          kind: documentKind,
          status: documentStatus,
          reason: z.string().nullable(),
          number: z.string().nullable(),
          issueDate: z.iso.date().nullable(),
          expiresOn: z.iso.date().nullable(),
          uploadedAt: z.iso.datetime(),
          uploadedByOffice: z.boolean(),
          uploadedBy: z.string().nullable().describe("The office's admin; null for the applicant."),
          reviewedBy: z.string().nullable(),
          reviewedAt: z.iso.datetime().nullable(),
          inForce: z.boolean().describe('False for an upload a newer one replaced.'),
          fileUrls: z.array(z.string()).describe('Signed GETs on the panel’s origin, 10 minutes.'),
        }),
      )
      .describe('Every upload, newest first.'),
    requests: z.array(
      z.object({
        kind: documentKind,
        reason: z.string(),
        requestedAt: z.iso.datetime(),
        requestedBy: z.string().nullable(),
      }),
    ),
    interview: interview.nullable(),
    rejection: z
      .object({ reason: z.string(), at: z.iso.datetime(), reapplyFrom: z.iso.datetime() })
      .nullable(),
    duplicates: z
      .array(
        z.object({
          field: z.enum(['id_number', 'phone', 'plate']),
          applicationId: z.uuid().nullable(),
          captainId: z.uuid().nullable(),
          fullName: z.string(),
          stage: stage.nullable(),
        }),
      )
      .describe('Another applicant or captain with the same ID number, phone or plate.'),
    events: z.array(
      z.object({
        id: z.uuid(),
        at: z.iso.datetime(),
        actor: z.string().nullable().describe('The admin; null for the applicant.'),
        kind: z.enum(applicationEventKinds),
        stage,
        documentKind: documentKind.nullable(),
        documentStatus: documentStatus.nullable(),
        note: z.string().nullable(),
      }),
    ),
  }),
) {}

class AdminCaptainApplicationReviewDto extends createZodDto(
  z
    .object({
      status: z.enum(['accepted', 'rejected']),
      reason: reason.nullish().describe('Required for «مرفوض»; sent to the applicant.'),
    })
    .refine((body) => body.status === 'accepted' || !!body.reason, {
      message: 'a rejection takes a reason',
      path: ['reason'],
    }),
) {}

class AdminCaptainApplicationDocumentDto extends createZodDto(
  z.object({
    uploadIds: z
      .array(z.uuid())
      .min(1)
      .max(2)
      .describe('From POST /v1/admin/uploads (captain_document), once uploaded.'),
    number: z.string().max(40).nullish().describe('The national ID’s number.'),
    issueDate: z.iso.date().nullish().describe("The criminal record's issue date."),
  }),
) {}

class AdminCaptainApplicationRequestDto extends createZodDto(
  z.object({ kind: documentKind, reason: reason.describe('Sent to the applicant.') }),
) {}

class AdminCaptainApplicationNoteDto extends createZodDto(
  z.object({ note: z.string().trim().min(1).max(2000) }),
) {}

class AdminCaptainApplicationInterviewDto extends createZodDto(
  z.object({
    at: z.iso.datetime().describe('In the future.'),
    place: z.string().trim().min(1).max(200),
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
  }),
) {}

class AdminCaptainApplicationRejectDto extends createZodDto(
  z.object({ reason: reason.describe('Sent to the applicant (CA §5.4).') }),
) {}

// AP §9.7.1 «طلبات الانضمام» (slice 2.34b): the board by stage, the review
// page and its actions. Reading takes captains.read; every action
// captains.manage (OWN, OPS; owner decision 2026-11-19) and answers the
// review page. Every action but the note sets a value or is refused once
// taken (409 wrong_stage, already_requested), so only the note takes an
// Idempotency-Key. 404 unknown_application (a draft is the applicant's);
// 409 wrong_stage with the application's `stage`.
@AdminController('captain-applications')
export class AdminCaptainApplicationsController {
  constructor(
    private readonly pipeline: ApplicationPipelineService,
    private readonly audit: AuditService,
  ) {}

  // Runs the action, then answers the review page. The applicant's number
  // in full (captains.manage, who calls to schedule the interview) is
  // audited as a view each time (`captain_application.phone_view`, AP §14),
  // as the restaurants' accounts are; masked for any other reader.
  private async page(
    applicationId: string,
    session: AdminSession,
    request: FastifyRequest,
    run: () => Promise<void>,
  ) {
    try {
      await run();
      const review = await this.pipeline.review(applicationId);
      if (review.phone !== null && session.permissions.includes('captains.manage')) {
        await this.audit.recordView({
          actor: adminOf(session, request).actor,
          context: requestContext(request),
          cityId: review.cityId,
          action: 'captain_application.phone_view',
          target: { type: 'captain_application', id: review.id },
        });
      }
      return body(review, session);
    } catch (error) {
      throw refused(error);
    }
  }

  @Get()
  @RequirePermission('captains.read')
  @ZodResponse({ status: 200, type: AdminCaptainApplicationsDto })
  async board(@Query() query: AdminCaptainApplicationsQueryDto) {
    const board = await this.pipeline.board(query.cityId, query.stage);
    return {
      counts: board.counts,
      applications: board.applications.map((entry) => ({
        ...entry,
        submittedAt: entry.submittedAt.toISOString(),
        updatedAt: entry.updatedAt.toISOString(),
      })),
    };
  }

  @Get(':applicationId')
  @RequirePermission('captains.read')
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  review(
    @Param() params: AdminCaptainApplicationParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, async () => undefined);
  }

  // 404 unknown_document; 409 document_replaced (a newer upload).
  @Post(':applicationId/documents/:documentId/review')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  reviewDocument(
    @Param() params: AdminCaptainApplicationDocumentParamsDto,
    @Body() body: AdminCaptainApplicationReviewDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.reviewDocument(params.applicationId, adminOf(session, request), {
        documentId: params.documentId,
        status: body.status,
        reason: body.reason ?? null,
      }),
    );
  }

  // The office's scan. 400 invalid_files, number_required,
  // issue_date_required, issue_date_in_future, document_expired and the
  // uploads' refusals; 409 document_not_needed.
  @Put(':applicationId/documents/:kind')
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  uploadDocument(
    @Param() params: AdminCaptainApplicationKindParamsDto,
    @Body() body: AdminCaptainApplicationDocumentDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.uploadDocument(
        params.applicationId,
        adminOf(session, request),
        params.kind,
        body,
      ),
    );
  }

  // «طلب مستند». 409 already_requested, document_not_needed.
  @Post(':applicationId/document-requests')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  requestDocument(
    @Param() params: AdminCaptainApplicationParamsDto,
    @Body() body: AdminCaptainApplicationRequestDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.requestDocument(params.applicationId, adminOf(session, request), body),
    );
  }

  @Post(':applicationId/notes')
  @RequirePermission('captains.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  addNote(
    @Param() params: AdminCaptainApplicationParamsDto,
    @Body() body: AdminCaptainApplicationNoteDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.addNote(
        params.applicationId,
        adminOf(session, request),
        body.note,
        idempotencyKey,
      ),
    );
  }

  // «تحديد مقابلة». 400 interview_in_past.
  @Put(':applicationId/interview')
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  scheduleInterview(
    @Param() params: AdminCaptainApplicationParamsDto,
    @Body() body: AdminCaptainApplicationInterviewDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.scheduleInterview(params.applicationId, adminOf(session, request), {
        ...body,
        at: new Date(body.at),
      }),
    );
  }

  @Post(':applicationId/training-passed')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  trainingPassed(
    @Param() params: AdminCaptainApplicationParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.trainingPassed(params.applicationId, adminOf(session, request)),
    );
  }

  @Post(':applicationId/reject')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  reject(
    @Param() params: AdminCaptainApplicationParamsDto,
    @Body() body: AdminCaptainApplicationRejectDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.reject(params.applicationId, adminOf(session, request), body.reason),
    );
  }

  @Post(':applicationId/waitlist')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  waitlist(
    @Param() params: AdminCaptainApplicationParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.waitlist(params.applicationId, adminOf(session, request)),
    );
  }

  @Post(':applicationId/back-from-waitlist')
  @RequirePermission('captains.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCaptainApplicationDto })
  backFromWaitlist(
    @Param() params: AdminCaptainApplicationParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.page(params.applicationId, session, request, () =>
      this.pipeline.backFromWaitlist(params.applicationId, adminOf(session, request)),
    );
  }
}

function adminOf(session: AdminSession, request: FastifyRequest): PipelineAdmin {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

// architecture §15.3: a number is masked in the panel unless its holder must
// act on it (who schedules the interview calls the applicant), its view
// audited.
function masked(phone: string): string {
  const code = phone.startsWith('+90') ? '+90' : phone.startsWith('+963') ? '+963' : '+';
  return `${code} ••• ${phone.slice(-3)}`;
}

function body(review: Review, session: AdminSession) {
  const iso = (at: Date | null) => at?.toISOString() ?? null;
  return {
    ...review,
    phone:
      review.phone === null || session.permissions.includes('captains.manage')
        ? review.phone
        : masked(review.phone),
    submittedAt: iso(review.submittedAt),
    updatedAt: review.updatedAt.toISOString(),
    documents: review.documents.map((document) => ({
      ...document,
      uploadedAt: document.uploadedAt.toISOString(),
      reviewedAt: iso(document.reviewedAt),
    })),
    requests: review.requests.map((request) => ({
      ...request,
      requestedAt: request.requestedAt.toISOString(),
    })),
    interview: review.interview && { ...review.interview, at: review.interview.at.toISOString() },
    rejection: review.rejection && {
      reason: review.rejection.reason,
      at: review.rejection.at.toISOString(),
      reapplyFrom: review.rejection.reapplyFrom.toISOString(),
    },
    events: review.events.map((event) => ({ ...event, at: event.at.toISOString() })),
  };
}

const notFound = new Set(['unknown_application', 'unknown_document']);
const badRequests = new Set([
  'interview_in_past',
  'invalid_files',
  'number_required',
  'issue_date_required',
  'issue_date_in_future',
  'document_expired',
]);

function refused(error: unknown): unknown {
  if (error instanceof FilesRefusedError) {
    return error.refusal === 'upload_used'
      ? new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal })
      : new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
  }
  if (!(error instanceof PipelineRefusedError) && !(error instanceof ApplicationRefusedError)) {
    return error;
  }
  const refusal = error.refusal;
  if (notFound.has(refusal)) {
    return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
  }
  if (badRequests.has(refusal)) {
    return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: refusal });
  }
  return new ConflictException({
    statusCode: HttpStatus.CONFLICT,
    error: refusal,
    ...(error instanceof PipelineRefusedError && error.stage !== null
      ? { stage: error.stage }
      : {}),
  });
}
