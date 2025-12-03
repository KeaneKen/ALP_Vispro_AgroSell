<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;

    protected $table = 'payment';
    protected $primaryKey = 'idPayment';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idPayment',
        'idCart',
        'Total_Harga',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'Total_Harga' => 'decimal:2',
    ];

    // Relationships
    public function cart()
    {
        return $this->belongsTo(Cart::class, 'idCart', 'idCart');
    }

    public function riwayat()
    {
        return $this->hasOne(Riwayat::class, 'idPayment', 'idPayment');
    }
}
