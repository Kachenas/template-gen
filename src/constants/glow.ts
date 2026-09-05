/**
 * Glow-color usage rule (locked in the design system):
 * never mix more than one glow color in a single section.
 */
export const GLOW = {
  action: 'cyan', // primary CTAs, results, "yes" states
  automation: 'purple', // AI / automation / n8n content only
  growth: 'emerald', // growth metrics, before/after "up" deltas only
} as const

export type GlowKind = (typeof GLOW)[keyof typeof GLOW]
