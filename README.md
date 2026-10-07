# Section L City Notes

An iPad-oriented City Gems experience for Section L guests. Each device is assigned to a
property by staff, then shows the distinct places connected to that property's neighbourhoods.

## What is included

- Guest homepage with property context, category filters, City Gem details, image fallbacks,
  and Google Maps links
- Staff-only device configuration protected by a PIN
- Persistent property selection in the iPad browser's local storage
- Rails 8.1 JSON API backed by PostgreSQL
- Vue 3 and TypeScript frontend built with Vite
- Idempotent sample seeds containing the supplied properties, neighbourhoods, and City Gems
- Rails and Vitest coverage for the main API and frontend behavior

## Data model

```text
Property ──< PropertyNeighbourhood >── Neighbourhood
                                             │
                                             └──< CityGemNeighbourhood >── CityGem
```

A property can belong to multiple neighbourhoods, and a City Gem can be shared by multiple
neighbourhoods. The API returns each relevant City Gem only once.

## Staff access

Open `/configure` directly or select the gear icon in the homepage header.

The development staff PIN is:

```text
1026
```

Rails validates the PIN and issues a signed, short-lived setup token. Saving or cancelling the
configuration locks staff setup again.

## Docker development setup

Docker Desktop includes Docker Compose and is the quickest way to run the complete project.

From the repository root:

```bash
docker compose up --build
```

The command starts PostgreSQL, prepares and seeds the database, starts the Rails API, and then
starts the Vite development server.

Open:

- Guest experience: <http://localhost:5173>
- Staff configuration: <http://localhost:5173/configure>
- Rails API: <http://localhost:3000/api/v1/properties>

Docker uses `1026` as the default development staff PIN. To override it without committing a
secret, create a repository-root `.env` file:

```env
STAFF_CONFIG_PIN=your-private-pin
```

Stop the services:

```bash
docker compose down
```

The PostgreSQL data remains in a named Docker volume. To delete it and rebuild the sample data:

```bash
docker compose down --volumes
docker compose up --build
```

Useful Docker commands:

```bash
docker compose logs -f
docker compose exec backend bin/rails db:seed
docker compose exec backend bin/rails console
```

## Manual development setup

Install:

- Ruby 3.4.6
- Node.js 22.13.1
- PostgreSQL 14 or newer
- Bundler and npm

The Ruby and Node versions are also recorded in `.tool-versions` for `mise` users.

With PostgreSQL running, install dependencies and prepare the database from the repository root:

```bash
npm run setup
```

Alternatively, run the steps separately:

```bash
cd backend
bundle install
bin/rails db:prepare
bin/rails db:seed

cd ../frontend
npm install
npx playwright install chromium
```

Set the staff PIN in every shell that starts Rails:

```bash
export STAFF_CONFIG_PIN=1026
```

Then start the backend and frontend in separate terminals:

```bash
cd backend
bin/rails server -p 3000
```

```bash
cd frontend
npm run dev
```

Open <http://localhost:5173>. During development, Vite proxies `/api` requests to Rails.

The default local databases are `section_l_development` and `section_l_test`. If PostgreSQL does
not use local socket defaults, configure `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, and
`POSTGRES_PASSWORD`. `VITE_API_PROXY_TARGET` changes the frontend proxy destination, while
`FRONTEND_ORIGIN` changes the origin accepted by Rails.

## API endpoints

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `GET` | `/api/v1/properties` | List available properties |
| `GET` | `/api/v1/properties/:slug` | Return one property and its distinct City Gems |
| `GET` | `/api/v1/city_gems` | List the complete City Gem catalog |
| `POST` | `/api/v1/staff/session` | Validate the staff PIN and issue a setup token |
| `GET` | `/api/v1/staff/session` | Validate an existing setup token |

## Quality checks

Backend:

```bash
cd backend
bin/rails test
bin/rubocop
bin/brakeman --no-pager
```

Frontend:

```bash
cd frontend
npm run format:check
npm test -- --run
npm run build
npm audit
```

Browser journey (keep the Docker application running in another terminal):

```bash
npm --prefix frontend exec -- playwright install chromium # required once per machine
npm run test:e2e
```

Open Playwright's interactive test runner from the repository root:

```bash
npm run test:e2e:ui
```

Or launch Playwright directly in headed UI mode from the frontend directory:

```bash
cd frontend
npx playwright test --headed --ui
```

Run these scripts instead of invoking `npx playwright test` from the repository root. The scripts
use the frontend's Playwright installation and configuration, keeping Vitest files out of the
browser-test suite.

The Playwright suite uses an iPad Pro-sized viewport and verifies the staff PIN, property
selection, guest recommendations, and local-storage persistence. Set `PLAYWRIGHT_BASE_URL` to
run the same suite against another environment.
