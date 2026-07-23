import Anthropic from '@anthropic-ai/sdk'

const RECOMMENDATION_SCHEMA = {
  type: 'object',
  properties: {
    recommendations: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          taskId: { type: 'string' },
          recommendedStart: { type: 'string', description: 'ISO 8601 datetime' },
          recommendedEnd: { type: 'string', description: 'ISO 8601 datetime' },
          confidence: { type: 'number', description: '0 to 1' },
          reasoning: { type: 'string' },
        },
        required: ['taskId', 'recommendedStart', 'recommendedEnd', 'confidence', 'reasoning'],
        additionalProperties: false,
      },
    },
  },
  required: ['recommendations'],
  additionalProperties: false,
}

const SYSTEM_PROMPT =
  'You are an AI scheduling assistant. Given a list of tasks with priority, ' +
  'estimated duration, and due dates, recommend an optimal time slot for each ' +
  'task during a standard 9am-6pm workday, Monday-Friday, starting from "now". ' +
  'Prioritize urgent and high-priority tasks earlier, respect due dates, and ' +
  'avoid overlapping time slots. Keep reasoning to one concise sentence per task. ' +
  'Return ONLY valid JSON with this exact structure: {"recommendations": [...]}'

async function schedulerWithClaude(tasks, now) {
  const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

  const response = await client.messages.create({
    model: 'claude-opus-4-8',
    max_tokens: 4096,
    output_config: {
      effort: 'medium',
      format: { type: 'json_schema', schema: RECOMMENDATION_SCHEMA },
    },
    system: SYSTEM_PROMPT,
    messages: [
      {
        role: 'user',
        content: `Current time: ${now}\n\nTasks to schedule:\n${JSON.stringify(tasks, null, 2)}`,
      },
    ],
  })

  const textBlock = response.content.find((b) => b.type === 'text')
  return textBlock ? JSON.parse(textBlock.text) : { recommendations: [] }
}

async function schedulerWithHuggingFace(tasks, now) {
  const response = await fetch('https://api-inference.huggingface.co/models/meta-llama/Llama-2-70b-chat-hf', {
    headers: { Authorization: `Bearer ${process.env.HUGGINGFACE_API_KEY}` },
    method: 'POST',
    body: JSON.stringify({
      inputs: `${SYSTEM_PROMPT}\n\nCurrent time: ${now}\n\nTasks to schedule:\n${JSON.stringify(tasks, null, 2)}`,
    }),
  })

  if (!response.ok) {
    throw new Error(`HuggingFace API error: ${response.statusText}`)
  }

  const data = await response.json()
  const text = data[0]?.generated_text || ''

  const jsonMatch = text.match(/\{[\s\S]*\}/)
  const parsed = jsonMatch ? JSON.parse(jsonMatch[0]) : { recommendations: [] }
  return parsed
}

async function schedulerWithOllama(tasks, now) {
  const ollamaUrl = process.env.OLLAMA_URL || 'http://localhost:11434'

  const response = await fetch(`${ollamaUrl}/api/generate`, {
    method: 'POST',
    body: JSON.stringify({
      model: process.env.OLLAMA_MODEL || 'mistral',
      prompt: `${SYSTEM_PROMPT}\n\nCurrent time: ${now}\n\nTasks to schedule:\n${JSON.stringify(tasks, null, 2)}`,
      stream: false,
    }),
  })

  if (!response.ok) {
    throw new Error(`Ollama API error: ${response.statusText}`)
  }

  const data = await response.json()
  const jsonMatch = data.response.match(/\{[\s\S]*\}/)
  const parsed = jsonMatch ? JSON.parse(jsonMatch[0]) : { recommendations: [] }
  return parsed
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' })
    return
  }

  const { tasks, now } = req.body || {}

  if (!Array.isArray(tasks) || tasks.length === 0) {
    res.status(400).json({ error: 'tasks must be a non-empty array' })
    return
  }

  try {
    const provider = process.env.AI_PROVIDER || 'claude'
    let parsed

    if (provider === 'huggingface') {
      if (!process.env.HUGGINGFACE_API_KEY) {
        return res.status(503).json({ error: 'HuggingFace API key not configured' })
      }
      parsed = await schedulerWithHuggingFace(tasks, now)
    } else if (provider === 'ollama') {
      parsed = await schedulerWithOllama(tasks, now)
    } else {
      if (!process.env.ANTHROPIC_API_KEY) {
        return res.status(503).json({ error: 'Anthropic API key not configured' })
      }
      parsed = await schedulerWithClaude(tasks, now)
    }

    res.status(200).json(parsed)
  } catch (err) {
    console.error('Scheduling request failed:', err)
    res.status(502).json({ error: 'Failed to get scheduling recommendations' })
  }
}
