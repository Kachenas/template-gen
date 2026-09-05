import { ref, onMounted, onUnmounted } from 'vue'

export function useScrollProgress() {
  const progress = ref(0)
  let ticking = false

  function update() {
    const doc = document.documentElement
    const scrollable = doc.scrollHeight - doc.clientHeight
    progress.value = scrollable > 0 ? (doc.scrollTop / scrollable) * 100 : 0
    ticking = false
  }

  function handleScroll() {
    if (ticking) return
    ticking = true
    requestAnimationFrame(update)
  }

  onMounted(() => {
    window.addEventListener('scroll', handleScroll, { passive: true })
    update()
  })

  onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll)
  })

  return { progress }
}
