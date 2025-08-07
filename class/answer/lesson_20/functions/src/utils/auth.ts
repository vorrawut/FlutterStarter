import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { UserData } from '../types';

export function requireAuth(context: functions.https.CallableContext): string {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated to access this function'
    );
  }
  return context.auth.uid;
}

export async function requireAuthAndRole(
  context: functions.https.CallableContext,
  requiredRole: string
): Promise<string> {
  const uid = requireAuth(context);
  
  const userDoc = await admin.firestore()
    .collection('users')
    .doc(uid)
    .get();
    
  if (!userDoc.exists) {
    throw new functions.https.HttpsError(
      'not-found',
      'User profile not found'
    );
  }
  
  const userData = userDoc.data() as UserData;
  if ((userData as any).role !== requiredRole) {
    throw new functions.https.HttpsError(
      'permission-denied',
      `Required role: ${requiredRole}`
    );
  }
  
  return uid;
}

export async function isAdmin(uid: string): Promise<boolean> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(uid)
      .get();
      
    const userData = userDoc.data() as UserData;
    return (userData as any)?.role === 'admin';
  } catch {
    return false;
  }
}

export async function isModerator(uid: string): Promise<boolean> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(uid)
      .get();
      
    const userData = userDoc.data() as UserData;
    const role = (userData as any)?.role;
    return role === 'admin' || role === 'moderator';
  } catch {
    return false;
  }
}

export async function getUserData(uid: string): Promise<UserData | null> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(uid)
      .get();
      
    if (!userDoc.exists) {
      return null;
    }
    
    return { id: uid, ...userDoc.data() } as UserData;
  } catch (error) {
    console.error(`Failed to get user data for ${uid}:`, error);
    return null;
  }
}

export async function validateUserExists(uid: string): Promise<boolean> {
  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(uid)
      .get();
      
    return userDoc.exists;
  } catch {
    return false;
  }
}

export async function checkUserPermission(
  uid: string,
  permission: string
): Promise<boolean> {
  try {
    const userData = await getUserData(uid);
    if (!userData) return false;
    
    const permissions = (userData as any).permissions || [];
    return permissions.includes(permission) || await isAdmin(uid);
  } catch {
    return false;
  }
}

export function generateRequestId(): string {
  return `req_${Date.now()}_${Math.random().toString(36).substring(2, 15)}`;
}

export async function logFunctionCall(
  functionName: string,
  uid: string | null,
  data: any,
  requestId: string
): Promise<void> {
  try {
    await admin.firestore().collection('functionLogs').add({
      functionName,
      uid,
      data: JSON.stringify(data),
      requestId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (error) {
    console.error('Failed to log function call:', error);
  }
}

export function createSuccessResponse<T>(
  data: T,
  requestId?: string
): functions.https.HttpsCallableResult {
  return {
    success: true,
    data,
    timestamp: new Date().toISOString(),
    requestId,
  };
}

export function createErrorResponse(
  error: string,
  requestId?: string
): functions.https.HttpsCallableResult {
  return {
    success: false,
    error,
    timestamp: new Date().toISOString(),
    requestId,
  };
}
