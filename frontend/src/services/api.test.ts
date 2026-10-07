import { afterEach, describe, expect, it, vi } from 'vitest'
import { createStaffSession, getProperty, hasValidStaffSession } from './api'

afterEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

describe('City Notes API client', () => {
  it('loads a property by slug', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({ property: { id: 1, slug: 'tsukiji', city_gems: [] } }),
      }),
    )

    const property = await getProperty('tsukiji')

    expect(property.slug).toBe('tsukiji')
    expect(fetch).toHaveBeenCalledWith(
      '/api/v1/properties/tsukiji',
      expect.objectContaining({
        headers: expect.objectContaining({ 'Content-Type': 'application/json' }),
      }),
    )
  })

  it('creates a staff configuration session', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({ token: 'signed-token', expires_in: 900 }),
      }),
    )

    const session = await createStaffSession('2468')

    expect(session.token).toBe('signed-token')
    expect(fetch).toHaveBeenCalledWith(
      '/api/v1/staff/session',
      expect.objectContaining({
        method: 'POST',
        body: JSON.stringify({ pin: '2468' }),
      }),
    )
  })

  it('recognizes an expired or invalid staff session', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: false,
        status: 401,
      }),
    )

    await expect(hasValidStaffSession('expired-token')).resolves.toBe(false)
    expect(fetch).toHaveBeenCalledWith(
      '/api/v1/staff/session',
      expect.objectContaining({
        headers: expect.objectContaining({ Authorization: 'Bearer expired-token' }),
      }),
    )
  })
})
