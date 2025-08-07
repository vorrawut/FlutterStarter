import { ModerationResult } from '../types';

export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function validatePhoneNumber(phone: string): boolean {
  const phoneRegex = /^\+?[1-9]\d{1,14}$/;
  return phoneRegex.test(phone);
}

export function validatePostContent(content: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!content || content.trim().length === 0) {
    errors.push('Content cannot be empty');
  }
  
  if (content.length > 10000) {
    errors.push('Content too long (max 10,000 characters)');
  }
  
  if (content.length < 1) {
    errors.push('Content too short (min 1 character)');
  }
  
  // Check for excessive hashtags
  const hashtags = content.match(/#\w+/g) || [];
  if (hashtags.length > 10) {
    errors.push('Too many hashtags (max 10)');
  }
  
  // Check for excessive mentions
  const mentions = content.match(/@\w+/g) || [];
  if (mentions.length > 10) {
    errors.push('Too many mentions (max 10)');
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function validateCommentContent(content: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!content || content.trim().length === 0) {
    errors.push('Comment cannot be empty');
  }
  
  if (content.length > 2000) {
    errors.push('Comment too long (max 2,000 characters)');
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function validateUserProfile(data: any): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!data.displayName || data.displayName.trim().length === 0) {
    errors.push('Display name is required');
  }
  
  if (data.displayName && data.displayName.length > 50) {
    errors.push('Display name too long (max 50 characters)');
  }
  
  if (data.bio && data.bio.length > 160) {
    errors.push('Bio too long (max 160 characters)');
  }
  
  if (data.website && !isValidUrl(data.website)) {
    errors.push('Invalid website URL');
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function sanitizeUserInput(input: string): string {
  return input
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;')
    .trim();
}

export function sanitizeHtml(input: string): string {
  // Basic HTML sanitization - remove all HTML tags
  return input.replace(/<[^>]*>/g, '').trim();
}

export function isValidUrl(url: string): boolean {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
}

export function extractHashtags(content: string): string[] {
  const regex = /#(\w+)/g;
  const hashtags: string[] = [];
  let match;
  
  while ((match = regex.exec(content)) !== null) {
    hashtags.push(match[1].toLowerCase());
  }
  
  // Remove duplicates and limit to 10
  return [...new Set(hashtags)].slice(0, 10);
}

export function extractMentions(content: string): string[] {
  const regex = /@(\w+)/g;
  const mentions: string[] = [];
  let match;
  
  while ((match = regex.exec(content)) !== null) {
    mentions.push(match[1].toLowerCase());
  }
  
  // Remove duplicates and limit to 10
  return [...new Set(mentions)].slice(0, 10);
}

export async function moderateContent(content: string): Promise<ModerationResult> {
  // Basic content moderation (in production, use ML services like Google Cloud Natural Language API)
  const inappropriateWords = [
    'spam', 'hate', 'abuse', 'harassment', 'bullying',
    'violence', 'threat', 'scam', 'fraud', 'illegal',
    // Add more as needed
  ];
  
  const explicitWords = [
    'explicit1', 'explicit2', // Add actual explicit words
  ];
  
  const flags: string[] = [];
  const lowerContent = content.toLowerCase();
  let severity: 'low' | 'medium' | 'high' = 'low';
  let confidence = 0;
  
  // Check for inappropriate content
  inappropriateWords.forEach(word => {
    if (lowerContent.includes(word)) {
      flags.push(`inappropriate_${word}`);
      confidence += 0.3;
      severity = 'medium';
    }
  });
  
  // Check for explicit content
  explicitWords.forEach(word => {
    if (lowerContent.includes(word)) {
      flags.push(`explicit_${word}`);
      confidence += 0.5;
      severity = 'high';
    }
  });
  
  // Check for suspicious patterns
  if (content.includes('http://') || content.includes('https://')) {
    const urlCount = (content.match(/https?:\/\/[^\s]+/g) || []).length;
    if (urlCount > 3) {
      flags.push('excessive_links');
      confidence += 0.2;
    }
  }
  
  // Check for repeated characters (spam indicator)
  if (/(.)\1{4,}/.test(content)) {
    flags.push('repeated_characters');
    confidence += 0.1;
  }
  
  // Check for excessive caps
  const capsRatio = (content.match(/[A-Z]/g) || []).length / content.length;
  if (capsRatio > 0.7 && content.length > 20) {
    flags.push('excessive_caps');
    confidence += 0.1;
  }
  
  const flagged = flags.length > 0;
  let action: 'allow' | 'review' | 'block' = 'allow';
  
  if (flagged) {
    if (severity === 'high' || confidence > 0.7) {
      action = 'block';
    } else if (severity === 'medium' || confidence > 0.3) {
      action = 'review';
    }
  }
  
  return {
    flagged,
    flags,
    confidence: Math.min(confidence, 1.0),
    severity,
    action,
  };
}

export function validateNotificationData(data: any): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!data.title || data.title.trim().length === 0) {
    errors.push('Notification title is required');
  }
  
  if (data.title && data.title.length > 100) {
    errors.push('Notification title too long (max 100 characters)');
  }
  
  if (!data.body || data.body.trim().length === 0) {
    errors.push('Notification body is required');
  }
  
  if (data.body && data.body.length > 250) {
    errors.push('Notification body too long (max 250 characters)');
  }
  
  if (!data.targetUserId || typeof data.targetUserId !== 'string') {
    errors.push('Valid target user ID is required');
  }
  
  const validTypes = ['new_post', 'new_like', 'new_comment', 'friend_request', 'new_message', 'system_alert', 'welcome', 'reminder'];
  if (!data.type || !validTypes.includes(data.type)) {
    errors.push(`Invalid notification type. Must be one of: ${validTypes.join(', ')}`);
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function rateLimitKey(uid: string, action: string): string {
  return `rate_limit:${uid}:${action}`;
}

export async function checkRateLimit(
  uid: string,
  action: string,
  maxRequests: number,
  windowMs: number
): Promise<boolean> {
  // In a real implementation, you'd use Redis or Firestore to track requests
  // For now, we'll implement a simple in-memory rate limiter
  
  const key = rateLimitKey(uid, action);
  // This would be stored in Redis or a database in production
  // For this example, we'll just return true (allowing all requests)
  return true;
}

export function generateUniqueId(): string {
  return `${Date.now()}_${Math.random().toString(36).substring(2, 15)}`;
}

export function isValidFirebaseDocumentId(id: string): boolean {
  // Firebase document IDs cannot contain certain characters
  const invalidChars = /[~*/[\]]/;
  return !invalidChars.test(id) && id.length <= 1500;
}

export function normalizeUsername(username: string): string {
  return username.toLowerCase().replace(/[^a-z0-9_]/g, '');
}

export function validateUsername(username: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  
  if (!username || username.trim().length === 0) {
    errors.push('Username is required');
  }
  
  if (username.length < 3) {
    errors.push('Username too short (min 3 characters)');
  }
  
  if (username.length > 30) {
    errors.push('Username too long (max 30 characters)');
  }
  
  if (!/^[a-zA-Z0-9_]+$/.test(username)) {
    errors.push('Username can only contain letters, numbers, and underscores');
  }
  
  if (/^[0-9]/.test(username)) {
    errors.push('Username cannot start with a number');
  }
  
  const reservedWords = ['admin', 'root', 'system', 'null', 'undefined', 'api', 'www'];
  if (reservedWords.includes(username.toLowerCase())) {
    errors.push('Username is reserved');
  }
  
  return {
    isValid: errors.length === 0,
    errors,
  };
}
