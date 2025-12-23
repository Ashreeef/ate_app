package com.example.ate_app

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.util.Log

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage)
        {
            super.onMessageReceived(remoteMessage)
            Log.d("FCM", "From: ${remoteMessage.from}")

            // Handle notification
            remoteMessage.notification?.let {
                Log.d("FCM", "Notification: ${it.title}")
                Log.d("FCM", "Body: ${it.body}")
            }
 
            // Handle data payload
            remoteMessage.data.isNotEmpty().let {
                Log.d("FCM", "Data: ${remoteMessage.data}")
            }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "New token: $token")
        sendTokenToServer(token)
    }
    
    private fun sendTokenToServer(token: String) {
        // Will implement in Dart layer
    }
}