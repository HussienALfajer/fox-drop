import type { Meta, StoryObj } from '@storybook/react-vite';
import { AmountsSummary } from '../amounts-summary/amounts-summary';
import { Button } from '../button/button';
import { ConfirmDialog } from './confirm-dialog';

// AP §7.4: cancelling an order in the panel; amounts are review copy.
const meta = {
  title: 'ConfirmDialog',
  component: ConfirmDialog,
  args: {
    trigger: (
      <Button variant="danger" density="compact">
        إلغاء الطلب
      </Button>
    ),
    title: 'إلغاء الطلب #10423',
    reasonLabel: 'السبب',
    reasonPlaceholder: 'اكتب سبب الإلغاء',
    reasonError: 'السبب مطلوب',
    effectTitle: 'أثره على الأرصدة',
    effect: (
      <AmountsSummary
        density="compact"
        symbol="₺"
        lines={[
          { label: 'يُعاد للزبون', amount: '47000', tone: 'success' },
          { label: 'يُخصم من المطعم', amount: '-42000', tone: 'danger' },
          { label: 'عمولة المنصة', amount: '-5000', tone: 'danger' },
        ]}
        total={{ label: 'صافي الأثر', amount: '0' }}
      />
    ),
    notifyTitle: 'سيُبلَّغ',
    notified: ['الزبون', 'المطعم', 'الكابتن'],
    confirmLabel: 'تأكيد الإلغاء',
    cancelLabel: 'تراجع',
    closeLabel: 'إغلاق',
    onConfirm: () => undefined,
  },
} satisfies Meta<typeof ConfirmDialog>;
export default meta;
type Story = StoryObj<typeof meta>;

const open = (canvasElement: HTMLElement) =>
  canvasElement.querySelector<HTMLButtonElement>('button')?.click();

export const Default: Story = {};
export const Empty: Story = { play: ({ canvasElement }) => open(canvasElement) };
// A try without a reason: the error under the field, «تأكيد» still refused.
export const Invalid: Story = {
  play: async ({ canvasElement }) => {
    open(canvasElement);
    await new Promise((done) => setTimeout(done, 300));
    document
      .querySelector<HTMLButtonElement>('[role="alertdialog"] button[aria-disabled="true"]')
      ?.click();
  },
};
export const Filled: Story = {
  play: async ({ canvasElement }) => {
    open(canvasElement);
    await new Promise((done) => setTimeout(done, 300));
    const input = document.querySelector<HTMLInputElement>('[role="alertdialog"] input');
    if (!input) return;
    const setValue = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value')?.set;
    setValue?.call(input, 'الزبون طلب الإلغاء عبر الدعم');
    input.dispatchEvent(new Event('input', { bubbles: true }));
  },
};
