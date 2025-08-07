import * as admin from 'firebase-admin';

export interface NotificationData {
  title: string;
  body: string;
  type: NotificationType;
  targetUserId: string;
  data?: Record<string, any>;
  priority?: 'high' | 'normal';
  icon?: string;
  sound?: string;
  badge?: number;
}

export enum NotificationType {
  NEW_POST = 'new_post',
  NEW_LIKE = 'new_like',
  NEW_COMMENT = 'new_comment',
  FRIEND_REQUEST = 'friend_request',
  NEW_MESSAGE = 'new_message',
  SYSTEM_ALERT = 'system_alert',
  WELCOME = 'welcome',
  REMINDER = 'reminder',
}

export interface UserTokens {
  fcmTokens: string[];
  lastUpdated: admin.firestore.Timestamp;
}

export interface CloudFunctionResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
  requestId?: string;
}

export interface NotificationTemplate {
  title: string;
  body: string;
  icon?: string;
  color?: string;
  sound?: string;
  badge?: number;
  data?: Record<string, any>;
}

export interface NotificationTarget {
  type: 'user' | 'topic' | 'condition' | 'tokens';
  value: string | string[];
}

export interface PostData {
  id: string;
  authorId: string;
  authorName?: string;
  authorAvatar?: string;
  content: string;
  imageUrls: string[];
  hashtags: string[];
  mentions: string[];
  likesCount: number;
  commentsCount: number;
  sharesCount: number;
  visibility: string;
  createdAt: admin.firestore.Timestamp;
  updatedAt: admin.firestore.Timestamp;
}

export interface CommentData {
  id: string;
  postId: string;
  authorId: string;
  authorName?: string;
  authorAvatar?: string;
  content: string;
  likesCount: number;
  parentCommentId?: string;
  createdAt: admin.firestore.Timestamp;
  updatedAt: admin.firestore.Timestamp;
}

export interface LikeData {
  id: string;
  userId: string;
  targetId: string;
  targetType: 'post' | 'comment';
  createdAt: admin.firestore.Timestamp;
}

export interface FollowData {
  id: string;
  followerId: string;
  followingId: string;
  createdAt: admin.firestore.Timestamp;
  isActive: boolean;
}

export interface UserData {
  id: string;
  email: string;
  displayName: string;
  photoURL?: string;
  bio?: string;
  followersCount: number;
  followingCount: number;
  postsCount: number;
  isPublic: boolean;
  isActive: boolean;
  isVerified: boolean;
  createdAt: admin.firestore.Timestamp;
  updatedAt: admin.firestore.Timestamp;
  lastSeenAt?: admin.firestore.Timestamp;
  fcmTokens?: string[];
}

export interface ModerationResult {
  flagged: boolean;
  flags: string[];
  confidence: number;
  severity: 'low' | 'medium' | 'high';
  action: 'allow' | 'review' | 'block';
}

export interface AnalyticsEvent {
  eventName: string;
  userId?: string;
  data: Record<string, any>;
  timestamp: admin.firestore.Timestamp;
  platform: 'ios' | 'android' | 'web';
  sessionId?: string;
}

export interface BatchOperation {
  type: 'set' | 'update' | 'delete';
  ref: admin.firestore.DocumentReference;
  data?: any;
}

export interface NotificationPreferences {
  pushNotifications: boolean;
  emailNotifications: boolean;
  inAppNotifications: boolean;
  likes: boolean;
  comments: boolean;
  follows: boolean;
  messages: boolean;
  posts: boolean;
  quietHours: {
    enabled: boolean;
    startTime: string; // "22:00"
    endTime: string;   // "08:00"
  };
}

export interface ErrorLog {
  functionName: string;
  error: string;
  context: Record<string, any>;
  timestamp: admin.firestore.Timestamp;
  severity: 'low' | 'medium' | 'high' | 'critical';
  userId?: string;
  resolved: boolean;
}
