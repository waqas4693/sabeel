# Sabeel Server

A Node.js server for the Sabeel app that provides authentication and AI-powered insights using MongoDB and OpenAI.

## Features

- **Authentication**: JWT-based authentication with MongoDB user storage
- **AI Integration**: OpenAI-powered insights for life purpose discovery
- **Security**: Rate limiting, CORS, helmet security headers
- **Validation**: Input validation and error handling
- **Logging**: Request logging with Morgan

## Prerequisites

- Node.js 18 or higher
- MongoDB (local or cloud)
- OpenAI API key

## Installation

1. Clone the repository and navigate to the server directory:
   ```bash
   cd server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create environment file:
   ```bash
   cp env.example .env
   ```

4. Update the `.env` file with your configuration:
   ```env
   PORT=3000
   NODE_ENV=development
   MONGODB_URI=mongodb://localhost:27017/sabeelapp
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
   JWT_EXPIRES_IN=7d
   OPENAI_API_KEY=your-openai-api-key-here
   CORS_ORIGIN=http://localhost:3000
   ```

## Running the Server

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on the port specified in your `.env` file (default: 3000).

## API Endpoints

### Authentication

#### POST `/api/auth/signup`
Register a new user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "displayName": "John Doe" // optional
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "displayName": "John Doe",
      "createdAt": "2024-01-01T00:00:00.000Z"
    },
    "token": "jwt_token"
  }
}
```

#### POST `/api/auth/signin`
Sign in an existing user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Sign in successful",
  "data": {
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "displayName": "John Doe",
      "lastLogin": "2024-01-01T00:00:00.000Z",
      "createdAt": "2024-01-01T00:00:00.000Z"
    },
    "token": "jwt_token"
  }
}
```

#### GET `/api/auth/me`
Get current user information.

**Headers:**
```
Authorization: Bearer jwt_token
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "displayName": "John Doe",
      "lastLogin": "2024-01-01T00:00:00.000Z",
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

#### POST `/api/auth/signout`
Sign out user (client-side token removal).

**Headers:**
```
Authorization: Bearer jwt_token
```

### AI Insights

#### POST `/api/ai/insight`
Get AI-powered life purpose insight.

**Headers:**
```
Authorization: Bearer jwt_token
```

**Request Body:**
```json
{
  "user_input_self_reflection": "I value honesty and integrity...",
  "user_input_divine_signs": "I've experienced many coincidences...",
  "user_input_talents": "I'm good at listening and helping others...",
  "user_input_service": "I want to help people find their purpose..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "insight": "Based on your reflections, your purpose seems to be...",
    "user_input_self_reflection": "I value honesty and integrity...",
    "user_input_divine_signs": "I've experienced many coincidences...",
    "user_input_talents": "I'm good at listening and helping others...",
    "user_input_service": "I want to help people find their purpose...",
    "interactionId": "interaction_id",
    "timestamp": "2024-01-01T00:00:00.000Z"
  }
}
```

#### GET `/api/ai/history`
Get user's AI interaction history.

**Headers:**
```
Authorization: Bearer jwt_token
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)

**Response:**
```json
{
  "success": true,
  "data": {
    "interactions": [
      {
        "id": "interaction_id",
        "aiResponse": "Based on your reflections...",
        "timestamp": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalInteractions": 50,
      "hasNextPage": true,
      "hasPrevPage": false
    }
  }
}
```

### Health Check

#### GET `/health`
Check server health status.

**Response:**
```json
{
  "status": "OK",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 3600,
  "environment": "development"
}
```

## Error Handling

All API endpoints return consistent error responses:

```json
{
  "success": false,
  "message": "Error description",
  "errors": [] // Validation errors (if any)
}
```

## Security Features

- **Rate Limiting**: 100 requests per 15 minutes per IP
- **CORS**: Configurable cross-origin resource sharing
- **Helmet**: Security headers
- **JWT**: Secure token-based authentication
- **Password Hashing**: bcrypt with salt rounds
- **Input Validation**: Request validation and sanitization

## Database Schema

### User Model
- `email`: String (unique, required)
- `password`: String (hashed, required)
- `displayName`: String (optional)
- `isActive`: Boolean (default: true)
- `lastLogin`: Date
- `createdAt`: Date
- `updatedAt`: Date

### AIInteraction Model
- `userId`: ObjectId (reference to User)
- `userInputSelfReflection`: String
- `userInputDivineSigns`: String
- `userInputTalents`: String
- `userInputService`: String
- `aiResponse`: String
- `timestamp`: Date

## Development

### Project Structure
```
server/
├── src/
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/         # MongoDB models
│   ├── routes/         # API routes
│   ├── services/       # Business logic
│   ├── utils/          # Utility functions
│   └── index.js        # Main server file
├── package.json
├── env.example
└── README.md
```

### Testing
```bash
npm test
```

## Deployment

1. Set `NODE_ENV=production` in your environment
2. Use a production MongoDB instance
3. Set a strong `JWT_SECRET`
4. Configure proper CORS origins
5. Use a process manager like PM2 for production

## License

MIT
