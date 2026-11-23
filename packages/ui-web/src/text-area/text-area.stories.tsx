import type { Meta, StoryObj } from '@storybook/react-vite';
import { TextArea, type TextAreaProps } from './text-area';

const meta = {
  title: 'TextArea',
  component: TextArea,
  args: { label: 'ملاحظات للمطعم', placeholder: 'اكتب ملاحظتك' },
} satisfies Meta<typeof TextArea>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<TextAreaProps> = {}): Story => ({ args });

export const Default = make({ hint: 'مثلاً: بدون بصل' });
export const Hover = make();
export const Focus = make();
export const Filled = make({
  defaultValue: 'من فضلكم بدون بصل، وزيادة صلصة الثوم.\nشكراً لكم.',
});
export const Invalid = make({ defaultValue: 'ملاحظة', error: 'الملاحظة أقصر من اللازم' });
export const Disabled = make({ disabled: true });
export const Counter = make({
  maxLength: 200,
  defaultValue: 'من فضلكم بدون بصل',
  optionalLabel: '(اختياري)',
});
export const Growing = make({
  defaultValue: 'سطر أول\nسطر ثانٍ\nسطر ثالث\nسطر رابع\nسطر خامس',
});
