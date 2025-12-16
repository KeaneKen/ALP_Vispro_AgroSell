<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    protected $primaryKey = 'idNotification';

    protected $fillable = [
        'user_id', 'user_type', 'title', 'message', 
        'type', 'is_read', 'action_data'
    ];

    protected $casts = [
        'is_read' => 'boolean',
        'action_data' => 'array',
    ];
}
