// The Arabic copy of the "Fox Drop Components" canvas, and only that: the
// group names, the section headings, the words of state and story names, and
// what each component is for. The owner approved keeping this copy in one data
// file of the generator (2026-11-26), an exception to English-only storage;
// code, identifiers and component code names stay English.

/** The Design System card groups (`@dsCard group=` of design-system/<Name>/preview.html). */
export const GROUPS: Record<string, string> = {
  Actions: 'الإجراءات',
  Icons: 'الأيقونات',
  Forms: 'النماذج',
  Navigation: 'التنقّل',
  Overlays: 'الطبقات المنبثقة',
  Data: 'عرض البيانات',
  Feedback: 'الإشعار والتحميل',
};

export const PAGES = {
  components: 'مكوّنات فوكس دروب',
  proposals: 'المكوّنات المقترحة',
};

export const TEXT = {
  component: 'مكوّن',
  use: 'متى يُستخدم',
  avoid: 'متى لا يُستخدم',
  code: 'في الكود',
  readers: 'يقرأ رموزه',
  readersNone: 'لا ملف رموز خاص به',
  flutter: 'له توأم في Flutter',
  webOnly: 'للويب فقط',
  playground: 'جرّبه',
  playgroundNote:
    'نسخة حيّة: غيّر خصائصها من اللوحة بجانبها. ما تغيّره لك وحدك ويذهب عند إعادة التحميل.',
  props: 'الخصائص',
  reset: 'إعادة الضبط',
  scenarios: 'من قصصه',
  surfaces: 'الأسطح',
  surfacesNote: 'النسخة نفسها على كل سطح، بلا تبديل.',
  phone: 'الهاتف',
  captain: 'الكابتن · تباين 7:1',
  panel: 'اللوحة والبوابة',
  panelCompact: 'اللوحة والبوابة · مضغوط',
  states: 'الحالات',
  statesNote:
    'كل خلية قصةٌ من قصص المكوّن. التحويم والضغط وتركيز لوحة المفاتيح مثبّتة للعرض بقواعد CSS الخاصة بالمكوّن نفسه؛ وكل نسخة أخرى حيّة.',
  anatomy: 'التشريح والمقاسات',
  anatomyNote:
    'من رموز المكوّن: كل جزء ومقاسه ولونه في كل حالة، باسم الرمز وقيمته في المظهر الفاتح.',
  part: 'الجزء',
  rest: 'السكون',
  open: 'مفتوحة داخل اللوحة',
  none: 'بلا',
  yes: 'نعم',
  no: 'لا',
};

/**
 * The words of the state and story names (`PrimaryHover`, `readOnly`,
 * `WithIconStart`), lower case: a caption is its words in Arabic, in order.
 */
export const WORDS: Record<string, string> = {
  default: 'الافتراضي',
  hover: 'تحويم',
  focus: 'تركيز لوحة المفاتيح',
  pressed: 'ضغط',
  disabled: 'معطّل',
  loading: 'تحميل',
  comfortable: 'مريح',
  compact: 'مضغوط',
  primary: 'أساسي',
  secondary: 'ثانوي',
  danger: 'خطر',
  ghost: 'شفّاف',
  filled: 'معبّأ',
  invalid: 'خطأ',
  optional: 'اختياري',
  open: 'مفتوح',
  preparing: 'قيد التحضير',
  late: 'متأخر',
  read: 'للقراءة',
  only: 'فقط',
  count: 'عدد',
  overflow: 'فائض',
  pill: 'حبّة',
  with: 'مع',
  icon: 'أيقونة',
  start: 'في البداية',
  end: 'في النهاية',
  back: 'رجوع',
  both: 'اثنتين',
  icons: 'أيقونتين',
  presseable: 'يعدّ الضغطات',
  selected: 'محدّد',
  checked: 'مؤشَّر',
  active: 'نشط',
  'read only': 'للقراءة فقط',
  'icon only': 'أيقونة وحدها',
  'with icon': 'بأيقونة',
  'with both icons': 'بأيقونتين',
  'with icon start': 'بأيقونة في البداية',
  'with icon end': 'بأيقونة في النهاية',
  'with icon back': 'بأيقونة الرجوع',
};

export interface ComponentCopy {
  /** What it is, in a sentence. */
  desc: string;
  use: string;
  avoid: string;
}

export const COMPONENTS: Record<string, ComponentCopy> = {
  Button: {
    desc: 'زرّ كل شاشة في فوكس دروب: إجراء واحد بأربعة أشكال وكثافتين وكل حالات الضغط.',
    use: 'لإجراء يغيّر شيئاً: تأكيد الطلب، إضافة عنوان، إلغاء. «أساسي» واحد في كل شاشة، و«خطر» لما يحذف أو يلغي، و«شفّاف» للمكان الثالث.',
    avoid:
      'للانتقال إلى صفحة أخرى (رابط نصّي)، أو أيقونة وحدها بلا اسم يقرؤه قارئ الشاشة، أو الكثافة المضغوطة على الهاتف.',
  },
  TextField: {
    desc: 'سطر نصّ واحد في حبّة، مع عنوانه وتلميحه وخطئه.',
    use: 'لاسم أو بريد أو عنوان قصير؛ «اختياري» بجانب العنوان لحقل غير مطلوب.',
    avoid:
      'لنصّ طويل (حقل متعدد الأسطر)، أو رقم هاتف أو رمز تحقّق (حقولها الخاصة)، أو بحث (حقل البحث).',
  },
  Dialog: {
    desc: 'سؤال يوقف الصفحة حتى يُجاب: عنوان ووصف وإجراءان فوق الستار.',
    use: 'لتأكيد إجراء لا يُتراجع عنه: حذف عنوان، إلغاء طلب. يبدأ التركيز على الإجراء الآمن.',
    avoid:
      'لرسالة لا تنتظر جواباً (إشعار عابر)، أو نموذج طويل (صفحة أو درج جانبي)، أو سبب إلغاء مطلوب (حوار التأكيد بسبب).',
  },
  OrderCard: {
    desc: 'بطاقة الطلب المختصرة في لوحة طلبات المطعم.',
    use: 'في أعمدة لوحة الطلبات: رقم الطلب ومنذ متى، الأصناف، الكابتن، المؤقّت وإجراء واحد.',
    avoid:
      'في قائمة طلبات الزبون (صفّ الطلب)، أو لصفحة الطلب الكاملة؛ وبوابة المالك تعرضها للقراءة فقط بلا إجراء.',
  },
  Tabs: {
    desc: 'تبويبات لصفحات التفاصيل واللوحات: بخطّ تحت المحدّد، أو حبّات للزبون.',
    use: 'لأقسام صفحة واحدة يقرؤها المستخدم واحداً بعد آخر: التفاصيل، المالية، السجل.',
    avoid:
      'للتنقّل بين صفحات التطبيق (شريط التنقّل السفلي أو الشريط الجانبي)، أو لخيارات نموذج (مجموعة الاختيار).',
  },
};
