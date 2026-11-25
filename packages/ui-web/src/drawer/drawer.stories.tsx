import type { Meta, StoryObj } from '@storybook/react-vite';
import { Button } from '../button/button';
import { Tabs } from '../tabs/tabs';
import { Drawer } from './drawer';

// AP §7.4: the panel's quick view of an order from a table; review copy.
const details = (
  <div className="flex flex-col gap-sm p-md text-panel-body">
    <Tabs
      label="الطلب #10421"
      items={[
        {
          value: 'details',
          label: 'التفاصيل',
          content: <p className="m-none">كنافة أعزاز · أحمد ع.</p>,
        },
        { value: 'log', label: 'السجل', content: <p className="m-none">9:38 م · قُبل الطلب</p> },
        {
          value: 'notes',
          label: 'الملاحظات',
          count: 2,
          countLabel: 'ملاحظتان',
          content: <p className="m-none">بلا بصل</p>,
        },
      ]}
    />
  </div>
);

const meta = {
  title: 'Drawer',
  component: Drawer,
  args: {
    trigger: (
      <Button variant="secondary" density="compact">
        عرض الطلب
      </Button>
    ),
    title: 'الطلب #10421',
    closeLabel: 'إغلاق',
    children: details,
  },
} satisfies Meta<typeof Drawer>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// The sidebar's phone form opens from the start side (AP §7.5).
export const Start: Story = {
  args: {
    trigger: <Button variant="secondary" density="compact" icon="menu" label="القائمة" />,
    title: 'التنقل الرئيسي',
    side: 'start',
    children: (
      <p className="m-none p-md text-panel-body">لوحة التحكم · غرفة العمليات · الخريطة الحية</p>
    ),
  },
};
export const Open: Story = {
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')!.click();
  },
};
