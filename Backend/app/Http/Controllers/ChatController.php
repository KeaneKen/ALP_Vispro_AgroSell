<?php

namespace App\Http\Controllers;

use App\Models\Bumdes;
use App\Models\Chat;
use App\Models\Mitra;
use App\Events\MessageSent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class ChatController extends Controller
{
    public function index()
    {
        $messages = Chat::with(['mitra', 'bumdes'])->orderBy('sent_at')->get();

        return response()->json([
            'success' => true,
            'data' => $messages,
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idChat' => 'nullable|string|unique:chat,idChat',
            'idMitra' => 'required|string|exists:mitra,idMitra',
            'idBumDes' => 'required|string|exists:bumdes,idBumDES',
            'message' => 'required|string',
            'sender_type' => 'required|in:mitra,bumdes',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();
        $data['idChat'] = $data['idChat'] ?? 'CHAT-' . Str::upper(Str::random(8));
        $data['status'] = 'sent';
        $data['sent_at'] = now();

        $chat = Chat::create($data);

        // Broadcast the message event for real-time updates
        broadcast(new MessageSent($chat))->toOthers();

        return response()->json([
            'success' => true,
            'message' => 'Message sent successfully',
            'data' => $chat->load(['mitra', 'bumdes']),
        ], 201);
    }

    public function conversation(Request $request)
    {
        $mitraId = $request->query('idMitra');
        $bumdesId = $request->query('idBumDes');

        if (!$mitraId || !$bumdesId) {
            return response()->json([
                'success' => false,
                'message' => 'idMitra and idBumDes are required',
            ], 400);
        }

        if (! Mitra::whereKey($mitraId)->exists() || ! Bumdes::whereKey($bumdesId)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Participants not found',
            ], 404);
        }

        $messages = Chat::with(['mitra', 'bumdes'])
            ->betweenParticipants($mitraId, $bumdesId)
            ->get();

        return response()->json([
            'success' => true,
            'data' => $messages,
        ], 200);
    }

    public function markAsRead(string $id)
    {
        $message = Chat::find($id);

        if (! $message) {
            return response()->json([
                'success' => false,
                'message' => 'Message not found',
            ], 404);
        }

        $message->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Message marked as read',
            'data' => $message->fresh(),
        ], 200);
    }

    public function unread()
    {
        $messages = Chat::unread()->with(['mitra', 'bumdes'])->get();

        return response()->json([
            'success' => true,
            'data' => $messages,
        ], 200);
    }
}
