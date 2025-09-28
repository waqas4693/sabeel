import { body, validationResult } from 'express-validator';

const validateSignUp = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('Password must contain at least one uppercase letter, one lowercase letter, and one number'),
  body('displayName')
    .optional()
    .isLength({ max: 50 })
    .withMessage('Display name cannot exceed 50 characters')
    .trim()
];

const validateSignIn = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  body('password')
    .notEmpty()
    .withMessage('Password is required')
];

const validateAIRequest = [
  body('user_input_self_reflection')
    .notEmpty()
    .withMessage('Self reflection input is required'),
  body('user_input_divine_signs')
    .notEmpty()
    .withMessage('Divine signs input is required'),
  body('user_input_talents')
    .notEmpty()
    .withMessage('Talents input is required'),
  body('user_input_service')
    .notEmpty()
    .withMessage('Service input is required')
];

const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array()
    });
  }
  next();
};

export {
  validateSignUp,
  validateSignIn,
  validateAIRequest,
  handleValidationErrors
};
