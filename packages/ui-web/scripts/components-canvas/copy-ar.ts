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

/** The two pages (architecture §9.8, D.R1): what is approved, and what is drawn for review. */
export const PAGES = {
  components: 'المكوّنات المعتمدة',
  proposals: 'المكوّنات المقترحة',
};

/** The proposals page's note: a component's life cycle (architecture §9.9, D.R1). */
export const PROPOSALS_NOTE =
  'هنا تُرسم مكوّنات الشاشة التي يُعمل عليها، بكل حالاتها، من نظام التصميم وحده، ولا شيء غيرها. يراجعها المالك ويوافق عليها، ثم يوافق عليها المصمم. بعدها يُبنى المكوّن في الويب ثم في Flutter، فتُحذف رسمته من هنا وتنتقل لوحته المولَّدة من الكود إلى «المكوّنات المعتمدة» مع الشاشة المعتمدة.';

/** The index board (index.ts). */
export const INDEX = {
  kicker: 'نظام تصميم فوكس دروب · المكوّنات المعتمدة',
  lead: 'هنا المكوّنات التي وافق عليها المالك ثم المصمم، وبُنيت في الكود، لوحةً لكل مكوّن مع الشاشة المعتمدة التي احتاجته. تُبنى المكوّنات شاشةً شاشة، تطبيق العميل أولاً، فلا يظهر هنا إلا ما احتاجته شاشة معتمدة. لا شيء هنا مرسوم باليد: كل نسخة هي المكوّن الحقيقي من كود النظام (packages/ui-web) محمَّلاً من حزمته.',
  empty: 'لا مكوّن معتمد بعد: أول مكوّن يأتي مع أول شاشة معتمدة من تطبيق العميل.',
  cards: [
    {
      title: 'جرّبه في Play',
      text: 'كل لوحة تعمل: اضغط، اكتب، غيّر الخصائص من اللوحة بجانب النسخة الحيّة، وجرّب قصص المكوّن.',
    },
    {
      title: 'حالات مثبّتة',
      text: 'التحويم والضغط وتركيز لوحة المفاتيح مثبّتة للعرض بقواعد CSS الخاصة بالمكوّن نفسه، والنوافذ مفتوحة داخل لوحتها.',
    },
    {
      title: 'بيانات مصطنعة',
      text: 'الأسماء والأرقام والطلبات مخترعة من قصص المكوّنات، لا بيانات حقيقية.',
    },
  ],
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
  inPlay: 'بالإيماءة في Play، مرسومة هنا قبلها',
  none: 'بلا',
  yes: 'نعم',
  no: 'لا',
};

/**
 * The words of the state and story names (`PrimaryHover`, `readOnly`,
 * `WithIconStart`), lower case: a caption is its words in Arabic, in order.
 * The states of R10 and the densities; a new component adds its own words.
 */
export const WORDS: Record<string, string> = {
  default: 'الافتراضي',
  hover: 'تحويم',
  focus: 'تركيز لوحة المفاتيح',
  pressed: 'ضغط',
  disabled: 'معطّل',
  loading: 'تحميل',
  invalid: 'خطأ',
  comfortable: 'مريح',
  compact: 'مضغوط',
};

export interface ComponentCopy {
  /** What it is, in a sentence. */
  desc: string;
  use: string;
  avoid: string;
}

/** Each approved component's copy, by its name in COMPONENTS (scripts/bundle.ts). */
export const COMPONENTS: Record<string, ComponentCopy> = {};
