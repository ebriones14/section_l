<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import CityGemCard from './components/CityGemCard.vue'
import { getProperties, getProperty, type Property } from './services/api'
import {
  clearConfiguredPropertySlug,
  getConfiguredPropertySlug,
  saveConfiguredPropertySlug,
} from './services/propertyConfiguration'

type Screen = 'loading' | 'guest' | 'configuration'

const properties = ref<Property[]>([])
const currentProperty = ref<Property | null>(null)
const pendingPropertySlug = ref('')
const selectedCategory = ref('All')
const screen = ref<Screen>('loading')
const savingConfiguration = ref(false)
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

async function loadProperty(slug: string) {
  currentProperty.value = await getProperty(slug)
  selectedCategory.value = 'All'
}

function cancelConfiguration() {
  if (!currentProperty.value) return

  window.history.replaceState({}, '', '/')
  screen.value = 'guest'
}

async function applyConfiguration() {
  if (!pendingPropertySlug.value) return

  savingConfiguration.value = true
  error.value = ''
  try {
    await loadProperty(pendingPropertySlug.value)
    saveConfiguredPropertySlug(pendingPropertySlug.value)
    window.history.replaceState({}, '', '/')
    screen.value = 'guest'
  } catch (caught) {
    error.value = caught instanceof Error ? caught.message : 'Could not configure this property.'
  } finally {
    savingConfiguration.value = false
  }
}

onMounted(async () => {
  try {
    properties.value = await getProperties()
    const configuredSlug = getConfiguredPropertySlug()
    const configuredProperty = properties.value.find((property) => property.slug === configuredSlug)
    const configurationRequested = window.location.pathname === '/configure'

    if (configurationRequested) {
      if (configuredProperty) await loadProperty(configuredProperty.slug)
      pendingPropertySlug.value = configuredProperty?.slug ?? properties.value[0]?.slug ?? ''
      screen.value = 'configuration'
      return
    }

    if (configuredProperty) {
      await loadProperty(configuredProperty.slug)
      screen.value = 'guest'
      return
    }

    if (configuredSlug) clearConfiguredPropertySlug()
    pendingPropertySlug.value = properties.value[0]?.slug ?? ''
    window.history.replaceState({}, '', '/configure')
    screen.value = 'configuration'
  } catch (caught) {
    error.value =
      caught instanceof Error ? caught.message : 'Could not connect to the City Notes API.'
    screen.value = 'configuration'
  }
})
</script>

<template>
  <div class="app-shell" :class="{ 'app-shell--configuration': screen === 'configuration' }">
    <header class="site-header">
      <div class="brand">
        <span class="brand__main">SECTION L</span>
        <span class="brand__sub">CITY NOTES</span>
      </div>
    </header>

    <main v-if="screen === 'configuration'" class="manager section-wrap">
      <div class="manager__heading">
        <div class="manager__heading-icon" aria-hidden="true">
          <svg viewBox="0 0 24 24" role="img">
            <rect x="5" y="2.5" width="14" height="19" rx="2.5" />
            <path d="M10 18.5h4" />
          </svg>
        </div>
        <div>
          <p class="eyebrow">Staff device setup</p>
          <h1>Choose this iPad’s home</h1>
          <p>Guests will see handpicked City Gems around the property you select.</p>
        </div>
      </div>

      <p v-if="error" class="notice notice--error" role="alert">{{ error }}</p>

      <div v-if="properties.length" class="manager__selection">
        <div class="manager__selection-heading">
          <div>
            <p class="eyebrow">Available properties</p>
            <h2>Where will this iPad live?</h2>
          </div>
          <span>{{ properties.length }} locations</span>
        </div>

        <div class="manager-list" aria-label="Choose a Section L property">
          <button
            v-for="property in properties"
            :key="property.id"
            type="button"
            class="manager-item manager-item--property"
            :class="{ selected: pendingPropertySlug === property.slug }"
            :aria-pressed="pendingPropertySlug === property.slug"
            @click="pendingPropertySlug = property.slug"
          >
            <span class="manager-item__marker" aria-hidden="true"></span>
            <span class="manager-item__copy">
              <span class="eyebrow">{{ property.city }}</span>
              <strong>{{ property.name }}</strong>
              <span>{{ property.address }}</span>
              <small>{{
                property.neighbourhoods.map((neighbourhood) => neighbourhood.name).join(' · ')
              }}</small>
            </span>
            <span class="checkmark" aria-hidden="true">
              {{ pendingPropertySlug === property.slug ? '✓' : '' }}
            </span>
          </button>
        </div>
      </div>

      <div v-if="properties.length" class="manager-actions">
        <button
          v-if="currentProperty"
          type="button"
          class="secondary-button"
          @click="cancelConfiguration"
        >
          Cancel
        </button>
        <p v-else>This selection is saved only on this iPad.</p>
        <button
          type="button"
          class="primary-button"
          :disabled="savingConfiguration || !pendingPropertySlug"
          @click="applyConfiguration"
        >
          {{ savingConfiguration ? 'Saving…' : 'Save and open City Notes' }}
        </button>
      </div>
    </main>

    <main v-else>
      <section
        class="hero"
        :style="{ '--hero-image': `url(${currentProperty?.hero_image_url ?? ''})` }"
      >
        <div class="hero__overlay"></div>
        <div class="hero__content">
          <p class="eyebrow eyebrow--light">A local guide from your hosts</p>
          <h1>Good places,<br /><em>close by.</em></h1>
          <p class="hero__intro">
            {{ currentProperty?.description ?? 'Personally picked places for a day well spent.' }}
          </p>
          <div v-if="currentProperty" class="property-context">
            <span>You’re staying at</span>
            <strong>{{ currentProperty.name }}</strong>
          </div>
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
        <div
          v-else-if="screen === 'loading'"
          class="loading-grid"
          aria-label="Loading recommendations"
        >
          <div v-for="index in 3" :key="index" class="loading-card"></div>
        </div>
        <div v-else-if="visibleGems.length" class="gem-grid">
          <CityGemCard v-for="gem in visibleGems" :key="gem.id" :gem="gem" />
        </div>
        <div v-else class="empty-state">No picks in this category yet. Check back soon.</div>
      </section>
    </main>

    <footer v-if="screen !== 'configuration'">
      <span>SECTION L</span>
      <p>Made for curious guests in Tokyo.</p>
    </footer>
  </div>
</template>
