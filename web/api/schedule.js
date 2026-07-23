import Anthropic from '@anthropic-ai/sdk'

const client = new Anthropic()

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
    const response = await client.messages.create({
      model: 'claude-opus-4-8',
      max_tokens: 4096,
      output_config: {
        effort: 'medium',
        format: { type: 'json_schema', schema: RECOMMENDATION_SCHEMA },
      },
      system:
        'You are an AI scheduling assistant. Given a list of tasks with priority, ' +
        'estimated duration, and due dates, recommend an optimal time slot for each ' +
        'task during a standard 9am-6pm workday, Monday-Friday, starting from "now". ' +
        'Prioritize urgent and high-priority tasks earlier, respect due dates, and ' +
        'avoid overlapping time slots. Keep reasoning to one concise sentence per task.',
      messages: [
        {
          role: 'user',
          content: `Current time: ${now}\n\nTasks to schedule:\n${JSON.stringify(tasks, null, 2)}`,
        },
      ],
    })

    const textBlock = response.content.find((b) => b.type === 'text')
    const parsed = textBlock ? JSON.parse(textBlock.text) : { recommendations: [] }

    res.status(200).json(parsed)
  } catch (err) {
    console.error('Scheduling request failed:', err)
    res.status(502).json({ error: 'Failed to get scheduling recommendations' })
  }
}
