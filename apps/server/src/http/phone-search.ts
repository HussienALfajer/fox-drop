// A searched text as a phone number (the cash desk's and the tickets' party
// search): a Syrian or Turkish mobile, or an international number; null
// when the text is a part of a name.
export function phoneOf(text: string): string | null {
  const compact = text.replace(/[\s-]/g, '');
  if (/^(\+|00)\d{8,15}$/.test(compact)) return compact.replace(/^00/, '+');
  if (/^09\d{8}$/.test(compact)) return `+963${compact.slice(1)}`;
  if (/^05\d{9}$/.test(compact)) return `+90${compact.slice(1)}`;
  return null;
}
