# AI Scheduling — Web App

React (Vite) web version of the AI scheduling app, with a real Claude-powered backend for scheduling recommendations.

## Local development

```bash
cd web
npm install
npm run dev
```

The frontend proxies `/api/*` to `http://localhost:3000` in dev — run `vercel dev` (below) alongside `npm run dev`, or use `vercel dev` alone since it serves both the static site and the API.

```bash
npm install -g vercel
vercel dev
```

## Environment variables

Copy `.env.example` to `.env` and set:

```
ANTHROPIC_API_KEY=sk-ant-...
```

This is read **server-side only** by `api/schedule.js` — it's never sent to the browser.

## Deploying to Vercel

```bash
vercel          # first deploy, follow prompts
vercel --prod   # production deploy
```

Set `ANTHROPIC_API_KEY` in the Vercel project's Environment Variables settings (Project → Settings → Environment Variables) — do this before the first `vercel --prod` deploy, or the `/api/schedule` route will fail.

## AI Providers

The backend supports three configurable AI providers for scheduling recommendations:

1. **Claude API** (default, recommended) — best quality, structured outputs
2. **HuggingFace Inference API** — free tier available, cloud-hosted
3. **Ollama** — free, run open models locally (Mistral, Llama 2)

Set `AI_PROVIDER` environment variable to switch. See `DEPLOYMENT.md` for full setup instructions.

## Architecture

- **Frontend**: React + Vite SPA, tasks persisted in `localStorage` (no database).
- **Backend**: A single Vercel serverless function (`api/schedule.js`) with pluggable AI provider support.
- **Base path**: `vite.config.js` sets `base: '/agent/'` so the built assets resolve correctly when served under `rebaneado.com/agent`. Change this if you deploy at a different path or the domain root.

## Deploying to Vercel

See `DEPLOYMENT.md` for complete deployment instructions, including:
- How to set up each AI provider
- Environment variables for production
- Local development with each provider
- Routing configuration under rebaneado.com/agent
