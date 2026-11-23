import { Switch as SdkSwitch, SwitchThumb } from '@ui-sdk/react/switch';
import { formTv, keyboardRing } from '../field/styles';

/** The states the stories show (R3). Hover, focus and pressed are driven in the browser by the gate. */
export const STATES = ['default', 'hover', 'focus', 'pressed', 'on', 'disabled'] as const;

const row = formTv({
  base: 'group/row inline-flex min-h-(--fd-input-check-target) items-center gap-sm text-phone-body',
  variants: {
    disabled: {
      true: 'cursor-not-allowed text-(color:--fd-input-color-on-disabled)',
      false: 'cursor-pointer text-(color:--fd-input-color-text)',
    },
  },
});

// The classic track, 52 by 32: off at the start (right in RTL), on slides to
// the end. The thumb is pushed by a spacer that grows when the switch is on, so
// the slide uses logical directions only and animates.
const track = formTv({
  base: [
    'flex h-(--fd-input-switch-height) w-(--fd-input-switch-width) shrink-0 items-center rounded-full p-2xs',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    keyboardRing,
    'data-unchecked:bg-(--fd-input-switch-color-track) data-checked:bg-(--fd-input-switch-color-track-on)',
    'data-disabled:bg-(--fd-input-color-disabled)',
  ],
  variants: {
    interactive: {
      true: [
        'group-hover/row:data-unchecked:bg-(--fd-input-switch-color-track-hover)',
        'group-hover/row:data-checked:bg-(--fd-input-switch-color-track-on-hover)',
        'group-active/row:data-checked:bg-(--fd-input-switch-color-track-on-pressed)',
        'group-active/row:data-unchecked:bg-(--fd-input-switch-color-track-pressed)',
      ],
    },
  },
});

const spacer = formTv({
  base: 'grow-0 transition-all duration-(--fd-duration-base) ease-(--fd-easing-standard) in-data-checked:grow',
});

const thumb = formTv({
  base: 'aspect-square h-full shrink-0 rounded-full bg-(--fd-input-switch-color-thumb) in-data-disabled:bg-(--fd-input-color-on-disabled)',
});

export interface SwitchProps {
  /** What the setting is; it stays the same in both states. */
  label: string;
  checked?: boolean;
  defaultChecked?: boolean;
  onCheckedChange?: (checked: boolean) => void;
  name?: string;
  disabled?: boolean;
}

/** A switch with its label, on the UI SDK's Switch: the whole row is the target. */
export function Switch(props: SwitchProps) {
  const { label, checked, defaultChecked, onCheckedChange, name, disabled = false } = props;
  return (
    <label className={row({ disabled })}>
      <SdkSwitch
        className={track({ interactive: !disabled })}
        {...(checked !== undefined && { checked })}
        {...(defaultChecked !== undefined && { defaultChecked })}
        {...(onCheckedChange && { onCheckedChange: (next: boolean) => onCheckedChange(next) })}
        {...(name && { name })}
        {...(disabled && { disabled })}
      >
        <span aria-hidden="true" className={spacer()} />
        <SwitchThumb className={thumb()} />
      </SdkSwitch>
      {label}
    </label>
  );
}
