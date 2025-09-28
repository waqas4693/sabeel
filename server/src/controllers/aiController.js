import OpenAI from 'openai';
import AIInteraction from '../models/AIInteraction.js';

// Initialize OpenAI only if API key is provided
let openai = null;
if (process.env.OPENAI_API_KEY) {
  openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });
}

const aiController = {
  // Get AI insight based on user input
  getInsight: async (req, res) => {
    try {
      const {
        user_input_self_reflection,
        user_input_divine_signs,
        user_input_talents,
        user_input_service
      } = req.body;

      const userId = req.user._id;

      // Check if OpenAI is configured
      if (!openai) {
        return res.status(503).json({
          success: false,
          message: 'AI service is not configured. Please set OPENAI_API_KEY environment variable.'
        });
      }

      // Create the prompt for OpenAI
      const prompt = `
discover their purpose in life, especially from a faith-rooted and
Islamic values perspective. A user has reflected on four key areas
of their life:
1. **Self-Reflection & Understanding** – Their core values,
identity, and how they've changed over time.
2. **Divine Signs & Guidance** – Significant spiritual signs,
prayers answered, divine timing, and people or moments that felt
like divine guidance.
3. **Talents & Blessings** – The unique strengths, skills, and
traits they possess, as well as how others recognize these traits.
4. **Service & Purpose** – Who they feel called to help, what
causes resonate with them, and how they visualize a meaningful,
purposeful life.

Here are the user's answers to each section:
**Self-Reflection & Understanding:**
${user_input_self_reflection}

**Divine Signs & Guidance:**
${user_input_divine_signs}

**Talents & Blessings:**
${user_input_talents}

**Service & Purpose:**
${user_input_service}

Based on these reflections, offer the user a thoughtful and
spiritually aligned response that:
- Summarizes the key patterns or values in their reflections.
- Suggests what their unique life purpose might be, grounded in
faith, values, and service.
- Encourages them with a short reflection or quote rooted in
Islamic wisdom or general spiritual insight.
- Uses a warm, supportive tone that respects their personal journey
and invites further reflection.

Avoid being too generic. Be specific, meaningful, and sincere. The
goal is to gently guide, not dictate.

Respond directly to the user.`;

      // Call OpenAI API
      const completion = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "system",
            content: "You are a knowledgeable Islamic scholar providing Quranic insights with wisdom and respect."
          },
          {
            role: "user",
            content: prompt
          }
        ],
        max_tokens: 500,
        temperature: 0.7,
      });

      const aiResponse = completion.choices[0].message.content;

      // Store the interaction in MongoDB
      const interaction = new AIInteraction({
        userId,
        userInputSelfReflection: user_input_self_reflection,
        userInputDivineSigns: user_input_divine_signs,
        userInputTalents: user_input_talents,
        userInputService: user_input_service,
        aiResponse
      });

      await interaction.save();

      // Return the response
      res.status(200).json({
        success: true,
        data: {
          insight: aiResponse,
          user_input_self_reflection,
          user_input_divine_signs,
          user_input_talents,
          user_input_service,
          interactionId: interaction._id,
          timestamp: interaction.timestamp
        }
      });

    } catch (error) {
      console.error('AI insight error:', error);
      
      // Handle OpenAI API errors
      if (error.code === 'insufficient_quota') {
        return res.status(503).json({
          success: false,
          message: 'AI service temporarily unavailable. Please try again later.'
        });
      }

      if (error.code === 'rate_limit_exceeded') {
        return res.status(429).json({
          success: false,
          message: 'Too many requests. Please wait a moment and try again.'
        });
      }

      res.status(500).json({
        success: false,
        message: 'Failed to generate AI insight. Please try again.'
      });
    }
  },

  // Get user's AI interaction history
  getHistory: async (req, res) => {
    try {
      const userId = req.user._id;
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 10;
      const skip = (page - 1) * limit;

      const interactions = await AIInteraction.find({ userId })
        .sort({ timestamp: -1 })
        .skip(skip)
        .limit(limit)
        .select('-userInputSelfReflection -userInputDivineSigns -userInputTalents -userInputService');

      const total = await AIInteraction.countDocuments({ userId });

      res.status(200).json({
        success: true,
        data: {
          interactions,
          pagination: {
            currentPage: page,
            totalPages: Math.ceil(total / limit),
            totalInteractions: total,
            hasNextPage: page < Math.ceil(total / limit),
            hasPrevPage: page > 1
          }
        }
      });
    } catch (error) {
      console.error('Get history error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to retrieve interaction history'
      });
    }
  }
};

export default aiController;
