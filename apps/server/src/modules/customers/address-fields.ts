import { z } from 'zod';
import { phone } from '../identity/index.js';
import { addressLabels } from './schema.js';

// CU §5.3: Arabic or Latin letters, with spaces and «-»; Arabic marks such
// as the shadda may sit on a letter. Two letters at least.
const nameCharacters = /^(?:[A-Za-z -]|(?=\p{Script_Extensions=Arabic})[\p{L}\p{M}])+$/u;
const letter = /(?:[A-Za-z]|(?=\p{Script=Arabic})\p{L})/gu;
export const personName = (max: number) =>
  z
    .string()
    .trim()
    .min(2)
    .max(max)
    .regex(nameCharacters)
    .refine((name) => (name.match(letter) ?? []).length >= 2, 'two letters at least');

const latitude = z.number().min(-90).max(90);
const longitude = z.number().min(-180).max(180);
export const location = z.object({ latitude, longitude });

const text = (min: number, max: number) => z.string().trim().min(min).max(max);

// CU §7.3: a saved address.
export const addressFields = z.object({
  location: location.describe('The pin, inside an active zone (CU §7.1).'),
  label: z.enum(addressLabels).describe('«البيت», «العمل» or «آخر».'),
  customLabel: text(1, 30).nullable().describe('The name of an «آخر» address; null otherwise.'),
  street: text(3, 100).describe('«الشارع والبناء».'),
  floor: text(1, 100).nullable().describe('«الطابق والشقة», optional.'),
  landmark: text(3, 100).describe('«بالقرب من».'),
  contactPhone: phone.nullable().describe("«رقم التواصل»; null is the account's own number."),
  recipientName: personName(60)
    .nullable()
    .describe('«اسم المستلم», needed with another contact number (Q5).'),
  directions: text(1, 200).nullable().describe('«توجيهات للكابتن», optional.'),
});

// CU §7.4: an unsaved address («التوصيل إلى موقعي الحالي») has the fields of
// a saved one but no label.
export const unsavedAddressFields = addressFields.omit({ label: true, customLabel: true });

// Q5: a recipient's name with another contact number.
export const withRecipient = <T extends z.ZodType<z.infer<typeof unsavedAddressFields>>>(
  schema: T,
) =>
  schema.refine((fields) => fields.contactPhone === null || fields.recipientName !== null, {
    message: 'a recipient name is needed with another contact number',
    path: ['recipientName'],
  });

// Q5, and «آخر» with its name.
export const checked = <T extends z.ZodType<z.infer<typeof addressFields>>>(schema: T) =>
  withRecipient(schema).refine(
    (fields) => fields.label !== 'other' || fields.customLabel !== null,
    {
      message: 'an «آخر» address needs its name',
      path: ['customLabel'],
    },
  );
