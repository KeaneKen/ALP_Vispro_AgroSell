<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    use HasFactory;

    protected $table = 'cart';
    protected $primaryKey = 'idCart';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idCart',
        'idPangan',
        'Jumlah_Pembelian',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'Jumlah_Pembelian' => 'integer',
    ];

    // Relationships
    public function pangan()
    {
        return $this->belongsTo(Pangan::class, 'idPangan', 'idPangan');
    }

    public function payment()
    {
        return $this->hasOne(Payment::class, 'idCart', 'idCart');
    }
}
