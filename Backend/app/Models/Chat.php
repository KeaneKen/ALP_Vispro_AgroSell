<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Chat extends Model
{
    use HasFactory;

    protected $table = 'chat';
    protected $primaryKey = 'idChat';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idChat',
        'idMitra',
        'idBumDes',
        'message',
        'sender_type',
        'status',
        'sent_at',
        'read_at',
    ];

    protected $casts = [
        'sent_at' => 'datetime',
        'read_at' => 'datetime',
    ];

    
    // Relationships
    public function mitra()
    {
        return $this->belongsTo(Mitra::class, 'idMitra', 'idMitra');
    }

    public function bumdes()
    {
        return $this->belongsTo(Bumdes::class, 'idBumDes', 'idBumDES');
    }

    public function scopeBetweenParticipants($query, $idMitra, $idBumDes)
    {
        return $query->where('idMitra', $idMitra)
                     ->where('idBumDes', $idBumDes)
                     ->orderBy('sent_at', 'asc');
    }

    public function scopeUnread($query)
    {
        return $query->where('status', '!=', 'read');
    }
    public function scopeBySenderType($query, $senderType)
    {
        return $query->where('sender_type', $senderType);
    }

    public function markAsRead()
    {
        $this->update([
            'status' => 'read',
            'read_at' => now(),
        ]);
    }

    public function isFromMitra()
    {
        return $this->sender_type === 'mitra';
    }

    public function isFromBumDes()
    {
        return $this->sender_type === 'bumdes';
    }
}
