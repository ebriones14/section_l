<script setup lang="ts">
import type { CityGem } from '../services/api'

defineProps<{ gem: CityGem }>()
</script>

<template>
  <article class="gem-card">
    <div class="gem-card__image-wrap">
      <img v-if="gem.image_url" class="gem-card__image" :src="gem.image_url" :alt="gem.name" />
      <div v-else class="gem-card__placeholder">Section L pick</div>
      <span class="gem-card__category">{{ gem.category }}</span>
    </div>
    <div class="gem-card__content">
      <div>
        <p class="eyebrow">{{ gem.neighbourhoods.map((neighbourhood) => neighbourhood.name).join(' · ') }}</p>
        <h3>{{ gem.name }}</h3>
      </div>
      <p class="gem-card__description">{{ gem.short }}</p>
      <p class="gem-card__address">{{ gem.long }}</p>
      <div class="gem-card__actions">
        <a :href="gem.maps" target="_blank" rel="noreferrer">Open map ↗</a>
      </div>
    </div>
  </article>
</template>
