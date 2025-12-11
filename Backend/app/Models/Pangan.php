<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pangan extends Model
{
    use HasFactory;

    protected $table = 'pangan';
    protected $primaryKey = 'idPangan';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idPangan',
        'Nama_Pangan',
        'Deskripsi_Pangan',
        'Harga_Pangan',
        'idFoto_Pangan',
        'category',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'Harga_Pangan' => 'decimal:2',
    ];

    // Relationships
    public function carts()
    {
        return $this->hasMany(Cart::class, 'idPangan', 'idPangan');
    }
}
