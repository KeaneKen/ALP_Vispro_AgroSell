<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PreOrderItem extends Model
{
    protected $fillable = [
        'idPreOrder', 'idPangan', 'quantity', 'price', 'plant_status'
    ];

    protected $casts = [
        'price' => 'decimal:2',
    ];

    public function preOrder()
    {
        return $this->belongsTo(PreOrder::class, 'idPreOrder', 'idPreOrder');
    }

    public function pangan()
    {
        return $this->belongsTo(Pangan::class, 'idPangan', 'idPangan');
    }
}
