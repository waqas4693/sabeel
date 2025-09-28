import User from '../models/User.js';
import { generateToken } from '../utils/jwt.js';

const authController = {
  // Sign up a new user
  signUp: async (req, res) => {
    try {
      const { email, password, displayName } = req.body;

      // Check if user already exists
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: 'An account already exists with this email'
        });
      }

      // Create new user
      const user = new User({
        email,
        password,
        displayName: displayName || email.split('@')[0]
      });

      await user.save();

      // Generate JWT token
      const token = generateToken(user._id);

      // Update last login
      user.lastLogin = new Date();
      await user.save();

      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: {
          user: {
            id: user._id,
            email: user.email,
            displayName: user.displayName,
            createdAt: user.createdAt
          },
          token
        }
      });
    } catch (error) {
      console.error('Sign up error:', error);
      res.status(500).json({
        success: false,
        message: 'Registration failed. Please try again.'
      });
    }
  },

  // Sign in user
  signIn: async (req, res) => {
    try {
      const { email, password } = req.body;

      // Find user by email
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'No user found with this email'
        });
      }

      // Check if user is active
      if (!user.isActive) {
        return res.status(401).json({
          success: false,
          message: 'This account has been disabled'
        });
      }

      // Check password
      const isPasswordValid = await user.comparePassword(password);
      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          message: 'Wrong password provided'
        });
      }

      // Generate JWT token
      const token = generateToken(user._id);

      // Update last login
      user.lastLogin = new Date();
      await user.save();

      res.status(200).json({
        success: true,
        message: 'Sign in successful',
        data: {
          user: {
            id: user._id,
            email: user.email,
            displayName: user.displayName,
            lastLogin: user.lastLogin,
            createdAt: user.createdAt
          },
          token
        }
      });
    } catch (error) {
      console.error('Sign in error:', error);
      res.status(500).json({
        success: false,
        message: 'Sign in failed. Please try again.'
      });
    }
  },

  // Get current user
  getCurrentUser: async (req, res) => {
    try {
      res.status(200).json({
        success: true,
        data: {
          user: {
            id: req.user._id,
            email: req.user.email,
            displayName: req.user.displayName,
            lastLogin: req.user.lastLogin,
            createdAt: req.user.createdAt
          }
        }
      });
    } catch (error) {
      console.error('Get current user error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to get user information'
      });
    }
  },

  // Sign out user (client-side token removal)
  signOut: async (req, res) => {
    try {
      res.status(200).json({
        success: true,
        message: 'Sign out successful'
      });
    } catch (error) {
      console.error('Sign out error:', error);
      res.status(500).json({
        success: false,
        message: 'Sign out failed'
      });
    }
  }
};

export default authController;
