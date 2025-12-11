<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    protected $fillable = [
        'idOrder', 'idPangan', 'quantity', 'price_per_unit'
    ];

    protected $casts = [
        'price_per_unit' => 'decimal:2',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class, 'idOrder', 'idOrder');
    }

    public function pangan()
    {
        return $this->belongsTo(Pangan::class, 'idPangan', 'idPangan');
    }
}
