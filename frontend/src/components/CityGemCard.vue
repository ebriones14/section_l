<script setup lang="ts">
import { ImageIcon, Landmark, MapPin, ShoppingBag, UtensilsCrossed } from '@lucide/vue'
import { ref } from 'vue'
import type { CityGem } from '../services/api'

defineProps<{ gem: CityGem }>()

const imageFailed = ref(false)

const categoryIcons = {
  'Food & Drink': UtensilsCrossed,
  Shopping: ShoppingBag,
  Culture: Landmark,
}

function categoryIcon(category: string) {
  return categoryIcons[category as keyof typeof categoryIcons] ?? ImageIcon
}
</script>

<template>
  <article class="gem-card">
    <div class="gem-card__image-wrap">
      <img
        v-if="gem.image_url && !imageFailed"
        class="gem-card__image"
        :src="gem.image_url"
        :alt="gem.name"
        @error="imageFailed = true"
      />
      <div
        v-else
        class="gem-card__placeholder"
        role="img"
        :aria-label="`No preview for ${gem.name}`"
      >
        <span class="gem-card__placeholder-icon">
          <component :is="categoryIcon(gem.category)" :size="30" :stroke-width="1.6" />
        </span>
        <strong>No preview available yet</strong>
        <small>{{ gem.category }}</small>
      </div>
      <span class="gem-card__category">{{ gem.category }}</span>
    </div>
    <div class="gem-card__content">
      <div class="gem-card__heading">
        <h3>{{ gem.name }}</h3>
        <div class="gem-card__neighbourhoods" aria-label="Neighbourhoods">
          <span v-for="neighbourhood in gem.neighbourhoods" :key="neighbourhood.id">
            {{ neighbourhood.name }}
          </span>
        </div>
      </div>
      <p class="gem-card__summary">{{ gem.short }}</p>
      <p class="gem-card__description">{{ gem.long }}</p>
      <div v-if="gem.tags.length" class="gem-card__tags" aria-label="Tags">
        <span v-for="tag in gem.tags" :key="tag">#{{ tag }}</span>
      </div>
      <div class="gem-card__footer">
        <a :href="gem.maps" target="_blank" rel="noreferrer">
          <MapPin :size="17" :stroke-width="1.8" aria-hidden="true" />
          View on Google Maps
        </a>
      </div>
    </div>
  </article>
</template>
