<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Riwayat extends Model
{
    use HasFactory;

    protected $table = 'riwayat';
    protected $primaryKey = 'idHistory';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idHistory',
        'idPayment',
        'status',
        'delivery_address',
        'phone_number',
        'notes',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Status constants for the 4-stage order tracking
    const STATUS_PROCESSING = 'processing';           // Sedang diproses
    const STATUS_GIVEN_TO_COURIER = 'given_to_courier'; // Diberikan ke kurir
    const STATUS_ON_THE_WAY = 'on_the_way';          // Dalam perjalanan
    const STATUS_ARRIVED = 'arrived';                // Sampai tujuan
    const STATUS_COMPLETED = 'completed';            // Pesanan Selesai (Mitra confirmed)
    
    public static function getStatuses()
    {
        return [
            self::STATUS_PROCESSING,
            self::STATUS_GIVEN_TO_COURIER,
            self::STATUS_ON_THE_WAY,
            self::STATUS_ARRIVED,
            self::STATUS_COMPLETED,
        ];
    }

    // Relationships
    public function payment()
    {
        return $this->belongsTo(Payment::class, 'idPayment', 'idPayment');
    }
}
