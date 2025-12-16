<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Get notifications for a user
     */
    public function index(Request $request)
    {
        try {
            $query = Notification::query();

            // Filter by user
            if ($request->has('user_id') && $request->has('user_type')) {
                $query->where('user_id', $request->user_id)
                      ->where('user_type', $request->user_type);
            }

            // Filter by read status
            if ($request->has('is_read')) {
                $query->where('is_read', $request->boolean('is_read'));
            }

            $notifications = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $notifications->map(function ($notif) {
                    return [
                        'id' => $notif->idNotification,
                        'title' => $notif->title,
                        'message' => $notif->message,
                        'type' => $notif->type,
                        'isRead' => $notif->is_read,
                        'actionData' => $notif->action_data,
                        'createdAt' => $notif->created_at->toISOString(),
                    ];
                }),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch notifications',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Mark notification as read
     */
    public function markRead($id)
    {
        try {
            $notification = Notification::findOrFail($id);
            $notification->update(['is_read' => true]);

            return response()->json([
                'success' => true,
                'message' => 'Notification marked as read',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to mark notification as read',
                'error' => $e->getMessage(),
            ], 404);
        }
    }
}
