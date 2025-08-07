import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_entity.dart';
import '../providers/notes_providers.dart';

class NoteCard extends ConsumerWidget {
  final NoteEntity note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showNoteDetails(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.displayTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: note.isArchived 
                            ? theme.colorScheme.onSurfaceVariant 
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Priority indicator
                  if (note.priority.index > 1) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(note.priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        note.priority.displayName.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getPriorityColor(note.priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      note.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: note.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(ref),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              
              // Content preview
              if (note.hasContent) ...[
                const SizedBox(height: 8),
                Text(
                  note.excerpt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: note.isArchived 
                        ? theme.colorScheme.onSurfaceVariant 
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Footer with metadata
              Row(
                children: [
                  // Time info
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getTimeText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  
                  // Tags indicator
                  if (note.hasTags) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.local_offer,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${note.tagIds.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  
                  // Reminder indicator
                  if (note.hasReminder) ...[
                    const SizedBox(width: 12),
                    Icon(
                      note.isOverdue ? Icons.alarm_off : Icons.alarm,
                      size: 14,
                      color: note.isOverdue ? Colors.red : Colors.blue,
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Archive status
                  if (note.isArchived)
                    const Icon(
                      Icons.archive,
                      size: 16,
                      color: Colors.grey,
                    ),
                  
                  // More actions
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleAction(context, ref, action),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: ListTile(
                          leading: Icon(note.isArchived ? Icons.unarchive : Icons.archive),
                          title: Text(note.isArchived ? 'Unarchive' : 'Archive'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(priority) {
    switch (priority.index) {
      case 0: return Colors.green;  // low
      case 1: return Colors.blue;   // normal
      case 2: return Colors.orange; // high
      case 3: return Colors.red;    // urgent
      default: return Colors.blue;
    }
  }

  String _getTimeText() {
    final now = DateTime.now();
    final difference = now.difference(note.updatedAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _toggleFavorite(WidgetRef ref) {
    ref.read(notesActionsProvider).toggleFavorite(note);
  }

  void _showNoteDetails(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.displayTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (note.hasContent) ...[
                Text(
                  'Content:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(note.content),
                const SizedBox(height: 12),
              ],
              
              Text(
                'Details:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Priority: ${note.priority.displayName}'),
              Text('Created: ${_formatDateTime(note.createdAt)}'),
              Text('Updated: ${_formatDateTime(note.updatedAt)}'),
              Text('Words: ${note.wordCount}'),
              Text('Characters: ${note.characterCount}'),
              
              if (note.hasTags) ...[
                const SizedBox(height: 8),
                Text('Tags: ${note.tagIds.length} tags'),
              ],
              
              if (note.hasReminder) ...[
                const SizedBox(height: 8),
                Text(
                  'Reminder: ${_formatDateTime(note.remindAt!)}',
                  style: TextStyle(
                    color: note.isOverdue ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    final actions = ref.read(notesActionsProvider);
    
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality not implemented in demo')),
        );
        break;
      case 'archive':
        actions.toggleArchived(note);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.displayTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(notesActionsProvider).deleteNote(note.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}