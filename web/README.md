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

## Architecture

- **Frontend**: React + Vite SPA, tasks persisted in `localStorage` (no database).
- **Backend**: A single Vercel serverless function (`api/schedule.js`) that calls the Claude API (`claude-opus-4-8`) with structured outputs to return scheduling recommendations as JSON.
- **Base path**: `vite.config.js` sets `base: '/agent/'` so the built assets resolve correctly when served under `rebaneado.com/agent`. Change this if you deploy at a different path or the domain root.

## Routing this under rebaneado.com/agent

This app is meant to be reachable at `rebaneado.com/agent`. Since `rebaneado.com` is a separate existing project, wiring the path requires editing *that* project's Vercel config (a `rewrites` entry pointing `/agent/(.*)` at this deployment's URL) — see the main chat thread for the exact steps once this is deployed.
