import type { Decorator, Preview } from '@storybook/react-vite';
import '../src/styles.css';

// Every story renders right to left in Arabic (architecture §9.6). The captain
// surface is `[data-surface="captain"]` in tokens.css; the panel and the phone
// share the default tokens.
const surfaces = ['phone', 'captain', 'panel'] as const;

const inSurface: Decorator = (Story, context) => {
  const surface = context.globals['surface'] as (typeof surfaces)[number];
  return (
    <div dir="rtl" lang="ar" data-surface={surface === 'captain' ? 'captain' : undefined}>
      <Story />
    </div>
  );
};

const preview: Preview = {
  decorators: [inSurface],
  initialGlobals: { surface: 'phone' },
  globalTypes: {
    surface: {
      description: 'The surface a story is shown on',
      toolbar: {
        title: 'Surface',
        icon: 'mobile',
        items: surfaces.map((value) => ({ value, title: value })),
        dynamicTitle: true,
      },
    },
  },
};

export default preview;
