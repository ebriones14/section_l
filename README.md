# Section L City Notes

A small, tablet-friendly MVP that helps Section L guests discover genuinely local places near their property. Operations can choose which City Gems appear at each location without changing code.

## What is included

- Guest experience with persistent iPad property configuration, category filters, image-led recommendation cards, maps, and source websites
- City Gems selected through reusable neighbourhood tagging
- Rails 8.1 JSON API with PostgreSQL, validation, foreign keys, CORS, and idempotent sample seeds
- Vue 3 + TypeScript frontend built with Vite
- Rails model/integration tests, Vitest API-client tests, RuboCop, Brakeman, and npm audit/build checks

## Product decisions

The MVP models three concepts:

- `Property`: a Section L location with a name, address, and description
- `Neighbourhood`: an area shared by one or more properties
- `PropertyNeighbourhood`: the join model supporting the many-to-many property/neighbourhood relationship
- `CityGem`: a curated place that can appear for any property sharing one of its neighbourhoods
- `CityGemNeighbourhood`: the join model supporting the many-to-many City Gem/neighbourhood relationship

The guest interface is intentionally editorial rather than a generic directory. Administrative CRUD is intentionally outside this prototype.
Operations configures each iPad once in the frontend; the selected property slug
is stored in that device's local storage. Staff can revisit `/configure`, enter
the environment-provided staff PIN, and assign the device to another property.
Rails validates the PIN and issues a signed, short-lived setup token. Saving or
cancelling immediately locks setup again.

## Requirements

For the quickest setup, install Docker with Compose. Docker Desktop includes both.

Create a `.env` file in the repository root and choose a private staff PIN:

```env
STAFF_CONFIG_PIN=choose-a-private-pin
```

For the manual setup, install:

- Ruby 3.4.6
- Node 22.13.1
- PostgreSQL 14 or newer
- Bundler and npm

The versions are captured in `.tool-versions` for `mise` users.

The default local databases are `section_l_development` and `section_l_test`.
Set `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, and `POSTGRES_PASSWORD`
when your PostgreSQL server does not use the local socket defaults. A production
`DATABASE_URL` overrides these settings through Rails' standard configuration.

## Run with Docker

From the repository root:

```bash
docker compose up --build
```

The legacy `docker-compose up --build` command uses the same configuration.
Compose waits for PostgreSQL, prepares and seeds the database, starts Rails, and
then starts Vite. Open <http://localhost:5173> when the services are ready.

Stop the stack with `Ctrl+C`, followed by:

```bash
docker compose down
```

The PostgreSQL data is preserved in a named volume. To reset all Docker data and
reseed from scratch:

```bash
docker compose down --volumes
docker compose up --build
```

## Manual setup

```bash
npm run setup
```

Or run each step explicitly:

```bash
cd backend
bundle install
bin/rails db:prepare db:seed

cd ../frontend
npm install
```

## Run locally

In two terminals:

```bash
cd backend && bin/rails server -p 3000
cd frontend && npm run dev
```

Open <http://localhost:5173>. Vite proxies `/api` to Rails during development.
Set `VITE_API_PROXY_TARGET` to change the proxy destination and
`FRONTEND_ORIGIN` to change the origin accepted by Rails. Set
`STAFF_CONFIG_PIN` in the Rails environment before staff use `/configure`; the
application intentionally has no default PIN.

## API

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `GET` | `/api/v1/properties` | List properties |
| `GET` | `/api/v1/properties/:slug` | Return a property and its ordered City Gems |
| `GET` | `/api/v1/city_gems` | List the complete curation catalog |
| `POST` | `/api/v1/staff/session` | Validate the staff PIN and issue a short-lived signed token |
| `GET` | `/api/v1/staff/session` | Validate a staff setup token |

## Checks

```bash
cd backend
bin/rails test
bin/rubocop
bin/brakeman --no-pager

cd ../frontend
npm run format:check
npm run build
npm test
npm audit
```

## Next steps after the MVP

1. Store device assignments centrally with a stable device identifier.
2. Add staff-authenticated CRUD for City Gems and properties.
3. Add image uploads and editorial ordering.
4. Add browser-level tests for the guest journey and future operations tools.
5. Add deployment configuration, multilingual copy, and basic recommendation analytics.
