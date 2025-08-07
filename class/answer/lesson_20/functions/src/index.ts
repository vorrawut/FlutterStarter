import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Import function modules
import * as notificationFunctions from './notifications';
import * as socialFunctions from './social';
import * as backgroundFunctions from './background';
import * as apiFunctions from './api';

// Export all functions
export const notifications = notificationFunctions;
export const social = socialFunctions;
export const background = backgroundFunctions;
export const api = apiFunctions;

// Health check function
export const healthCheck = functions.https.onRequest((req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
  });
});

// Global error handler
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
});
