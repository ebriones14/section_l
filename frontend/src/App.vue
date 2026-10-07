<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import CityGemCard from './components/CityGemCard.vue'
import { getProperties, getProperty, type CityGem, type Property } from './services/api'
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
const selectedGem = ref<CityGem | null>(null)

const categoryIcons: Record<string, string> = {
  All: '◇',
  'Food & Drink': '☕',
  Shopping: '□',
  Culture: '◎',
  Nature: '△',
  Entertainment: '✦',
  Cafes: '☕',
}

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

function openGemDetails(gem: CityGem) {
  selectedGem.value = gem
}

function closeGemDetails() {
  selectedGem.value = null
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
    <header class="site-header" :class="{ 'site-header--guest': screen === 'guest' }">
      <div class="brand">
        <span class="brand__main">SECTION L</span>
        <span class="brand__sub">CITY NOTES</span>
      </div>
      <a v-if="screen === 'guest'" class="configure-link" href="/configure">Staff setup</a>
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
          <p class="eyebrow eyebrow--light">Explore around</p>
          <h1>{{ currentProperty?.name }}</h1>
          <p class="hero__intro">{{ currentProperty?.description }}</p>
          <div v-if="currentProperty" class="property-context">
            <span class="property-context__pin" aria-hidden="true">
              <svg viewBox="0 0 24 24">
                <path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1 1 16 0Z" />
                <circle cx="12" cy="10" r="2.5" />
              </svg>
            </span>
            <span class="property-context__copy">
              <strong>{{ currentProperty.city }}</strong>
              <span v-if="currentProperty.neighbourhoods.length" class="property-context__areas">
                ·
                {{
                  currentProperty.neighbourhoods
                    .map((neighbourhood) => neighbourhood.name)
                    .join(' · ')
                }}
              </span>
              <br />
              <small>{{ currentProperty.address }}</small>
            </span>
          </div>
        </div>
      </section>

      <section class="recommendations section-wrap">
        <div v-if="categories.length > 1" class="filters" aria-label="Filter recommendations">
          <button
            v-for="category in categories"
            :key="category"
            type="button"
            :class="{ active: selectedCategory === category }"
            @click="selectedCategory = category"
          >
            <span aria-hidden="true">{{ categoryIcons[category] ?? '✦' }}</span>
            {{ category }}
          </button>
        </div>

        <div class="section-heading">
          <div>
            <h2>City Gems Nearby</h2>
            <p>Handpicked places near your stay.</p>
          </div>
          <span class="result-count">{{ visibleGems.length }} places</span>
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
          <CityGemCard
            v-for="gem in visibleGems"
            :key="gem.id"
            :gem="gem"
            @select="openGemDetails"
          />
        </div>
        <div v-else class="empty-state">No picks in this category yet. Check back soon.</div>
      </section>
    </main>

    <footer v-if="screen !== 'configuration'">
      <span>SECTION L</span>
      <p>Made for curious guests in Tokyo.</p>
    </footer>

    <div
      v-if="selectedGem"
      class="details-backdrop"
      role="presentation"
      @click.self="closeGemDetails"
    >
      <article
        class="details-panel"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="`gem-${selectedGem.id}-title`"
      >
        <button
          type="button"
          class="details-panel__close"
          aria-label="Close details"
          @click="closeGemDetails"
        >
          ×
        </button>
        <div class="details-panel__image">
          <img v-if="selectedGem.image_url" :src="selectedGem.image_url" :alt="selectedGem.name" />
          <div v-else class="gem-card__placeholder" aria-hidden="true">
            <span>{{ selectedGem.name.slice(0, 1) }}</span>
            <small>Section L pick</small>
          </div>
        </div>
        <div class="details-panel__content">
          <p class="eyebrow">
            {{ selectedGem.neighbourhoods.map((neighbourhood) => neighbourhood.name).join(' · ') }}
          </p>
          <h2 :id="`gem-${selectedGem.id}-title`">{{ selectedGem.name }}</h2>
          <p class="details-panel__lead">{{ selectedGem.short }}</p>
          <p>{{ selectedGem.long }}</p>
          <a :href="selectedGem.maps" target="_blank" rel="noreferrer">Open in Google Maps ↗</a>
        </div>
      </article>
    </div>
  </div>
</template>
