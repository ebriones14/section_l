<script setup lang="ts">
import {
  Coffee,
  Gem,
  Landmark,
  LockKeyhole,
  MapPin,
  Settings,
  ShoppingBag,
  Sparkles,
  Trees,
  Utensils,
} from '@lucide/vue'
import { computed, onMounted, ref } from 'vue'
import CityGemCard from './components/CityGemCard.vue'
import {
  createStaffSession,
  getProperties,
  getProperty,
  hasValidStaffSession,
  type Property,
} from './services/api'
import {
  clearConfiguredPropertySlug,
  getConfiguredPropertySlug,
  saveConfiguredPropertySlug,
} from './services/propertyConfiguration'
import {
  clearStaffSessionToken,
  getStaffSessionToken,
  saveStaffSessionToken,
} from './services/staffSession'

type Screen = 'loading' | 'guest' | 'staff-login' | 'configuration'

const DEFAULT_HERO_IMAGE = '/images/default-property-hero.webp'

const properties = ref<Property[]>([])
const currentProperty = ref<Property | null>(null)
const pendingPropertySlug = ref('')
const selectedCategory = ref('All')
const screen = ref<Screen>('loading')
const savingConfiguration = ref(false)
const error = ref('')
const staffPin = ref('')
const unlockingConfiguration = ref(false)

const categoryIcons = {
  All: Gem,
  'Food & Drink': Utensils,
  Shopping: ShoppingBag,
  Culture: Landmark,
  Nature: Trees,
  Entertainment: Sparkles,
  Cafes: Coffee,
}

function categoryIcon(category: string) {
  return categoryIcons[category as keyof typeof categoryIcons] ?? Sparkles
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

function lockConfiguration() {
  clearStaffSessionToken()
  staffPin.value = ''
}

function cancelStaffLogin() {
  if (!currentProperty.value) return

  lockConfiguration()
  error.value = ''
  window.history.replaceState({}, '', '/')
  screen.value = 'guest'
}

async function unlockConfiguration() {
  if (!staffPin.value) return

  unlockingConfiguration.value = true
  error.value = ''

  try {
    const session = await createStaffSession(staffPin.value)
    saveStaffSessionToken(session.token)
    staffPin.value = ''
    screen.value = 'configuration'
  } catch (caught) {
    error.value = caught instanceof Error ? caught.message : 'Could not unlock device setup.'
  } finally {
    unlockingConfiguration.value = false
  }
}

function cancelConfiguration() {
  if (!currentProperty.value) return

  lockConfiguration()
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
    lockConfiguration()
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

      const staffToken = getStaffSessionToken()
      if (staffToken && (await hasValidStaffSession(staffToken))) {
        screen.value = 'configuration'
      } else {
        lockConfiguration()
        screen.value = 'staff-login'
      }
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
    lockConfiguration()
    screen.value = 'staff-login'
  } catch (caught) {
    error.value =
      caught instanceof Error ? caught.message : 'Could not connect to the City Notes API.'
    screen.value = window.location.pathname === '/configure' ? 'staff-login' : 'loading'
  }
})
</script>

<template>
  <div
    class="app-shell"
    :class="{
      'app-shell--configuration': screen === 'configuration' || screen === 'staff-login',
    }"
  >
    <header class="site-header" :class="{ 'site-header--guest': screen === 'guest' }">
      <div class="brand">
        <span class="brand__main">SECTION L</span>
        <span class="brand__sub">CITY NOTES</span>
      </div>
      <a
        v-if="screen === 'guest'"
        class="configure-link"
        href="/configure"
        aria-label="Staff setup"
        title="Staff setup"
      >
        <Settings :size="22" :stroke-width="1.8" aria-hidden="true" />
      </a>
    </header>

    <main v-if="screen === 'staff-login'" class="staff-login section-wrap">
      <section class="staff-login__card">
        <div class="staff-login__icon" aria-hidden="true">
          <LockKeyhole :size="30" :stroke-width="1.8" />
        </div>
        <p class="eyebrow">Staff access</p>
        <h1>Unlock device setup</h1>
        <p class="staff-login__intro">
          Enter the staff PIN to choose which Section L property this iPad belongs to.
        </p>

        <form class="staff-login__form" @submit.prevent="unlockConfiguration">
          <label for="staff-pin">Staff PIN</label>
          <input
            id="staff-pin"
            v-model.trim="staffPin"
            type="password"
            inputmode="numeric"
            autocomplete="off"
            autofocus
            placeholder="Enter PIN"
            @input="error = ''"
          />
          <p v-if="error" class="notice notice--error" role="alert">{{ error }}</p>
          <button
            type="submit"
            class="primary-button"
            :disabled="unlockingConfiguration || !staffPin"
          >
            {{ unlockingConfiguration ? 'Checking…' : 'Unlock setup' }}
          </button>
          <button
            v-if="currentProperty"
            type="button"
            class="staff-login__back"
            @click="cancelStaffLogin"
          >
            Back to City Notes
          </button>
        </form>
      </section>
    </main>

    <main v-else-if="screen === 'configuration'" class="manager section-wrap">
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
        :style="{
          '--hero-image': `url(${currentProperty?.hero_image_url || DEFAULT_HERO_IMAGE})`,
        }"
      >
        <div class="hero__content">
          <p class="eyebrow eyebrow--light">Explore around</p>
          <h1>{{ currentProperty?.name }}</h1>
          <p class="hero__intro">{{ currentProperty?.description }}</p>
          <div v-if="currentProperty" class="hero__facts">
            <div class="hero-fact">
              <span class="hero-fact__icon" aria-hidden="true">
                <MapPin :size="24" :stroke-width="1.7" />
              </span>
              <span class="hero-fact__copy">
                <strong>{{ currentProperty.city }}</strong>
                <small>{{ currentProperty.address }}</small>
              </span>
            </div>
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
            <component
              :is="categoryIcon(category)"
              aria-hidden="true"
              :size="18"
              :stroke-width="1.8"
            />
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
          <CityGemCard v-for="gem in visibleGems" :key="gem.id" :gem="gem" />
        </div>
        <div v-else class="empty-state">No picks in this category yet. Check back soon.</div>
      </section>
    </main>

    <footer v-if="screen === 'guest'">
      <span>SECTION L</span>
      <p>Made for curious guests in Tokyo.</p>
    </footer>
  </div>
</template>
