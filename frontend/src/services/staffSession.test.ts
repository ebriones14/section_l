import { describe, expect, it } from 'vitest'
import { clearStaffSessionToken, getStaffSessionToken, saveStaffSessionToken } from './staffSession'

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

describe('staff configuration session', () => {
  it('stores the signed token for the browser session', () => {
    const storage = memoryStorage()

    saveStaffSessionToken('signed-token', storage)

    expect(getStaffSessionToken(storage)).toBe('signed-token')
  })

  it('clears the token when setup is locked', () => {
    const storage = memoryStorage()
    saveStaffSessionToken('signed-token', storage)

    clearStaffSessionToken(storage)

    expect(getStaffSessionToken(storage)).toBeNull()
  })
})
