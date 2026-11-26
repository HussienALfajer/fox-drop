import type { Meta, StoryObj } from '@storybook/react-vite';
import { DateField, type DateFieldProps } from './date-field';

const meta = {
  title: 'DateField',
  component: DateField,
  args: {
    label: 'تاريخ الميلاد',
    placeholder: 'اختر التاريخ',
    previousLabel: 'الشهر السابق',
    nextLabel: 'الشهر التالي',
    // Fixed, so the screenshots do not move with the day.
    today: '2027-03-10',
  },
} satisfies Meta<typeof DateField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<DateFieldProps> = {}): Story => ({ args });

export const Default = make({ hint: 'لن يظهر لغيرك' });
export const Hover = make();
export const Focus = make();
// The calendar opens by a click, as a person opens it (D.10: no popup starts open).
export const Open: Story = {
  args: { defaultValue: '2027-03-05' },
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')!.click();
  },
};
export const Filled = make({ defaultValue: '2027-03-05' });
export const Invalid = make({ error: 'اختر تاريخاً صحيحاً' });
export const Disabled = make({ disabled: true, defaultValue: '2027-03-05' });
