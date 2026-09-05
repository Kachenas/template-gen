<template>
  <div class="bg-bg relative min-h-screen">
    <div class="fixed inset-x-0 top-0 z-50 h-[3px] bg-white/5">
      <div
        class="bg-primary shadow-glow-sm h-full"
        :style="{ width: `${progress}%` }"
      />
    </div>

    <header
      :class="
        cn(
          'fixed inset-x-0 top-0 z-40 transition-colors duration-500',
          isScrolled ? 'glass-panel-light rounded-none border-x-0 border-t-0' : 'bg-transparent',
        )
      "
    >
      <nav class="content-shell flex items-center justify-between py-4">
        <router-link
          to="/"
          class="font-display text-lg font-bold text-white"
        >
          VibeCheckKits
        </router-link>
        <GlowButton
          href="#audit"
          size="sm"
        >
          Book a Free Audit
        </GlowButton>
      </nav>
    </header>

    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import GlowButton from '@/components/ui/GlowButton.vue'
import { useScrollProgress } from '@/composables/useScrollProgress'
import { cn } from '@/utils/cn'

const { progress } = useScrollProgress()
const isScrolled = ref(false)

function handleScroll() {
  isScrolled.value = window.scrollY > 64
}

onMounted(() => window.addEventListener('scroll', handleScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>
