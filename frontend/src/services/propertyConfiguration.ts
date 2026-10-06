const CONFIGURED_PROPERTY_KEY = 'section-l:configured-property-slug'

type ReadableStorage = Pick<Storage, 'getItem'>
type WritableStorage = Pick<Storage, 'setItem' | 'removeItem'>

export function getConfiguredPropertySlug(
  storage: ReadableStorage = window.localStorage,
): string | null {
  return storage.getItem(CONFIGURED_PROPERTY_KEY)
}

export function saveConfiguredPropertySlug(
  slug: string,
  storage: WritableStorage = window.localStorage,
): void {
  storage.setItem(CONFIGURED_PROPERTY_KEY, slug)
}

export function clearConfiguredPropertySlug(storage: WritableStorage = window.localStorage): void {
  storage.removeItem(CONFIGURED_PROPERTY_KEY)
}
