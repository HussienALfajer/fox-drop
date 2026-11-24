import type { Meta, StoryObj } from '@storybook/react-vite';
import { Button } from '../button/button';
import { Toaster, useToast, type ToastOptions } from './toaster';

function Show({ toasts }: { toasts: ToastOptions[] }) {
  const toast = useToast();
  return (
    <Button variant="secondary" onClick={() => toasts.forEach((options) => toast.show(options))}>
      أظهر الإشعار
    </Button>
  );
}

const meta = {
  title: 'Toaster',
  component: Toaster,
  args: { label: 'الإشعارات', closeLabel: 'إغلاق', children: null },
} satisfies Meta<typeof Toaster>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (toasts: ToastOptions[], shown = true): Story => ({
  render: (args) => (
    <Toaster {...args}>
      <Show toasts={toasts} />
    </Toaster>
  ),
  ...(shown && {
    play: ({ canvasElement }) => {
      canvasElement.querySelector<HTMLButtonElement>('button')?.click();
    },
  }),
});

// Review copy.
// The trigger alone: the reduced-motion gate presses it itself.
export const Default = make([{ tone: 'success', text: 'حُفظت التغييرات' }], false);
export const Info = make([{ tone: 'info', text: 'نُسخ رقم الطلب' }]);
export const Warning = make([{ tone: 'warning', text: 'الصورة كبيرة، ضغطناها قبل الرفع' }]);
export const Danger = make([
  {
    tone: 'danger',
    text: 'تعذّر الحفظ',
    action: { label: 'أعد المحاولة', onAction: () => undefined },
  },
]);
export const Action = make([
  {
    tone: 'success',
    text: 'أُضيف إلى السلة',
    action: { label: 'عرض السلة', onAction: () => undefined },
  },
]);
export const Stacked = make([
  { tone: 'info', text: 'نُسخ رقم الطلب' },
  { tone: 'success', text: 'حُفظت التغييرات' },
  { tone: 'danger', text: 'تعذّر الحفظ' },
]);
