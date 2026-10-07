const STAFF_SESSION_TOKEN_KEY = 'section-l:staff-configuration-token'

type ReadableStorage = Pick<Storage, 'getItem'>
type WritableStorage = Pick<Storage, 'setItem' | 'removeItem'>

export function getStaffSessionToken(
  storage: ReadableStorage = window.sessionStorage,
): string | null {
  return storage.getItem(STAFF_SESSION_TOKEN_KEY)
}

export function saveStaffSessionToken(
  token: string,
  storage: WritableStorage = window.sessionStorage,
): void {
  storage.setItem(STAFF_SESSION_TOKEN_KEY, token)
}

export function clearStaffSessionToken(storage: WritableStorage = window.sessionStorage): void {
  storage.removeItem(STAFF_SESSION_TOKEN_KEY)
}
