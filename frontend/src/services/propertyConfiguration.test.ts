import { describe, expect, it } from 'vitest'
import {
  clearConfiguredPropertySlug,
  getConfiguredPropertySlug,
  saveConfiguredPropertySlug,
} from './propertyConfiguration'

function memoryStorage(): Storage {
  const values = new Map<string, string>()

  return {
    get length() {
      return values.size
    },
    clear: () => values.clear(),
    getItem: (key) => values.get(key) ?? null,
    key: (index) => [...values.keys()][index] ?? null,
    removeItem: (key) => {
      values.delete(key)
    },
    setItem: (key, value) => {
      values.set(key, value)
    },
  }
}

describe('iPad property configuration', () => {
  it('persists the configured property slug', () => {
    const storage = memoryStorage()

    saveConfiguredPropertySlug('ginza-east', storage)

    expect(getConfiguredPropertySlug(storage)).toBe('ginza-east')
  })

  it('clears an unavailable property configuration', () => {
    const storage = memoryStorage()
    saveConfiguredPropertySlug('old-property', storage)

    clearConfiguredPropertySlug(storage)

    expect(getConfiguredPropertySlug(storage)).toBeNull()
  })
})
