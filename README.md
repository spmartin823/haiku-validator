# Haiku Validator

A minimal web app that validates whether three lines of text form a valid haiku (5-7-5 syllable pattern). Live at [haikuvalidator.org](https://haikuvalidator.org).

## Architecture

This is intentionally simple: one HTML file, one API route, no build step.

```
index.html          - The entire frontend (HTML, CSS, JS — all inline)
api/haikus.js       - Vercel serverless function for saving/loading haikus
package.json        - Only dependency: @libsql/client for Turso DB access
```

### Frontend (`index.html`)

- Three text inputs for haiku lines with live syllable counting
- Syllable counting uses the [`syllable`](https://github.com/words/syllable) library (v2), loaded via CDN from `esm.sh` — no npm install or bundling needed on the frontend
- The script tag is `type="module"` to support the ESM import
- Pasting multi-line text into any input auto-splits across all three fields
- Three buttons: **save** (to database), **copy haiku** (to clipboard as newline-delimited text), **clear**
- Saved haikus are listed below the buttons, loaded on page load via `GET /api/haikus`

### Backend (`api/haikus.js`)

A single Vercel serverless function with two endpoints:

- `GET /api/haikus` — returns the 100 most recent haikus as JSON
- `POST /api/haikus` — saves a haiku (`{ line1, line2, line3 }`)

Uses parameterized queries to prevent SQL injection.

## Database

**Turso** (libSQL / SQLite-compatible edge database) on the free tier.

- Database name: `haiku-validator`
- Region: `aws-us-east-1`
- Single table:

```sql
CREATE TABLE haikus (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  line1 TEXT NOT NULL,
  line2 TEXT NOT NULL,
  line3 TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);
```

### Turso CLI commands

```bash
# Access the database shell
turso db shell haiku-validator

# Show connection URL
turso db show haiku-validator --url

# Create a new auth token
turso db tokens create haiku-validator
```

## Deployment

Hosted on **Vercel** (free tier, no framework, no build step).

- Vercel project name: `kyoto`
- Domain: `haikuvalidator.org` (custom domain via Porkbun DNS)
- Also accessible at: `kyoto-two-iota.vercel.app`

### DNS (Porkbun)

| Type  | Host  | Value                  |
|-------|-------|------------------------|
| A     | @     | 76.76.21.21            |
| CNAME | www   | cname.vercel-dns.com   |

### Environment variables (Vercel)

| Name                 | Description                        |
|----------------------|------------------------------------|
| `TURSO_DATABASE_URL` | libsql:// connection URL for Turso |
| `TURSO_AUTH_TOKEN`   | JWT auth token for Turso           |

### Deploying changes

```bash
# Deploy to production (from the repo root)
npx vercel --yes --prod
```

Or just push to `main` if Vercel git integration is connected.

## GitHub

- Repo: [github.com/spmartin823/haiku-validator](https://github.com/spmartin823/haiku-validator)
- Public repo, `main` branch is the production branch

## Local development

No build step needed. For the frontend only:

```bash
# Any static file server works
npx serve .
```

Note: the save/load feature requires the Vercel serverless function and won't work with a plain static server. To test the API locally:

```bash
npx vercel dev
```

This requires `vercel env pull` first to get the Turso credentials into a local `.env` file.
