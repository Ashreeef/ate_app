# Backend Integration Examples

## Node.js / Firebase Admin SDK

### 1. Install Firebase Admin SDK
```bash
npm install firebase-admin
```

### 2. Initialize Firebase
```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./path/to/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const messaging = admin.messaging();
```

### 3. Send Single Notification
```javascript
async function sendNotification(token, title, body, data) {
  const message = {
    token: token,
    notification: {
      title: title,
      body: body
    },
    data: data,
    android: {
      priority: 'high',
      ttl: 86400 // 24 hours
    },
    apns: {
      headers: {
        'apns-priority': '10'
      }
    }
  };

  try {
    const response = await messaging.send(message);
    console.log('Notification sent:', response);
    return response;
  } catch (error) {
    console.error('Error sending notification:', error);
    throw error;
  }
}
```

### 4. Send Topic Notification
```javascript
async function sendTopicNotification(topic, title, body, data) {
  const message = {
    topic: topic,
    notification: {
      title: title,
      body: body
    },
    data: data
  };

  try {
    const response = await messaging.send(message);
    console.log('Topic notification sent:', response);
    return response;
  } catch (error) {
    console.error('Error sending topic notification:', error);
    throw error;
  }
}

// Subscribe user to topic (on login)
async function subscribeToTopic(tokens, topic) {
  try {
    const response = await messaging.subscribeToTopic(tokens, topic);
    console.log('Subscribed to topic:', response);
    return response;
  } catch (error) {
    console.error('Error subscribing to topic:', error);
    throw error;
  }
}
```

### 5. Scheduled Notifications (Node-cron)
```javascript
const cron = require('node-cron');

// Send daily digest at 9 AM
cron.schedule('0 9 * * *', async () => {
  try {
    // Get all users with FCM tokens
    const users = await db.collection('users').where('fcmToken', '!=', null).get();
    
    for (const userDoc of users.docs) {
      const user = userDoc.data();
      
      // Create personalized message
      const message = {
        token: user.fcmToken,
        notification: {
          title: `Good morning ${user.username}!`,
          body: 'Check out what\'s new today'
        },
        data: {
          type: 'digest'
        }
      };
      
      await messaging.send(message);
    }
    
    console.log('Daily digest sent to all users');
  } catch (error) {
    console.error('Error sending daily digest:', error);
  }
});
```

### 6. API Endpoint Examples
```javascript
const express = require('express');
const router = express.Router();

// Store FCM token
router.post('/api/users/fcm-token', async (req, res) => {
  try {
    const { userId, token } = req.body;
    
    // Update user with FCM token
    await db.collection('users').doc(userId).update({
      fcmToken: token,
      lastTokenUpdate: admin.firestore.FieldValue.serverTimestamp()
    });
    
    res.json({ success: true, message: 'FCM token updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Send notification
router.post('/api/notifications/send', async (req, res) => {
  try {
    const { userId, title, body, type, data } = req.body;
    
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    const token = userDoc.data().fcmToken;
    
    if (!token) {
      return res.status(404).json({ error: 'User FCM token not found' });
    }
    
    // Send notification
    const message = {
      token: token,
      notification: { title, body },
      data: {
        type: type,
        ...data
      }
    };
    
    const response = await messaging.send(message);
    res.json({ success: true, messageId: response });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Broadcast notification
router.post('/api/notifications/broadcast', async (req, res) => {
  try {
    const { title, body, type, data } = req.body;
    
    // Send to all users (multicast)
    const users = await db.collection('users').where('fcmToken', '!=', null).get();
    const tokens = users.docs.map(doc => doc.data().fcmToken);
    
    const message = {
      notification: { title, body },
      data: {
        type: type,
        ...data
      }
    };
    
    const response = await messaging.sendMulticast({
      ...message,
      tokens: tokens
    });
    
    res.json({ 
      success: true, 
      successCount: response.successCount,
      failureCount: response.failureCount
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

---

## Python / Flask

### 1. Install Firebase Admin SDK
```bash
pip install firebase-admin
```

### 2. Initialize Firebase
```python
import firebase_admin
from firebase_admin import credentials
from firebase_admin import messaging

# Initialize Firebase
cred = credentials.Certificate('path/to/serviceAccountKey.json')
firebase_admin.initialize_app(cred)
```

### 3. Send Notification
```python
def send_notification(token, title, body, data=None):
    """Send a notification to a specific device"""
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=data or {},
        token=token,
        android=messaging.AndroidConfig(
            priority='high',
            ttl=86400,  # 24 hours
        ),
        apns=messaging.APNSConfig(
            headers={'apns-priority': '10'}
        )
    )
    
    try:
        response = messaging.send(message)
        print(f'Notification sent: {response}')
        return response
    except Exception as e:
        print(f'Error sending notification: {e}')
        raise
```

### 4. Send to Topic
```python
def send_topic_notification(topic, title, body, data=None):
    """Send notification to all users subscribed to topic"""
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=data or {},
        topic=topic,
    )
    
    try:
        response = messaging.send(message)
        print(f'Topic notification sent: {response}')
        return response
    except Exception as e:
        print(f'Error sending topic notification: {e}')
        raise
```

### 5. Scheduled Notifications (APScheduler)
```python
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime

scheduler = BackgroundScheduler()

def send_daily_digest():
    """Send daily digest to all users"""
    try:
        from your_db import get_all_users
        
        users = get_all_users()
        for user in users:
            if user.fcm_token:
                send_notification(
                    token=user.fcm_token,
                    title=f"Good morning {user.username}!",
                    body="Check out what's new today",
                    data={'type': 'digest'}
                )
        
        print(f'Daily digest sent at {datetime.now()}')
    except Exception as e:
        print(f'Error sending daily digest: {e}')

# Schedule for 9 AM every day
scheduler.add_job(send_daily_digest, 'cron', hour=9, minute=0)
scheduler.start()
```

### 6. Flask API Endpoints
```python
from flask import Flask, request, jsonify
from flask_cors import CORS
from your_db import db, User

app = Flask(__name__)
CORS(app)

@app.route('/api/users/fcm-token', methods=['POST'])
def store_fcm_token():
    """Store FCM token for user"""
    try:
        data = request.get_json()
        user_id = data.get('userId')
        token = data.get('token')
        
        if not user_id or not token:
            return jsonify({'error': 'Missing userId or token'}), 400
        
        # Update user with FCM token
        user = User.query.get(user_id)
        user.fcm_token = token
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'FCM token updated'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/send', methods=['POST'])
def send_notification_endpoint():
    """Send notification to specific user"""
    try:
        data = request.get_json()
        user_id = data.get('userId')
        title = data.get('title')
        body = data.get('body')
        ntype = data.get('type')
        extra_data = data.get('data', {})
        
        # Get user's FCM token
        user = User.query.get(user_id)
        if not user or not user.fcm_token:
            return jsonify({'error': 'User FCM token not found'}), 404
        
        # Send notification
        response = send_notification(
            token=user.fcm_token,
            title=title,
            body=body,
            data={'type': ntype, **extra_data}
        )
        
        return jsonify({'success': True, 'messageId': response})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/broadcast', methods=['POST'])
def broadcast_notification():
    """Send notification to all users"""
    try:
        data = request.get_json()
        title = data.get('title')
        body = data.get('body')
        ntype = data.get('type')
        extra_data = data.get('data', {})
        
        # Get all users with FCM tokens
        users = User.query.filter(User.fcm_token.isnot(None)).all()
        
        success_count = 0
        fail_count = 0
        
        for user in users:
            try:
                send_notification(
                    token=user.fcm_token,
                    title=title,
                    body=body,
                    data={'type': ntype, **extra_data}
                )
                success_count += 1
            except Exception as e:
                print(f'Failed to send to {user.id}: {e}')
                fail_count += 1
        
        return jsonify({
            'success': True,
            'successCount': success_count,
            'failureCount': fail_count
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
```

---

## Django

### 1. Install Firebase Admin SDK
```bash
pip install firebase-admin
```

### 2. Django Settings
```python
# settings.py

import firebase_admin
from firebase_admin import credentials

# Initialize Firebase
FIREBASE_CRED = credentials.Certificate('path/to/serviceAccountKey.json')
firebase_admin.initialize_app(FIREBASE_CRED)
```

### 3. Models
```python
# models.py

from django.db import models

class UserFCMToken(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    token = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'user_fcm_tokens'
```

### 4. Views
```python
# views.py

from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from firebase_admin import messaging
import json

@require_http_methods(["POST"])
@csrf_exempt
def store_fcm_token(request):
    """Store FCM token for user"""
    try:
        data = json.loads(request.body)
        user_id = data.get('userId')
        token = data.get('token')
        
        if not user_id or not token:
            return JsonResponse({'error': 'Missing userId or token'}, status=400)
        
        user = User.objects.get(id=user_id)
        fcm_token, created = UserFCMToken.objects.update_or_create(
            user=user,
            defaults={'token': token}
        )
        
        return JsonResponse({'success': True, 'message': 'FCM token updated'})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@require_http_methods(["POST"])
@csrf_exempt
def send_notification(request):
    """Send notification to specific user"""
    try:
        data = json.loads(request.body)
        user_id = data.get('userId')
        title = data.get('title')
        body = data.get('body')
        ntype = data.get('type')
        
        # Get user's FCM token
        fcm_token = UserFCMToken.objects.get(user_id=user_id).token
        
        # Send notification
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body
            ),
            data={'type': ntype},
            token=fcm_token
        )
        
        response = messaging.send(message)
        return JsonResponse({'success': True, 'messageId': response})
    except UserFCMToken.DoesNotExist:
        return JsonResponse({'error': 'User FCM token not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
```

---

## General Best Practices

### Rate Limiting
```
- Max 100 notifications per user per day
- Max 10 notifications per hour
- Implement exponential backoff for retries
```

### Error Handling
```
- Handle InvalidArgumentError (bad token)
- Handle MessagingQuotaExceededError (quota exceeded)
- Handle ThirdPartyAuthError (auth issues)
- Log all failures for monitoring
```

### Token Management
```
- Store FCM token with timestamp
- Refresh token when app launches
- Remove token on logout
- Handle invalid tokens gracefully
```

### Security
```
- Never log sensitive data
- Use HTTPS only
- Validate all input data
- Implement authentication on endpoints
- Use environment variables for secrets
```

---

**Last Updated**: December 14, 2025
**Status**: Ready for Implementation
