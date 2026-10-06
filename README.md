# Section L City Notes

A small, tablet-friendly MVP that helps Section L guests discover genuinely local places near their property. Operations can choose which City Gems appear at each location without changing code.

## What is included

- Guest experience with property switching, category filters, image-led recommendation cards, maps, and source websites
- City Gems selected through reusable neighbourhood tagging
- Rails 8.1 JSON API with SQLite, validation, foreign keys, CORS, and idempotent sample seeds
- Vue 3 + TypeScript frontend built with Vite
- Rails model/integration tests, Vitest API-client tests, RuboCop, Brakeman, and npm audit/build checks

## Product decisions

The MVP models three concepts:

- `Property`: a Section L location with a name, address, and description
- `Neighbourhood`: an area shared by one or more properties
- `PropertyNeighbourhood`: the join model supporting the many-to-many property/neighbourhood relationship
- `CityGem`: a curated place that can appear for any property sharing one of its neighbourhoods
- `CityGemNeighbourhood`: the join model supporting the many-to-many City Gem/neighbourhood relationship

The guest interface is intentionally editorial rather than a generic directory. Administrative CRUD and authentication are intentionally outside this prototype.

## Requirements

- Ruby 3.4.6
- Node 22.13.1
- Bundler and npm

The versions are captured in `.tool-versions` for `mise` users.

## Setup

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

Open <http://localhost:5173>. Vite proxies `/api` to Rails during development. For separate deployed origins, set `VITE_API_URL` on the frontend and `FRONTEND_ORIGIN` on the backend.

## API

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `GET` | `/api/v1/properties` | List properties |
| `GET` | `/api/v1/properties/:slug` | Return a property and its ordered City Gems |
| `GET` | `/api/v1/city_gems` | List the complete curation catalog |

## Checks

```bash
cd backend
bin/rails test
bin/rubocop
bin/brakeman --no-pager

cd ../frontend
npm run build
npm test
npm audit
```

## Next steps after the MVP

1. Add staff-authenticated CRUD for City Gems and properties.
2. Add image uploads and editorial ordering.
3. Move production data to PostgreSQL and add deployment configuration.
4. Add browser-level tests for the guest journey and future operations tools.
5. Add multilingual copy and basic recommendation analytics.
