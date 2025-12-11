<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PreOrder extends Model
{
    protected $table = 'pre_orders';
    protected $primaryKey = 'idPreOrder';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idPreOrder', 'idMitra', 'idBumDES', 'order_date', 
        'harvest_date', 'delivery_date', 'status', 
        'payment_status', 'total_amount', 'dp_amount', 'notes'
    ];

    protected $casts = [
        'order_date' => 'date',
        'harvest_date' => 'date',
        'delivery_date' => 'date',
        'total_amount' => 'decimal:2',
        'dp_amount' => 'decimal:2',
    ];

    public function mitra()
    {
        return $this->belongsTo(Mitra::class, 'idMitra', 'idMitra');
    }

    public function bumdes()
    {
        return $this->belongsTo(Bumdes::class, 'idBumDES', 'idBumDES');
    }

    public function items()
    {
        return $this->hasMany(PreOrderItem::class, 'idPreOrder', 'idPreOrder');
    }
}
