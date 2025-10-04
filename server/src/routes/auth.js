import express from 'express';
import { authenticateToken } from '../middleware/auth.js';
import authController from '../controllers/authController.js';

const router = express.Router();

// @route   POST /api/auth/signup
// @desc    Register a new user
// @access  Public
router.post('/signup', authController.signUp);

// @route   POST /api/auth/signin
// @desc    Sign in user
// @access  Public
router.post('/signin', authController.signIn);

// @route   GET /api/auth/me
// @desc    Get current user
// @access  Private
router.get('/me', authenticateToken, authController.getCurrentUser);

// @route   POST /api/auth/signout
// @desc    Sign out user (client-side token removal)
// @access  Private
router.post('/signout', authenticateToken, authController.signOut);

export default router;
