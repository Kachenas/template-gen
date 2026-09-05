export const DURATION = {
  fast: 0.15,
  base: 0.3,
  slow: 0.6,
  cinematic: 1.2,
} as const

export const EASE = {
  outExpo: 'expo.out',
  inOutQuart: 'power4.inOut',
  smooth: 'power3.out',
} as const

export const STAGGER = {
  tight: 0.06,
  base: 0.12,
  loose: 0.2,
} as const

/**
 * `cinematic` is reserved for hero entrance and full-section background
 * transitions. Per-card scroll reveals must use `slow` or faster —
 * reusing `cinematic` for repeated reveals makes long-form scroll feel sluggish.
 */
export const RESERVED_FOR_HERO_AND_TRANSITIONS = DURATION.cinematic

/** Z-index convention shared by every section — keeps stacked glass/sticky layers predictable. */
export const Z_INDEX = {
  background: 0,
  content: 10,
  floatingCard: 20,
  stickyProgress: 40,
  nav: 50,
} as const
