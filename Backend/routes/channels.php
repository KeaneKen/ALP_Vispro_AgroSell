<?php

use Illuminate\Support\Facades\Broadcast;
use App\Models\Mitra;
use App\Models\Bumdes;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

// Chat channel authorization
Broadcast::channel('chat.{participant1}.{participant2}', function ($user, $participant1, $participant2) {
    // For now, allow all authenticated users to join chat channels
    // In production, you should verify that the user is either the mitra or bumdes involved
    return true;
});
