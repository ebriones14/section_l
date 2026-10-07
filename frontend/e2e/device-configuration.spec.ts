import { expect, test } from '@playwright/test'

const CONFIGURED_PROPERTY_KEY = 'section-l:configured-property-slug'

test('staff can reconfigure the iPad and the selection persists', async ({ page }) => {
  await page.goto('/')
  await page.evaluate(({ key, slug }) => window.localStorage.setItem(key, slug), {
    key: CONFIGURED_PROPERTY_KEY,
    slug: 'ginza-east',
  })
  await page.goto('/')

  await expect(page.getByRole('heading', { level: 1, name: 'Section L Ginza East' })).toBeVisible()

  await page.getByRole('link', { name: 'Staff setup' }).click()
  await expect(page).toHaveURL(/\/configure$/)

  await page.getByLabel('Staff PIN').fill('1026')
  await page.getByRole('button', { name: 'Unlock setup' }).click()

  await expect(
    page.getByRole('heading', { level: 1, name: 'Choose this iPad’s home' }),
  ).toBeVisible()

  const hatchobori = page.getByRole('button', { name: /Section L Hatchobori/ })
  await hatchobori.click()
  await expect(hatchobori).toHaveAttribute('aria-pressed', 'true')

  await page.getByRole('button', { name: 'Save and open City Notes' }).click()

  await expect(page).toHaveURL(/\/$/)
  await expect(page.getByRole('heading', { level: 1, name: 'Section L Hatchobori' })).toBeVisible()
  await expect(page.getByRole('heading', { level: 2, name: 'City Gems Nearby' })).toBeVisible()
  await expect.poll(() => page.locator('.gem-card').count()).toBeGreaterThan(0)

  await page.reload()
  await expect(page.getByRole('heading', { level: 1, name: 'Section L Hatchobori' })).toBeVisible()
})

test('incorrect staff PIN is rejected', async ({ page }) => {
  await page.goto('/configure')
  await page.getByLabel('Staff PIN').fill('0000')
  await page.getByRole('button', { name: 'Unlock setup' }).click()

  await expect(page.getByRole('alert')).toHaveText('Incorrect staff PIN')
  await expect(page.getByRole('heading', { level: 1, name: 'Unlock device setup' })).toBeVisible()
})
