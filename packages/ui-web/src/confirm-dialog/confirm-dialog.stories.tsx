import type { Meta, StoryObj } from '@storybook/react-vite';
import { waitFor } from 'storybook/test';
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

// Opens the dialog from its trigger; a missing trigger fails the story.
const open = (canvasElement: HTMLElement) => {
  canvasElement.querySelector<HTMLButtonElement>('button')!.click();
};

// An element of the open dialog, once it is there: the dialog opens after the
// click, so a play waits for it (a fixed 300 ms once missed it on CI and shot
// «Invalid» without its error), and fails when it never comes.
const inDialog = <T extends Element>(selector: string) =>
  waitFor(
    () => {
      const found = document.querySelector<T>(`[role="alertdialog"] ${selector}`);
      if (!found) throw new Error(`the open dialog has no ${selector}`);
      return found;
    },
    { timeout: 5_000 },
  );

export const Default: Story = {};
export const Empty: Story = { play: ({ canvasElement }) => open(canvasElement) };
// The components canvas draws these open, before what their play types or presses.
const gesture = { canvas: { gesture: true } };

// A try without a reason: the error under the field, «تأكيد» still refused.
export const Invalid: Story = {
  parameters: gesture,
  play: async ({ canvasElement }) => {
    open(canvasElement);
    (await inDialog<HTMLButtonElement>('button[aria-disabled="true"]')).click();
  },
};
export const Filled: Story = {
  parameters: gesture,
  play: async ({ canvasElement }) => {
    open(canvasElement);
    const input = await inDialog<HTMLInputElement>('input');
    Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value')!.set!.call(
      input,
      'الزبون طلب الإلغاء عبر الدعم',
    );
    input.dispatchEvent(new Event('input', { bubbles: true }));
  },
};
// Its command runs: the confirm button shows Button's loader (the components canvas audit).
export const Pending: Story = {
  args: { pending: true },
  play: ({ canvasElement }) => open(canvasElement),
};
