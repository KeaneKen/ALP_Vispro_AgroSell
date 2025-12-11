<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $table = 'orders';
    protected $primaryKey = 'idOrder';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idOrder', 'idMitra', 'idBumDES', 'buyer_name', 
        'buyer_phone', 'delivery_address', 'payment_status', 
        'order_date', 'notes'
    ];

    protected $casts = [
        'order_date' => 'date',
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
        return $this->hasMany(OrderItem::class, 'idOrder', 'idOrder');
    }
}
