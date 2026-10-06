import { afterEach, describe, expect, it, vi } from 'vitest'
import { getProperty } from './api'

afterEach(() => vi.restoreAllMocks())

describe('City Notes API client', () => {
  it('loads a property by slug', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ property: { id: 1, slug: 'tsukiji', city_gems: [] } }),
    }))

    const property = await getProperty('tsukiji')

    expect(property.slug).toBe('tsukiji')
    expect(fetch).toHaveBeenCalledWith('/api/v1/properties/tsukiji', expect.objectContaining({
      headers: expect.objectContaining({ 'Content-Type': 'application/json' }),
    }))
  })
})
