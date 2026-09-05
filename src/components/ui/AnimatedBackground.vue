<template>
  <div
    class="absolute inset-0 overflow-hidden"
    aria-hidden="true"
  >
    <div
      ref="meshEl"
      class="aurora-mesh absolute -inset-[20%] opacity-70 blur-3xl"
    />
    <div
      ref="blobCyanEl"
      class="bg-glow-cyan/20 absolute top-[15%] left-[10%] h-72 w-72 rounded-full blur-3xl"
    />
    <div
      ref="blobPurpleEl"
      class="bg-glow-purple/15 absolute top-[35%] right-[8%] h-80 w-80 rounded-full blur-3xl"
    />
    <canvas
      ref="canvasEl"
      class="absolute inset-0 h-full w-full opacity-40"
    />
    <div class="to-bg absolute inset-0 bg-gradient-to-b from-transparent via-transparent" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useMouseParallax } from '@/composables/useMouseParallax'
import { useReducedMotion } from '@/composables/useReducedMotion'

const meshEl = ref<HTMLElement>()
const blobCyanEl = ref<HTMLElement>()
const blobPurpleEl = ref<HTMLElement>()
const canvasEl = ref<HTMLCanvasElement>()

const { prefersReducedMotion } = useReducedMotion()

useMouseParallax(() =>
  [
    { el: meshEl.value, strength: 24 },
    { el: blobCyanEl.value, strength: 48 },
    { el: blobPurpleEl.value, strength: -36 },
  ].filter((layer): layer is { el: HTMLElement; strength: number } => Boolean(layer.el)),
)

interface Particle {
  x: number
  y: number
  r: number
  vx: number
  vy: number
}

let ctx: CanvasRenderingContext2D | null = null
let particles: Particle[] = []
let rafId = 0
let resizeObserver: ResizeObserver | undefined

function resizeCanvas() {
  const canvas = canvasEl.value
  if (!canvas) return
  canvas.width = canvas.clientWidth * devicePixelRatio
  canvas.height = canvas.clientHeight * devicePixelRatio
}

function seedParticles() {
  const canvas = canvasEl.value
  if (!canvas) return
  const count = Math.min(60, Math.floor((canvas.clientWidth * canvas.clientHeight) / 22000))
  particles = Array.from({ length: count }, () => ({
    x: Math.random() * canvas.clientWidth,
    y: Math.random() * canvas.clientHeight,
    r: Math.random() * 1.4 + 0.4,
    vx: (Math.random() - 0.5) * 0.15,
    vy: (Math.random() - 0.5) * 0.15,
  }))
}

function draw() {
  const canvas = canvasEl.value
  if (!canvas || !ctx) return
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ctx.save()
  ctx.scale(devicePixelRatio, devicePixelRatio)
  for (const p of particles) {
    p.x += p.vx
    p.y += p.vy
    if (p.x < 0) p.x = canvas.clientWidth
    if (p.x > canvas.clientWidth) p.x = 0
    if (p.y < 0) p.y = canvas.clientHeight
    if (p.y > canvas.clientHeight) p.y = 0
    ctx.beginPath()
    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
    ctx.fillStyle = 'rgba(232, 236, 244, 0.5)'
    ctx.fill()
  }
  ctx.restore()
  rafId = requestAnimationFrame(draw)
}

onMounted(() => {
  const canvas = canvasEl.value
  if (!canvas) return

  ctx = canvas.getContext('2d')
  resizeCanvas()
  seedParticles()

  resizeObserver = new ResizeObserver(() => {
    resizeCanvas()
    seedParticles()
  })
  resizeObserver.observe(canvas)

  if (!prefersReducedMotion.value) {
    draw()
  }
})

onUnmounted(() => {
  cancelAnimationFrame(rafId)
  resizeObserver?.disconnect()
})
</script>
