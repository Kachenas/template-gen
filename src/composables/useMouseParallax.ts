import { onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { useReducedMotion } from '@/composables/useReducedMotion'

interface ParallaxLayer {
  el: HTMLElement
  /** Max travel distance in px at the viewport edge. */
  strength: number
}

/**
 * Drives GSAP quickTo tweens on one or more layers based on pointer position.
 * `getLayers` is re-evaluated on every mount/move so template refs can resolve lazily.
 */
export function useMouseParallax(getLayers: () => ParallaxLayer[]) {
  const { prefersReducedMotion } = useReducedMotion()
  let setters: Array<{ x: (value: number) => void; y: (value: number) => void }> = []

  function handlePointerMove(e: PointerEvent) {
    if (prefersReducedMotion.value) return
    const layers = getLayers()
    const nx = e.clientX / window.innerWidth - 0.5
    const ny = e.clientY / window.innerHeight - 0.5
    layers.forEach((layer, i) => {
      setters[i]?.x(nx * layer.strength)
      setters[i]?.y(ny * layer.strength)
    })
  }

  onMounted(() => {
    setters = getLayers().map(({ el }) => ({
      x: gsap.quickTo(el, 'x', { duration: 0.6, ease: 'power3.out' }),
      y: gsap.quickTo(el, 'y', { duration: 0.6, ease: 'power3.out' }),
    }))
    window.addEventListener('pointermove', handlePointerMove)
  })

  onUnmounted(() => {
    window.removeEventListener('pointermove', handlePointerMove)
  })
}
