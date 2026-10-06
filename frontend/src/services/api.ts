export interface CityGem {
  id: number
  name: string
  category: string
  short: string
  long: string
  maps: string
  image_url: string | null
  neighbourhoods: Array<{ id: number; name: string }>
}

export interface Property {
  id: number
  name: string
  address: string
  city: string
  slug: string
  description: string
  hero_image_url: string | null
  neighbourhoods: Array<{ id: number; name: string }>
  city_gems?: CityGem[]
}

const API_URL = import.meta.env.VITE_API_URL ?? ''

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${API_URL}${path}`, {
    ...init,
    headers: { 'Content-Type': 'application/json', ...init?.headers },
  })

  if (!response.ok) {
    const payload = (await response.json().catch(() => ({}))) as { error?: string }
    throw new Error(payload.error ?? `Request failed (${response.status})`)
  }

  return response.json() as Promise<T>
}

export async function getProperties(): Promise<Property[]> {
  const response = await request<{ properties: Property[] }>('/api/v1/properties')
  return response.properties
}

export async function getProperty(slug: string): Promise<Property> {
  const response = await request<{ property: Property }>(
    `/api/v1/properties/${encodeURIComponent(slug)}`,
  )
  return response.property
}

export async function getCityGems(): Promise<CityGem[]> {
  const response = await request<{ city_gems: CityGem[] }>('/api/v1/city_gems')
  return response.city_gems
}
