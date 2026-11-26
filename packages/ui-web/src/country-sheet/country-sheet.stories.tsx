import type { Meta, StoryObj } from '@storybook/react-vite';
import { CountrySheet } from './country-sheet';

const meta = {
  title: 'CountrySheet',
  component: CountrySheet,
  args: {
    value: 'SY',
    onValueChange: () => undefined,
    searchLabel: 'ابحث باسم الدولة أو رمزها',
    pinnedLabel: 'الأكثر استعمالاً',
    lastUsedLabel: 'آخر ما استعملته',
    allLabel: 'كل الدول',
    emptyLabel: 'لا دولة بهذا الاسم أو الرمز',
    children: (
      <CountrySheet.Trigger className="min-h-(--fd-size-touch-target) rounded-full px-sm text-phone-body">
        الدولة: سوريا
      </CountrySheet.Trigger>
    ),
  },
} satisfies Meta<typeof CountrySheet>;
export default meta;
type Story = StoryObj<typeof meta>;

// Every state is the open list: a click opens it, as a person does (D.10).
const open = (args: Story['args'] = {}): Story => ({
  args,
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')!.click();
  },
});

export const Default = open();
export const LastUsed = open({ lastUsed: 'DE' });
export const Search = open({ defaultQuery: 'ألمان' });
export const Empty = open({ defaultQuery: 'zzzz' });
