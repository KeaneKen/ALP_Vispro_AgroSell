<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class Mitra extends Model
{
    use HasApiTokens;

    protected $table = 'mitra';
    protected $primaryKey = 'idMitra';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idMitra',
        'Nama_Mitra',
        'Email_Mitra',
        'Password_Mitra',
        'NoTelp_Mitra',
        'created_at',
        'updated_at',
    ];

    // Relationships
    public function chats()
    {
        return $this->hasMany(Chat::class, 'idMitra', 'idMitra');
    }
}
