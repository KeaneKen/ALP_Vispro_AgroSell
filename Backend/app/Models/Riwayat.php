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
        'created_at',
        'updated_at',
    ];

    // Relationships
    public function payment()
    {
        return $this->belongsTo(Payment::class, 'idPayment', 'idPayment');
    }
}
