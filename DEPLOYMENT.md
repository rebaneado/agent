# Deployment Guide — AI Scheduling App

## Quick Start: Choose Your AI Provider

The app supports three AI providers for scheduling recommendations. Choose one:

### 1. **Claude API** (Default, Recommended for Production)
Best quality, structured outputs, but requires paid API key.

```bash
# Set environment variable
AI_PROVIDER=claude

# Get API key from https://console.anthropic.com/keys
ANTHROPIC_API_KEY=sk-ant-...
```

**Cost**: ~$0.003 per scheduling request (cheap, no monthly minimum)

---

### 2. **HuggingFace Inference API** (Free Tier, Cloud-Hosted)
Completely free tier available with rate limits. No self-hosting needed.

```bash
# Set environment variable
AI_PROVIDER=huggingface

# Get API key from https://huggingface.co/settings/tokens
HUGGINGFACE_API_KEY=hf_...
```

**Cost**: Free tier has rate limits (~120k tokens/month free)

---

### 3. **Ollama** (Completely Free, Self-Hosted)
Run open-source models locally (Mistral, Llama 2). No API costs, but requires compute.

```bash
# Set environment variable
AI_PROVIDER=ollama
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=mistral
```

**Setup Ollama**:
```bash
# Install from https://ollama.ai
# Run a model
ollama run mistral

# Or in background
ollama serve &
```

**Cost**: Free, but your hardware runs it

---

## Deploying to Vercel

### 1. First Deploy

```bash
cd web
npm install -g vercel
vercel
# Follow prompts to connect your GitHub account and select this project
```

### 2. Set Environment Variables

In the Vercel dashboard:
1. Go to **Project → Settings → Environment Variables**
2. Add your chosen provider's variables:

**For Claude (recommended)**:
- `AI_PROVIDER` = `claude`
- `ANTHROPIC_API_KEY` = `sk-ant-...`

**For HuggingFace**:
- `AI_PROVIDER` = `huggingface`
- `HUGGINGFACE_API_KEY` = `hf_...`

**For Ollama** (self-hosted):
- `AI_PROVIDER` = `ollama`
- `OLLAMA_URL` = `https://your-ollama-server.com` (must be public HTTPS)
- `OLLAMA_MODEL` = `mistral`

### 3. Production Deploy

```bash
vercel --prod
```

Your app is now live at `https://your-deployment.vercel.app`

---

## Routing via rebaneado.com/agent

The main rebaneado.com project has already been configured to route `/agent/*` to your deployment.

**Current setup** (in rebaneado.com's `vercel.json`):
```json
{
  "rewrites": [
    { "source": "/agent", "destination": "https://your-deployment.vercel.app" },
    { "source": "/agent/:path*", "destination": "https://your-deployment.vercel.app/:path*" }
  ]
}
```

**If you deploy to a new URL**, update this in rebaneado.com's Vercel config:
1. Replace `https://your-deployment.vercel.app` with your actual deployment URL
2. The main site's `/agent` path will then route to your new app

---

## Local Development

### Using Claude (Default)

```bash
cd web

# Copy and configure
cp .env.example .env
# Edit .env and add your Anthropic API key

# Install and run
npm install
vercel dev
# App runs on http://localhost:3000, API on http://localhost:3000/api
```

### Using HuggingFace Locally

```bash
cd web

# Configure
cp .env.example .env
# Edit .env:
# AI_PROVIDER=huggingface
# HUGGINGFACE_API_KEY=hf_...

npm install
vercel dev
```

### Using Ollama Locally

```bash
# Terminal 1: Start Ollama
ollama serve

# Terminal 2: Run the app
cd web
cp .env.example .env
# Edit .env:
# AI_PROVIDER=ollama
# OLLAMA_URL=http://localhost:11434
# OLLAMA_MODEL=mistral

npm install
vercel dev
```

The API will call your local Ollama server at `http://localhost:11434`.

---

## Provider Comparison

| Feature | Claude | HuggingFace | Ollama |
|---------|--------|-------------|--------|
| **Cost** | Paid (~$0.003/req) | Free tier + paid | Free |
| **Quality** | Excellent | Good (Llama 2, Mistral) | Good (Mistral, Llama 2) |
| **Setup** | API key | API key | Self-hosted |
| **Structured Output** | ✅ Native support | ⚠️ Regex parsing | ⚠️ Regex parsing |
| **Speed** | Fast | Variable (free tier slow) | Depends on hardware |
| **Privacy** | API calls (Anthropic) | API calls (HF) | Local only |

---

## Troubleshooting

### "API key not configured" error
Make sure you've set the right environment variables in Vercel or `.env` locally.

### HuggingFace rate limited
Free tier has 120k tokens/month. Switch to Claude or Ollama for unlimited use.

### Ollama timeout
Make sure Ollama is running (`ollama serve`) and accessible at `OLLAMA_URL`.

### JSON parsing errors with open models
Open models (HuggingFace, Ollama) sometimes generate malformed JSON. The code attempts regex extraction, but Claude's structured outputs are more reliable. Consider Claude for production.

---

## Architecture

- **Frontend**: React + Vite SPA (tasks stored in localStorage)
- **Backend**: Vercel serverless function (`api/schedule.js`) with pluggable AI provider
- **Base path**: `/agent` (configured in vite.config.js)
- **Routing**: rebaneado.com/agent → your Vercel deployment
