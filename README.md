# Sabeel API Documentation

## Base URL
```
Production: https://sabeel-server.vercel.app/api
```

## Authentication
All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 🔐 Authentication Endpoints

### 1. User Registration
**POST** `/auth/signup`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "displayName": "John Doe" // Optional
}
```

**Response (Success - 201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "64a1b2c3d4e5f6789abcdef0",
      "email": "user@example.com",
      "displayName": "John Doe",
      "createdAt": "2023-07-01T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Response (Error - 400):**
```json
{
  "success": false,
  "message": "An account already exists with this email"
}
```

---

### 2. User Login
**POST** `/auth/signin`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Logged in successfully",
  "data": {
    "user": {
      "id": "64a1b2c3d4e5f6789abcdef0",
      "email": "user@example.com",
      "displayName": "John Doe",
      "createdAt": "2023-07-01T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Response (Error - 400):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

---

### 3. Get Current User
**GET** `/auth/me`

**Headers:**
```
Authorization: Bearer <your_jwt_token>
```

**Response (Success - 200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "64a1b2c3d4e5f6789abcdef0",
      "email": "user@example.com",
      "displayName": "John Doe",
      "createdAt": "2023-07-01T10:30:00.000Z"
    }
  }
}
```

**Response (Error - 404):**
```json
{
  "success": false,
  "message": "User not found"
}
```

---

### 4. User Logout
**POST** `/auth/signout`

**Headers:**
```
Authorization: Bearer <your_jwt_token>
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "User signed out successfully (token discarded by client)"
}
```

---

## 🤖 AI Endpoints

### 1. Get AI Insight
**POST** `/ai/insight`

**Headers:**
```
Authorization: Bearer <your_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "user_input_self_reflection": "I have always been drawn to helping others and find peace in nature...",
  "user_input_divine_signs": "I've experienced several moments where I felt guided...",
  "user_input_talents": "I'm naturally good at listening and have a talent for writing...",
  "user_input_service": "I feel called to help people find their spiritual path..."
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "data": {
    "insight": "Based on your reflections, your purpose seems to align with spiritual guidance and helping others find their path. Your natural talents in listening and writing, combined with your experiences of divine guidance, suggest a calling toward spiritual mentorship...",
    "user_input_self_reflection": "I have always been drawn to helping others...",
    "user_input_divine_signs": "I've experienced several moments...",
    "user_input_talents": "I'm naturally good at listening...",
    "user_input_service": "I feel called to help people...",
    "interactionId": "64a1b2c3d4e5f6789abcdef1",
    "timestamp": "2023-07-01T10:30:00.000Z"
  }
}
```

**Response (Error - 503):**
```json
{
  "success": false,
  "message": "AI service is not configured. Please set OPENAI_API_KEY environment variable."
}
```

**Response (Error - 429):**
```json
{
  "success": false,
  "message": "Too many requests. Please wait a moment and try again."
}
```

---

### 2. Get AI History
**GET** `/ai/history`

**Headers:**
```
Authorization: Bearer <your_jwt_token>
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)

**Example:**
```
GET /ai/history?page=1&limit=10
```

**Response (Success - 200):**
```json
{
  "success": true,
  "data": {
    "interactions": [
      {
        "id": "64a1b2c3d4e5f6789abcdef1",
        "response": "Based on your reflections, your purpose seems to align with spiritual guidance...",
        "timestamp": "2023-07-01T10:30:00.000Z",
        "type": "purpose_insight"
      },
      {
        "id": "64a1b2c3d4e5f6789abcdef2",
        "response": "Your journey shows a clear pattern of service and compassion...",
        "timestamp": "2023-07-01T09:15:00.000Z",
        "type": "purpose_insight"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 3,
      "totalInteractions": 25,
      "hasNextPage": true,
      "hasPrevPage": false
    }
  }
}
```

**Response (Error - 500):**
```json
{
  "success": false,
  "message": "Failed to retrieve interaction history"
}
```

---

## 📝 Error Responses

### Common Error Codes

**400 Bad Request:**
```json
{
  "success": false,
  "message": "Invalid request data"
}
```

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

**403 Forbidden:**
```json
{
  "success": false,
  "message": "Access denied. Invalid token."
}
```

**404 Not Found:**
```json
{
  "success": false,
  "message": "Resource not found"
}
```

**429 Too Many Requests:**
```json
{
  "success": false,
  "message": "Too many requests. Please wait a moment and try again."
}
```

**500 Internal Server Error:**
```json
{
  "success": false,
  "message": "Internal server error"
}
```

**503 Service Unavailable:**
```json
{
  "success": false,
  "message": "AI service temporarily unavailable. Please try again later."
}
```

---

## 🔧 Implementation Examples

### JavaScript/Fetch Example
```javascript
// User Registration
const registerUser = async (email, password, displayName) => {
  try {
    const response = await fetch('https://sabeel-server.vercel.app/api/auth/signup', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email,
        password,
        displayName
      })
    });
    
    const data = await response.json();
    
    if (data.success) {
      // Store token for future requests
      localStorage.setItem('token', data.data.token);
      return data.data.user;
    } else {
      throw new Error(data.message);
    }
  } catch (error) {
    console.error('Registration failed:', error);
    throw error;
  }
};

// Get AI Insight
const getAIInsight = async (inputs) => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch('https://sabeel-server.vercel.app/api/ai/insight', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify(inputs)
    });
    
    const data = await response.json();
    
    if (data.success) {
      return data.data.insight;
    } else {
      throw new Error(data.message);
    }
  } catch (error) {
    console.error('AI request failed:', error);
    throw error;
  }
};
```

### cURL Examples
```bash
# User Registration
curl -X POST https://sabeel-server.vercel.app/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "displayName": "John Doe"
  }'

# User Login
curl -X POST https://sabeel-server.vercel.app/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'

# Get AI Insight
curl -X POST https://sabeel-server.vercel.app/api/ai/insight \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "user_input_self_reflection": "I have always been drawn to helping others...",
    "user_input_divine_signs": "I have experienced several moments...",
    "user_input_talents": "I am naturally good at listening...",
    "user_input_service": "I feel called to help people..."
  }'

# Get AI History
curl -X GET "https://sabeel-server.vercel.app/api/ai/history?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## 🔒 Security Notes

1. **JWT Tokens**: Store securely and include in Authorization header
2. **HTTPS**: Always use HTTPS in production
3. **Rate Limiting**: API has rate limiting (100 requests per 15 minutes)
4. **Password Requirements**: Minimum 6 characters
5. **Token Expiration**: Tokens expire after 7 days

---

## 📊 Rate Limits

- **Authentication endpoints**: 5 requests per 15 minutes per IP
- **AI endpoints**: 100 requests per 15 minutes per user
- **General endpoints**: 100 requests per 15 minutes per IP

---

## 🚀 Deployment Status

- **Production**: ✅ Live at `https://sabeel-server.vercel.app`
- **Database**: MongoDB Atlas
- **AI Service**: OpenAI GPT-3.5-turbo
- **Authentication**: JWT-based
- **CORS**: Enabled for web applications


**Last Updated**: October 2025
**Version**: 1.0.0
