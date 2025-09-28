import express from 'express';
import { validateAIRequest, handleValidationErrors } from '../middleware/validation.js';
import { authenticateToken } from '../middleware/auth.js';
import aiController from '../controllers/aiController.js';

const router = express.Router();

// @route   POST /api/ai/insight
// @desc    Get AI insight based on user input
// @access  Private
router.post('/insight', authenticateToken, validateAIRequest, handleValidationErrors, aiController.getInsight);

// @route   GET /api/ai/history
// @desc    Get user's AI interaction history
// @access  Private
router.get('/history', authenticateToken, aiController.getHistory);

export default router;
