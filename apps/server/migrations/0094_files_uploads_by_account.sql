-- Slice 2.24a: a customer's report photos asked in the last hour (FilesService.createUpload).
CREATE INDEX "uploads_created_by" ON "files"."uploads" USING btree ("created_by","created_at");