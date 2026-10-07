# Infrastructure

Terraform provisions the production application across:

- Vercel for the Vue frontend
- Render for the Rails API
- Render Postgres for application data

## Credentials

Create an ignored `.env.terraform` file in the repository root:

```sh
export VERCEL_API_TOKEN="..."
export RENDER_API_KEY="..."
export RENDER_OWNER_ID="..."
```

## Deploy

The deployment reads the application from the `main` branch on GitHub, so push
the production-ready code before applying the Terraform plan.

```sh
source .env.terraform
cd infra
terraform init
terraform plan -out=section-l.tfplan
terraform apply section-l.tfplan
```

Inspect the plan before applying it. The configuration intentionally uses free
Render plans and Vercel's default project domain.
