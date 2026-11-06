// Architecture §8.3.3 item 8: one short, fixed message, no links, the same
// structure every time. The approved wordings move to Content (AP §9.13) when
// that module exists.
export function codeMessage(code: string): string {
  return `رمز الدخول إلى FOX DROP: ${code}\nلا تشارك هذا الرمز مع أحد. إن لم تطلبه فتجاهل هذه الرسالة.`;
}

// §8.3.3 item 9: the one answer to someone who writes to a sending number,
// pointing to the support WhatsApp number (SUPPORT_WHATSAPP_NUMBER, until
// Content's contact info exists) or, without it, to the apps' help.
export function replyMessage(supportNumber: string | undefined): string {
  const help = supportNumber
    ? `للمساعدة راسلنا على واتساب الدعم: ${supportNumber}`
    : 'للمساعدة افتح «المساعدة» في تطبيق FOX DROP.';
  return `هذا الرقم يرسل رموز الدخول إلى FOX DROP فقط ولا يقرأ الرسائل.\n${help}`;
}
