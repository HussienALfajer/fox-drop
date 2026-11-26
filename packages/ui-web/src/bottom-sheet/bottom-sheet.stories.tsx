import type { Meta, StoryObj } from '@storybook/react-vite';
import { Button } from '../button/button';
import { BottomSheet } from './bottom-sheet';

// The Flutter twin's cases (D.10), review copy. The open stories keep the sheet
// in their frame (`inline`) so the screenshot and the parity sheet show it.
const options = (
  <div className="flex flex-col gap-sm text-phone-body">
    <p className="m-none text-on-surface-muted">قطعتان مع بطاطس ومشروب</p>
    <Button>أضف إلى السلة</Button>
  </div>
);

const open = {
  play: ({ canvasElement }: { canvasElement: HTMLElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')!.click();
  },
};

const meta = {
  title: 'BottomSheet',
  component: BottomSheet,
  decorators: [(Story) => <div className="max-w-(--fd-size-toast)">{Story()}</div>],
  args: {
    trigger: <Button variant="secondary">اختر الإضافات</Button>,
    title: 'وجبة كريسبي',
    closeLabel: 'إغلاق',
    children: options,
  },
} satisfies Meta<typeof BottomSheet>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Open: Story = { ...open, args: { inline: true } };
// The customer's item sheet: the S-curve tab holds the title (brand expression §2).
export const SCurve: Story = { ...open, args: { inline: true, sCurve: true } };
// In a frame lower than its content: the content scrolls under the title (REVIEW item 15).
export const Long: Story = {
  ...open,
  decorators: [(Story) => <div className="h-(--fd-size-menu-max-height)">{Story()}</div>],
  args: {
    inline: true,
    title: 'اختر المدينة',
    children: (
      <div className="flex flex-col gap-sm text-phone-body">
        {['أعزاز', 'مارع', 'الراعي', 'جرابلس', 'الباب', 'عفرين', 'إدلب', 'حلب'].map((city) => (
          <p key={city} className="m-none">
            {city}
          </p>
        ))}
      </div>
    ),
  },
};
