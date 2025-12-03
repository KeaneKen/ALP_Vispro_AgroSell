<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bumdes extends Model
{
    protected $table = 'bumdes';
    protected $primaryKey = 'idBumDes';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idBumDes',
        'name',
        'email',
        'phone',
        'address',
        'created_at',
        'updated_at',
    ];

    // Relationships
    public function chats()
    {
        return $this->hasMany(Chat::class, 'idBumDes', 'idBumDES');
    }
}
