import type { Meta, StoryObj } from '@storybook/react-vite';
import { Button } from '../button/button';
import { Dialog } from './dialog';

const meta = {
  title: 'Dialog',
  component: Dialog,
  args: {
    trigger: <Button variant="secondary">حذف العنوان</Button>,
    title: 'حذف هذا العنوان؟',
    description: '«البيت — حي الشهداء» يُحذف من عناوينك. طلباتك السابقة لا تتغيّر.',
    confirmLabel: 'حذف',
    cancelLabel: 'إلغاء',
    closeLabel: 'إغلاق',
    tone: 'danger',
  },
} satisfies Meta<typeof Dialog>;
export default meta;
type Story = StoryObj<typeof meta>;

const open: Story['play'] = ({ canvasElement }) => {
  canvasElement.querySelector<HTMLButtonElement>('button')!.click();
};

export const Default: Story = {};
// Focus starts on «إلغاء», never on the destructive action.
export const Open: Story = { play: open };
export const Danger: Story = { play: open };
export const Primary: Story = {
  args: {
    trigger: <Button>تأكيد الطلب</Button>,
    title: 'تأكيد الطلب؟',
    description: 'سيصل طلبك خلال 35 دقيقة تقريباً.',
    confirmLabel: 'تأكيد',
    cancelLabel: 'رجوع',
    tone: 'primary',
  },
  play: open,
};
export const Compact: Story = { args: { density: 'compact' }, play: open };
// Its command runs: the confirm button shows Button's loader (the components canvas audit).
export const Pending: Story = { args: { pending: true }, play: open };
