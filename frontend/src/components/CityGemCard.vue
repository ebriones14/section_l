<script setup lang="ts">
import type { CityGem } from '../services/api'

defineProps<{ gem: CityGem }>()

const emit = defineEmits<{ select: [gem: CityGem] }>()
</script>

<template>
  <article class="gem-card">
    <div class="gem-card__image-wrap">
      <img v-if="gem.image_url" class="gem-card__image" :src="gem.image_url" :alt="gem.name" />
      <div v-else class="gem-card__placeholder" aria-hidden="true">
        <span>{{ gem.name.slice(0, 1) }}</span>
        <small>Section L pick</small>
      </div>
      <span class="gem-card__distance">Nearby</span>
    </div>
    <div class="gem-card__content">
      <h3>{{ gem.name }}</h3>
      <p class="gem-card__description">{{ gem.short }}</p>
      <div class="gem-card__tags">
        <span class="gem-card__category">{{ gem.category }}</span>
        <span v-for="neighbourhood in gem.neighbourhoods" :key="neighbourhood.id">
          {{ neighbourhood.name }}
        </span>
      </div>
      <button type="button" class="gem-card__hit-area" @click="emit('select', gem)">
        <span class="sr-only">View details for {{ gem.name }}</span>
      </button>
    </div>
  </article>
</template>
