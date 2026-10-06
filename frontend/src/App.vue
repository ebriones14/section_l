<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import CityGemCard from './components/CityGemCard.vue'
import {
  getProperties,
  getProperty,
  type Property,
} from './services/api'

const properties = ref<Property[]>([])
const currentProperty = ref<Property | null>(null)
const selectedCategory = ref('All')
const loading = ref(true)
const error = ref('')

const categories = computed(() => [
  'All',
  ...new Set((currentProperty.value?.city_gems ?? []).map((gem) => gem.category)),
])

const visibleGems = computed(() => {
  const gems = currentProperty.value?.city_gems ?? []
  return selectedCategory.value === 'All'
    ? gems
    : gems.filter((gem) => gem.category === selectedCategory.value)
})

async function selectProperty(slug: string) {
  loading.value = true
  error.value = ''
  selectedCategory.value = 'All'
  try {
    currentProperty.value = await getProperty(slug)
  } catch (caught) {
    error.value = caught instanceof Error ? caught.message : 'Could not load this property.'
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  try {
    properties.value = await getProperties()
    if (properties.value[0]) await selectProperty(properties.value[0].slug)
  } catch (caught) {
    error.value = caught instanceof Error ? caught.message : 'Could not connect to the City Notes API.'
    loading.value = false
  }
})
</script>

<template>
  <div class="app-shell">
    <header class="site-header">
      <div class="brand">
        <span class="brand__main">SECTION L</span>
        <span class="brand__sub">CITY NOTES</span>
      </div>
    </header>

    <main>
      <section class="hero" :style="{ '--hero-image': `url(${currentProperty?.hero_image_url ?? ''})` }">
        <div class="hero__overlay"></div>
        <div class="hero__content">
          <p class="eyebrow eyebrow--light">A local guide from your hosts</p>
          <h1>Good places,<br /><em>close by.</em></h1>
          <p class="hero__intro">{{ currentProperty?.description ?? 'Personally picked places for a day well spent.' }}</p>
          <label class="property-picker">
            <span>You’re staying at</span>
            <select
              :value="currentProperty?.slug"
              aria-label="Select your Section L property"
              @change="selectProperty(($event.target as HTMLSelectElement).value)"
            >
              <option v-for="property in properties" :key="property.id" :value="property.slug">
                {{ property.name }}
              </option>
            </select>
          </label>
        </div>
      </section>

      <section class="recommendations section-wrap">
        <div class="section-heading">
          <div>
            <p class="eyebrow">Handpicked by Section L</p>
            <h2>Explore the neighborhood</h2>
          </div>
          <p>Not a directory. Just the places we genuinely send our friends.</p>
        </div>

        <div v-if="categories.length > 1" class="filters" aria-label="Filter recommendations">
          <button
            v-for="category in categories"
            :key="category"
            type="button"
            :class="{ active: selectedCategory === category }"
            @click="selectedCategory = category"
          >
            {{ category }}
          </button>
        </div>

        <p v-if="error" class="notice notice--error">{{ error }}</p>
        <div v-else-if="loading" class="loading-grid" aria-label="Loading recommendations">
          <div v-for="index in 3" :key="index" class="loading-card"></div>
        </div>
        <div v-else-if="visibleGems.length" class="gem-grid">
          <CityGemCard v-for="gem in visibleGems" :key="gem.id" :gem="gem" />
        </div>
        <div v-else class="empty-state">No picks in this category yet. Check back soon.</div>
      </section>
    </main>

    <footer>
      <span>SECTION L</span>
      <p>Made for curious guests in Tokyo.</p>
    </footer>
  </div>
</template>
