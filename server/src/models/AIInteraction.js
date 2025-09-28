import mongoose from 'mongoose';

const aiInteractionSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  userInputSelfReflection: {
    type: String,
    required: true
  },
  userInputDivineSigns: {
    type: String,
    required: true
  },
  userInputTalents: {
    type: String,
    required: true
  },
  userInputService: {
    type: String,
    required: true
  },
  aiResponse: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index for better performance
aiInteractionSchema.index({ userId: 1, timestamp: -1 });
aiInteractionSchema.index({ timestamp: -1 });

export default mongoose.model('AIInteraction', aiInteractionSchema);
