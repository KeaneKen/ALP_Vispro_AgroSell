<?php

namespace App\Events;

use App\Models\Chat;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class MessageSent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $message;
    public $mitraId;
    public $bumdesId;

    /**
     * Create a new event instance.
     */
    public function __construct(Chat $message)
    {
        $this->message = $message->load(['mitra', 'bumdes']);
        $this->mitraId = $message->idMitra;
        $this->bumdesId = $message->idBumDes;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        // Create a unique channel name for this chat conversation
        $channelName = 'chat.' . min($this->mitraId, $this->bumdesId) . '.' . max($this->mitraId, $this->bumdesId);
        
        return [
            new PrivateChannel($channelName),
        ];
    }

    /**
     * The event's broadcast name.
     */
    public function broadcastAs(): string
    {
        return 'message.sent';
    }

    /**
     * Get the data to broadcast.
     *
     * @return array<string, mixed>
     */
    public function broadcastWith(): array
    {
        return [
            'message' => [
                'idChat' => $this->message->idChat,
                'idMitra' => $this->message->idMitra,
                'idBumDes' => $this->message->idBumDes,
                'message' => $this->message->message,
                'sender_type' => $this->message->sender_type,
                'status' => $this->message->status,
                'sent_at' => $this->message->sent_at->toISOString(),
                'read_at' => $this->message->read_at?->toISOString(),
                'mitra' => $this->message->mitra,
                'bumdes' => $this->message->bumdes,
            ]
        ];
    }
}
