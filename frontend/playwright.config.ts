import { existsSync } from 'node:fs'
import { defineConfig } from '@playwright/test'

const localChromePath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
const localExecutablePath = existsSync(localChromePath) ? localChromePath : undefined

export default defineConfig({
  testDir: './e2e',
  outputDir: 'test-results',
  fullyParallel: true,
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['list'], ['html', { open: 'never' }]],
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? 'http://127.0.0.1:5173',
    browserName: 'chromium',
    viewport: { width: 1032, height: 1376 },
    hasTouch: true,
    launchOptions: localExecutablePath ? { executablePath: localExecutablePath } : undefined,
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
    video: 'retain-on-failure',
  },
})
