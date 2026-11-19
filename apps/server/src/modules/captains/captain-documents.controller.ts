import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { CustomerNewUploadDto, CustomerUploadDto, FilesService } from '../files/index.js';
import type { AppSession } from '../identity/index.js';
import {
  ApplicationPipelineService,
  type CaptainDocument,
  PipelineRefusedError,
} from './application-pipeline.service.js';
import { ApplicationRefusedError } from './applications.service.js';
import { filesRefused } from './captain-application.controller.js';
import { applicationDocumentKinds } from './schema.js';

const day = z.iso.date();
const kinds = applicationDocumentKinds.filter((kind) => kind !== 'signed_contract');
const documentKind = z.enum(kinds as [(typeof kinds)[number], ...(typeof kinds)[number][]]);
const upload = z
  .object({ issueDate: day.nullable(), expiresOn: day.nullable(), uploadedAt: z.iso.datetime() })
  .nullable();

class CaptainDocumentsDto extends createZodDto(
  z.object({
    documents: z.array(
      z.object({
        kind: documentKind,
        required: z.boolean(),
        state: z
          .enum(['valid', 'expiring', 'expired', 'missing'])
          .describe('«expiring» from captain.document_expiry_notice_days before its expiry.'),
        valid: upload.describe('The one in force, valid until it expires.'),
        pending: upload.describe('«رفع نسخة جديدة» waiting for OPS.'),
        rejection: z.object({ reason: z.string(), at: z.iso.datetime() }).nullable(),
      }),
    ),
  }),
) {}

class CaptainDocumentKindDto extends createZodDto(z.object({ kind: documentKind })) {}

class CaptainDocumentReplacementDto extends createZodDto(
  z.object({
    uploadIds: z
      .array(z.uuid())
      .min(1)
      .max(2)
      .describe('From POST /v1/captain/documents/upload, once uploaded.'),
    number: z.string().max(40).nullish().describe('The national ID’s number.'),
    issueDate: day.nullish().describe("The criminal record's issue date."),
  }),
) {}

// CA §12.2 (slice 2.35a): «المستندات» on the profile: every document with
// its status and expiry, and «رفع نسخة جديدة», which waits for OPS's review
// while the document in force stays valid until it expires. A captain's
// session only; each answers the documents.
@CaptainController('documents')
export class CaptainDocumentsController {
  constructor(
    private readonly pipeline: ApplicationPipelineService,
    private readonly files: FilesService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainDocumentsDto })
  async documents(@CurrentAppSession() session: AppSession) {
    return this.answer(captainOf(session));
  }

  // A photo's pre-signed PUT into private-docs, the account as its owner.
  // 429 too_many_uploads.
  @Post('upload')
  @AppSignedIn()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  async upload(@CurrentAppSession() session: AppSession, @Body() input: CustomerNewUploadDto) {
    captainOf(session);
    try {
      const created = await this.files.createUpload(
        { ...input, purpose: 'captain_document' },
        session.accountId,
      );
      return { ...created, expiresAt: created.expiresAt.toISOString() };
    } catch (error) {
      throw filesRefused(error);
    }
  }

  // «رفع نسخة جديدة». 400 invalid_files, number_required,
  // issue_date_required, issue_date_in_future, document_expired and the
  // uploads' refusals; 409 document_not_needed. The same files again change
  // nothing, so a retry needs no key.
  @Put(':kind')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainDocumentsDto })
  async replace(
    @CurrentAppSession() session: AppSession,
    @Param() params: CaptainDocumentKindDto,
    @Body() body: CaptainDocumentReplacementDto,
  ) {
    const captain = captainOf(session);
    try {
      await this.pipeline.replaceDocument(captain, params.kind, body);
    } catch (error) {
      throw refused(error);
    }
    return this.answer(captain);
  }

  private async answer(captain: { captainId: string }) {
    const documents = await this.pipeline.captainDocuments(captain.captainId, new Date());
    return { documents: documents.filter(shown).map(bodyOf) };
  }
}

function captainOf(session: AppSession): { captainId: string; accountId: string } {
  if (session.captain === null) throw new ForbiddenException();
  return { captainId: session.captain.captainId, accountId: session.accountId };
}

function shown(
  document: CaptainDocument,
): document is CaptainDocument & { kind: (typeof kinds)[number] } {
  return document.kind !== 'signed_contract';
}

function bodyOf(document: CaptainDocument & { kind: (typeof kinds)[number] }) {
  const view = (each: CaptainDocument['valid']) =>
    each && { ...each, uploadedAt: each.uploadedAt.toISOString() };
  return {
    ...document,
    valid: view(document.valid),
    pending: view(document.pending),
    rejection: document.rejection && {
      reason: document.rejection.reason,
      at: document.rejection.at.toISOString(),
    },
  };
}

function refused(error: unknown): unknown {
  const filesError = filesRefused(error);
  if (filesError !== error) return filesError;
  if (error instanceof PipelineRefusedError || error instanceof ApplicationRefusedError) {
    const conflict = ['document_not_needed', 'unknown_application', 'wrong_stage'].includes(
      error.refusal,
    );
    const body = { error: error.refusal };
    return conflict
      ? new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body })
      : new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  return error;
}
