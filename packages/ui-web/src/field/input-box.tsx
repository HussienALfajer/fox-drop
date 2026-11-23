import { InputGroup } from '@ui-sdk/react/input';
import type { ReactNode } from 'react';
import { box, boxState, type Density } from './styles';

export interface InputBoxProps {
  density?: Density;
  shape?: 'pill' | 'area';
  invalid?: boolean;
  disabled?: boolean;
  /** At the start of the input (right in RTL). */
  start?: ReactNode;
  /** At the end of the input (left in RTL). */
  end?: ReactNode;
  /** Right to left or left to right inside the box, for a phone number. */
  dir?: 'ltr' | 'rtl';
  /** The input; it takes the `inputClass`. */
  children: ReactNode;
}

/**
 * The pill or the box of a text field: the UI SDK's InputGroup, so a press on
 * the icons focuses the input and `InputClear` works inside it. Internal.
 */
export function InputBox(props: InputBoxProps) {
  const { density, shape, invalid, disabled, start, end, dir, children } = props;
  return (
    <InputGroup
      {...(dir && { dir })}
      className={box({ density, shape, state: boxState(disabled, invalid) })}
    >
      {start}
      {children}
      {end}
    </InputGroup>
  );
}
