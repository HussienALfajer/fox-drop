import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { menuKey } from './restaurant-menu.js';

// AP §9.6.6 «استيراد من Excel» (slice 2.31): the template filled with the
// menu, the upload, the validation report with the dry run, then the import.
export type ImportPlan = components['schemas']['AdminMenuImportPlanDto_Output'];
export type ImportResult = components['schemas']['AdminMenuImportResultDto_Output'];

export const XLSX_TYPE = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
// The server's bound (decided by us, slice 2.31).
export const MAX_IMPORT_BYTES = 2 * 1024 * 1024;

export type ImportFileProblem = 'type' | 'size';

export function importFileProblem(file: { name: string; type: string; size: number }) {
  if (file.type !== XLSX_TYPE && !file.name.toLowerCase().endsWith('.xlsx')) {
    return 'type' satisfies ImportFileProblem;
  }
  if (file.size > MAX_IMPORT_BYTES) return 'size' satisfies ImportFileProblem;
  return null;
}

// The workbook from its base64, ready to save.
export function workbookBlob(contentBase64: string): Blob {
  const bytes = Uint8Array.from(atob(contentBase64), (character) => character.charCodeAt(0));
  return new Blob([bytes], { type: XLSX_TYPE });
}

export function useTemplate(restaurantId: string) {
  return useMutation({
    mutationFn: async (): Promise<{ fileName: string; blob: Blob }> => {
      const { data } = await api.GET(
        '/v1/admin/restaurant-drafts/{restaurantId}/menu/import-template',
        { params: { path: { restaurantId } } },
      );
      if (!data) throw new Error('The template read failed.');
      return { fileName: data.fileName, blob: workbookBlob(data.contentBase64) };
    },
  });
}

export type DryRun =
  { status: 'report'; uploadId: string; plan: ImportPlan } | { status: 'refused'; refusal: string };

function refusalOf(error: unknown): string {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return typeof refusal === 'string' ? refusal : 'invalid';
}

const REFUSED = [400, 403, 404, 409, 422];

// Architecture §5.8: the workbook goes straight to the storage on the
// panel's own origin with the signed PUT (not the API, so not through the
// API client), then the server reads it for the report.
export function useDryRun(restaurantId: string) {
  return useMutation({
    mutationFn: async (file: File): Promise<DryRun> => {
      const asked = await api.POST('/v1/admin/uploads', {
        body: { purpose: 'menu_import', contentType: XLSX_TYPE, sizeBytes: file.size },
      });
      if (!asked.data) throw new Error('The upload was not signed.');
      const put = await fetch(asked.data.url, {
        method: 'PUT',
        body: file,
        headers: { 'Content-Type': XLSX_TYPE },
      });
      if (!put.ok) return { status: 'refused', refusal: 'upload_failed' };
      const { data, error, response } = await api.POST(
        '/v1/admin/restaurant-drafts/{restaurantId}/menu/import/dry-run',
        { params: { path: { restaurantId } }, body: { uploadId: asked.data.uploadId } },
      );
      if (data) return { status: 'report', uploadId: asked.data.uploadId, plan: data };
      if (REFUSED.includes(response.status))
        return { status: 'refused', refusal: refusalOf(error) };
      throw new Error(`The dry run failed (${response.status}).`);
    },
  });
}

export type Imported =
  { status: 'done'; result: ImportResult } | { status: 'refused'; refusal: string };

// One Idempotency-Key per upload until an answer arrives (architecture §5.3).
export function useImport(restaurantId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (uploadId: string): Promise<Imported> => {
      let key = keys.current.get(uploadId);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(uploadId, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/restaurant-drafts/{restaurantId}/menu/import',
        {
          params: { path: { restaurantId }, header: { 'Idempotency-Key': key } },
          body: { uploadId },
        },
      );
      if (data) {
        keys.current.delete(uploadId);
        return { status: 'done', result: data };
      }
      if (REFUSED.includes(response.status)) {
        keys.current.delete(uploadId);
        return { status: 'refused', refusal: refusalOf(error) };
      }
      throw new Error(`The import failed (${response.status}).`);
    },
    onSuccess: (result) => {
      if (result.status !== 'done') return;
      void queryClient.invalidateQueries({ queryKey: menuKey(restaurantId) });
      void queryClient.invalidateQueries({ queryKey: ['restaurant-price-log', restaurantId] });
    },
  });
}

// Whether the plan can be imported: no file error, no row error, something
// to add or change.
export function importable(plan: ImportPlan): boolean {
  return (
    plan.fileError === null &&
    plan.errors.length === 0 &&
    plan.added.length + plan.changed.length > 0
  );
}
