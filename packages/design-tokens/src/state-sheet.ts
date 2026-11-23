// Draws «Interaction states — one system» for the owner's review (architecture
// §9.9 step 3), a third artboard of the «Component proposals» canvas. The
// approved Button hover (a 50% mix of fill and pressed) measured ΔE2000 3.3 on
// primary and 1.3 on ghost: below what an eye notices. The sheet proposes one
// state model for every interactive component, three ways, live (hover and
// press them on the canvas) and measured. The colours are proposals for
// `state.*` tokens over existing primitives; none is a token yet.
import { distance } from './color.ts';
import { card, esc, heading, label, page, v, type Board, type GuideConfig } from './guide.ts';
import type { Icon } from './icons.ts';
import type { Theme, Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

const W = 1680;
/** The proposed rule: hover at least this far from rest, pressed this far beyond hover. */
const MIN_HOVER = 8;
const MIN_PRESS = 5;

// Primitives the proposal draws on (tokens/primitive/color.json).
const P = {
  orange400: '#FF6E31',
  orange500: '#EA580C',
  orange600: '#C2410C',
  red600: '#BF2929',
  red800: '#8C1530',
  blue50: '#EEF4FC',
  blue100: '#D6E4F7',
  blue200: '#ADC9EE',
  blue300: '#7AA6E0',
  blue500: '#03428E',
  ink: '#1F1C18',
  ivory: '#FFFAED',
  ground: '#FBF2E7',
  raised: '#FEFEFE',
  surfacePressed: '#F5EFE2',
  borderStrong: '#6688B2',
  border: '#D3D6D9',
};

function mix(a: string, b: string, t: number): string {
  const ch = (hex: string) => [1, 3, 5].map((i) => Number.parseInt(hex.slice(i, i + 2), 16));
  const [x, y] = [ch(a), ch(b)];
  return `#${x
    .map((value, i) =>
      Math.round(value * (1 - t) + y[i]! * t)
        .toString(16)
        .padStart(2, '0'),
    )
    .join('')
    .toUpperCase()}`;
}

type Role = 'primary' | 'secondary' | 'danger' | 'ghost' | 'chip' | 'row';

interface States {
  /** The ground the control sits on, for a transparent rest. */
  rest: string;
  hover: string;
  pressed: string;
  fg: string;
  border?: string;
  borderHover?: string;
}

interface System {
  key: 'a' | 'b' | 'c';
  name: string;
  note: string;
  motion: boolean;
  roles: Record<Role, States>;
  points: string[];
}

const today: Record<'primary' | 'secondary' | 'danger' | 'ghost', States> = {
  primary: {
    rest: P.orange400,
    hover: mix(P.orange400, P.orange500, 0.5),
    pressed: P.orange500,
    fg: P.ivory,
  },
  secondary: {
    rest: P.raised,
    hover: mix(P.raised, P.surfacePressed, 0.5),
    pressed: P.surfacePressed,
    fg: P.blue500,
  },
  danger: { rest: P.red600, hover: mix(P.red600, P.red800, 0.5), pressed: P.red800, fg: '#FFFFFF' },
  ghost: {
    rest: P.ground,
    hover: mix(P.ground, P.surfacePressed, 0.6),
    pressed: P.surfacePressed,
    fg: P.blue500,
  },
};

// A: one ink layer over everything, the way Material's state layers work.
const layer = (rest: string, ink: string, hover: number, pressed: number, fg: string) => ({
  rest,
  hover: mix(rest, ink, hover),
  pressed: mix(rest, ink, pressed),
  fg,
});

// B and C: tonal steps inside the brand's own ramps; light controls take the
// brand blue's tint, so a pointer over anything says "this is blue, honest,
// clickable", and the outlined button's edge turns full blue.
const tonal: Record<Role, States> = {
  primary: {
    rest: P.orange400,
    hover: mix(P.orange400, P.orange600, 0.6),
    pressed: P.orange600,
    fg: P.ivory,
  },
  // On the raised white, blue 50 is only ΔE 4.7 away: start one step deeper.
  secondary: {
    rest: P.raised,
    hover: P.blue100,
    pressed: P.blue200,
    fg: P.blue500,
    border: P.borderStrong,
    borderHover: P.blue500,
  },
  danger: {
    rest: P.red600,
    hover: mix(P.red600, P.red800, 0.7),
    pressed: mix(P.red800, P.ink, 0.3),
    fg: '#FFFFFF',
  },
  ghost: { rest: P.ground, hover: P.blue50, pressed: P.blue100, fg: P.blue500 },
  chip: { rest: P.ivory, hover: P.blue50, pressed: P.blue100, fg: P.blue500 },
  row: { rest: P.raised, hover: P.blue100, pressed: P.blue200, fg: P.blue500 },
};

const SYSTEMS: System[] = [
  {
    key: 'a',
    name: 'أ — طبقة حبر موحّدة',
    note: 'state layer: ink 22% / 36% over fills, blue 16% / 28% over light',
    motion: false,
    roles: {
      primary: layer(P.orange400, P.ink, 0.22, 0.36, P.ivory),
      secondary: {
        ...layer(P.raised, P.blue500, 0.16, 0.28, P.blue500),
        border: P.borderStrong,
        borderHover: P.borderStrong,
      },
      danger: layer(P.red600, P.ink, 0.22, 0.36, '#FFFFFF'),
      ghost: layer(P.ground, P.blue500, 0.16, 0.28, P.blue500),
      chip: layer(P.ivory, P.blue500, 0.16, 0.28, P.blue500),
      row: layer(P.raised, P.blue500, 0.16, 0.28, P.blue500),
    },
    points: [
      'قاعدة واحدة بسيطة لكل مكوّن: طبقة شفافة فوق اللون.',
      'تعكّر البرتقالي نحو البني، فيفقد شيئاً من دفئه.',
      'الأحمر لا يبلغ الحد: الطبقة الداكنة فوقه تُعتمه ولا تُظهر فرقاً كافياً.',
      'لون فقط، بلا حركة.',
    ],
  },
  {
    key: 'b',
    name: 'ب — تدرّج العلامة',
    note: 'tonal steps in the orange and red ramps; blue tint over light controls',
    motion: false,
    roles: tonal,
    points: [
      'البرتقالي يغمق داخل درجاته هو، فيبقى برتقالياً.',
      'كل ما هو فاتح يأخذ مسحة الأزرق عند التمرير: الأزرق لون الثقة في هويتنا.',
      'حافة الزر الثانوي تصير زرقاء كاملة عند التمرير.',
      'لون فقط، بلا حركة.',
    ],
  },
  {
    key: 'c',
    name: 'ج — تدرّج العلامة مع حركة',
    note: 'B plus motion: press sinks to 97%, the end arrow nudges, a card lifts; 200 ms standard easing; off under reduced motion',
    motion: true,
    roles: tonal,
    points: [
      'ألوان «ب» نفسها، ومعها حركة صغيرة تجعل الواجهة حيّة.',
      'الضغط: الزر ينكمش إلى 97٪ لحظةً كأنه يُضغط فعلاً.',
      'السهم في آخر الصف يتقدّم 2 بكسل نحو وجهته عند التمرير.',
      'البطاقة ترتفع 2 بكسل بظل ناعم (البطاقات فقط؛ الزر يبقى بلا ظل كما اعتمدت).',
      'تتوقف الحركة لمن فعّل «تقليل الحركة»، ويبقى اللون.',
    ],
  },
];

const ROLE_AR: Record<Role, string> = {
  primary: 'أساسي',
  secondary: 'ثانوي',
  danger: 'خطر',
  ghost: 'شفاف',
  chip: 'وسم',
  row: 'صف قائمة',
};

const CSS = `
.fx{border:0;margin:0;font:inherit;text-align:start;background:var(--rest);color:var(--fg);box-shadow:inset 0 0 0 var(--bw,0) var(--bd,transparent);cursor:pointer;user-select:none;
  transition:background-color 200ms cubic-bezier(0.2,0,0,1),box-shadow 200ms cubic-bezier(0.2,0,0,1),transform 100ms cubic-bezier(0.2,0,0,1)}
.fx:hover{background:var(--hover);--bd:var(--bdh,var(--bd0,transparent))}
.fx:active{background:var(--pressed)}
.fx .nudge{transition:transform 200ms cubic-bezier(0.2,0,0,1)}
.motion .fx.press:active{transform:scale(0.97)}
.motion .fx:hover .nudge{transform:translateX(-2px)}
.motion .lift{transition:transform 200ms cubic-bezier(0.2,0,0,1),box-shadow 200ms cubic-bezier(0.2,0,0,1)}
.motion .lift:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(31,28,24,0.12)}
.fx:focus-visible{outline:2px solid ${P.blue500};outline-offset:2px}
@media (prefers-reduced-motion: reduce){.motion .fx,.motion .lift,.motion .nudge{transition:background-color 200ms;transform:none!important}}
`;

function svg(icon: Icon, size: number, flip = false, cls = ''): string {
  const transform = flip ? ' style="transform: scaleX(-1)"' : '';
  return `<svg class="${cls}" aria-hidden="true" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"${transform}>${icon.paths.map((d) => `<path d="${d}"/>`).join('')}</svg>`;
}

const vars = (s: States) =>
  `--rest:${s.rest};--hover:${s.hover};--pressed:${s.pressed};--fg:${s.fg};${s.border ? `--bw:1px;--bd:${s.border};--bd0:${s.border};--bdh:${s.borderHover ?? s.border};` : ''}`;

function pill(s: States, text: string, height = 50, extra = ''): string {
  return `<button type="button" class="fx press" style="${vars(s)} display:inline-flex;align-items:center;justify-content:center;gap:8px;min-height:${height}px;padding-inline:16px;border-radius:999px;font-size:17px;font-weight:500;white-space:nowrap">${extra}${esc(text)}</button>`;
}

function circle(s: States, icon: Icon): string {
  return `<button type="button" aria-label="${esc(icon.name)}" class="fx press" style="${vars(s)} display:inline-flex;align-items:center;justify-content:center;width:50px;height:50px;padding:0;border-radius:999px">${svg(icon, 24)}</button>`;
}

function chip(s: States, text: string): string {
  return `<button type="button" class="fx press" style="${vars(s)} display:inline-flex;align-items:center;height:32px;padding-inline:12px;border-radius:999px;font-size:14px;font-weight:500">${esc(text)}</button>`;
}

function listRow(s: States, icons: (n: string) => Icon, title: string, meta: string): string {
  return `<button type="button" class="fx" style="${vars(s)} display:flex;align-items:center;gap:12px;width:100%;padding:12px 16px;border-radius:15px">${svg(icons('restaurant'), 24)}<span style="flex:1;display:flex;flex-direction:column"><span style="font-weight:700">${esc(title)}</span><span style="font-size:13px">${esc(meta)}</span></span>${svg(icons('back'), 20, false, 'nudge')}</button>`;
}

function dishCard(s: States, title: string, price: string): string {
  return `<button type="button" class="fx lift" style="${vars(s)} --bw:1px;--bd:${P.border};--bd0:${P.border};--bdh:${P.blue300}; display:flex;flex-direction:column;gap:8px;width:170px;padding:12px;border-radius:15px"><span style="display:block;width:100%;height:86px;border-radius:10px;background:${P.surfacePressed}"></span><span style="font-weight:700">${esc(title)}</span><span style="font-weight:700">${esc(price)}</span></button>`;
}

const swatch = (colour: string, fg: string, text: string) =>
  `<span style="display:inline-flex;align-items:center;justify-content:center;min-width:58px;height:28px;padding-inline:6px;border-radius:8px;background:${colour};color:${fg};font-size:12px;box-shadow:inset 0 0 0 1px rgba(3,66,142,.15)">${text}</span>`;

function measure(s: States): string {
  const h = distance(s.rest, s.hover);
  const p = distance(s.hover, s.pressed);
  const mark = (value: number, min: number) =>
    `<b style="color:${value >= min ? '#067647' : P.red600}">${value.toFixed(1)}</b>`;
  return `<div style="display:flex;align-items:center;gap:6px;font-size:12px;color:${P.blue500}">${swatch(s.rest, s.fg, 'عادي')}${swatch(s.hover, s.fg, 'تمرير')}${swatch(s.pressed, s.fg, 'ضغط')}<span style="margin-inline-start:6px" dir="ltr">ΔE ${mark(h, MIN_HOVER)} · +${mark(p, MIN_PRESS)}</span></div>`;
}

export function stateSheet(themes: Themes, config: GuideConfig, icons: Icon[]): Board {
  const icon = (name: string) => icons.find((i) => i.name === name)!;
  const h2 = (text: string, note = '') =>
    `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(text)} ${note ? label(themes, note) : ''}</h2>`;

  const problem = card(
    themes,
    h2(
      'لماذا لا يُرى التمرير اليوم',
      `ΔE2000 from rest; under about 5 the eye barely notices. Proposed rule: hover ≥ ${MIN_HOVER}, pressed ≥ ${MIN_PRESS} beyond hover`,
    ) +
      `<div style="display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:${v(themes, 'space.lg')}">${(
        ['primary', 'secondary', 'danger', 'ghost'] as const
      )
        .map(
          (role) =>
            `<div style="display:flex;flex-direction:column;gap:10px;align-items:flex-start"><div style="font-weight:700">${ROLE_AR[role]}</div>${pill(today[role], 'مرّر هنا')}${measure(today[role])}</div>`,
        )
        .join('')}</div>`,
  );

  const column = (s: System) =>
    `<div class="${s.motion ? 'motion' : ''}" style="flex:1;min-width:0;display:flex;flex-direction:column;gap:18px;padding:${v(themes, 'space.lg')};border-radius:${v(themes, 'radius.lg')};background:${P.ground};border:1px solid ${P.border}">
<div style="font-size:22px;font-weight:700;color:${P.blue500}">${esc(s.name)}</div>${label(themes, s.note)}
<div style="display:flex;flex-wrap:wrap;gap:10px">${pill(s.roles.primary, 'اطلب الآن', 50, svg(icon('cart'), 24))}${pill(s.roles.secondary, 'عرض القائمة')}</div>
<div style="display:flex;flex-wrap:wrap;gap:10px;align-items:center">${pill(s.roles.danger, 'إلغاء الطلب')}${pill(s.roles.ghost, 'تخطي')}${circle(s.roles.secondary, icon('close'))}${circle(s.roles.primary, icon('add'))}</div>
<div style="display:flex;flex-wrap:wrap;gap:8px">${chip(s.roles.chip, 'برغر')}${chip(s.roles.chip, 'بيتزا')}${chip(s.roles.chip, 'حلويات')}${chip(s.roles.chip, 'مشاوي')}</div>
<div style="display:flex;flex-direction:column;gap:6px">${listRow(s.roles.row, icon, 'مطعم الشام', 'مشاوي · 25 دقيقة')}${listRow(s.roles.row, icon, 'فطائر الريف', 'معجنات · 15 دقيقة')}</div>
<div style="display:flex;gap:10px">${dishCard(s.roles.row, 'شاورما دجاج', '450 ₺')}${dishCard(s.roles.row, 'فلافل', '120 ₺')}</div>
<div style="display:flex;flex-direction:column;gap:8px">${(['primary', 'secondary', 'danger', 'ghost', 'chip', 'row'] as const).map((role) => `<div style="display:flex;align-items:center;gap:8px"><span style="width:64px;font-size:13px;font-weight:700">${ROLE_AR[role]}</span>${measure(s.roles[role])}</div>`).join('')}</div>
<ul style="margin:0;padding-inline-start:20px;line-height:1.7">${s.points.map((p) => `<li>${esc(p)}</li>`).join('')}</ul>
</div>`;

  const systems = card(
    themes,
    h2(
      'ثلاثة أنظمة — مرّر المؤشر واضغط على كل شيء',
      'live: hover, press and Tab through every control; the numbers below each column are measured',
    ) +
      `<div style="display:flex;gap:${v(themes, 'space.lg')};align-items:stretch">${SYSTEMS.map(column).join('')}</div>`,
  );

  const rules = card(
    themes,
    h2(
      'القواعد المقترحة لكل المكوّنات',
      'design system level: one state model, measured, test-enforced',
    ) +
      `<ol style="margin:0;padding-inline-start:24px;display:flex;flex-direction:column;gap:${v(themes, 'space.xs')};line-height:1.7">
<li>نموذج حالات واحد لكل ما يُضغط: الأزرار، الوسوم، الصفوف، البطاقات، التبويبات، الحقول. لكل دور توكنات <span dir="ltr">state.&lt;role&gt;.hover / pressed</span> في design-tokens، ولا يخترع مكوّن لوناً خاصاً به.</li>
<li>قاعدة قابلة للقياس: التمرير يبعد عن العادي ΔE ≥ ${MIN_HOVER}، والضغط يبعد عن التمرير ≥ ${MIN_PRESS}. اختبار في design-tokens يفشل إن خالفها أي توكن، فلا يعود تمرير غير مرئي أبداً.</li>
<li>تباين النص يبقى محققاً في كل حالة (4.5:1، والبرتقالي باستثنائك المعتمد).</li>
<li>الحركة توكنات: 200 ms للون، 100 ms للضغط، منحنى standard، وتتوقف مع «تقليل الحركة».</li>
<li>على الهاتف لا يوجد تمرير: حالة الضغط هي ما يراه الزبون والكابتن، لذلك يجب أن تكون واضحة بذاتها (Flutter في D.7 يأخذ الألوان نفسها).</li>
<li>التركيز من لوحة المفاتيح يبقى كما هو: حلقة زرقاء 2 بكسل مع فراغ 2 بكسل.</li>
</ol>`,
  );

  const body = [
    `<style>${CSS}</style>`,
    heading(
      themes,
      'حالات التفاعل — نظام واحد لكل المكوّنات',
      'Interaction states (architecture §9.5 R10, §9.9). The approved hover was not visible; three systems for every interactive component, live and measured. The owner picked B «Brand tonal steps» on 2026-11-24 (design-tokens 0.5.0). Sample copy is review text only.',
    ),
    problem,
    systems,
    rules,
  ].join('\n');
  return page(
    themes,
    config,
    {
      file: 'States.dc.html',
      title: 'Interaction states — one system',
      w: W,
      h: 2100,
      interactive: true,
    },
    body,
  );
}
