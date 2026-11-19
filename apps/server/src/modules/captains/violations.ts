// AP §9.7.6, CA §11.3 (slice 2.36b): the conduct ladder's pure rules.

// «تنبيه», «إيقاف يوم», «إيقاف 7 أيام», «إنهاء التعاقد», in order.
export const violationSteps = ['warning', 'suspension_1d', 'suspension_7d', 'termination'] as const;
export type ViolationStep = (typeof violationSteps)[number];

// An appeal's outcome (AP §9.7.5): accepted voids the violation.
export const appealOutcomes = ['accepted', 'rejected'] as const;
export type AppealOutcome = (typeof appealOutcomes)[number];

// The step's words, in the push (CA §14 #25) and the suspension's reason.
export const STEP_LABELS: Record<ViolationStep, string> = {
  warning: 'تنبيه',
  suspension_1d: 'إيقاف يوم',
  suspension_7d: 'إيقاف 7 أيام',
  termination: 'إنهاء التعاقد',
};

const SUSPENSION_DAYS: Partial<Record<ViolationStep, number>> = {
  suspension_1d: 1,
  suspension_7d: 7,
};

// The next step: each violation not voided recorded within the window moves
// the ladder one step, up to termination; a severe type (theft, harassment,
// violence) terminates at once. The admin confirms or picks another.
export function suggestedStep(
  earlier: readonly { recordedAt: Date; voided: boolean }[],
  rule: { severe: boolean; windowDays: number; now: Date },
): ViolationStep {
  if (rule.severe) return 'termination';
  const since = rule.now.getTime() - rule.windowDays * 86_400_000;
  const counted = earlier.filter(
    (each) => !each.voided && each.recordedAt.getTime() > since,
  ).length;
  return violationSteps[Math.min(counted, violationSteps.length - 1)]!;
}

// The end of the suspension a confirmed step sets (owner decision
// 2026-11-19), or null for a step that suspends no one by days.
export function suspensionEnd(step: ViolationStep, now: Date): Date | null {
  const days = SUSPENSION_DAYS[step];
  return days === undefined ? null : new Date(now.getTime() + days * 86_400_000);
}
