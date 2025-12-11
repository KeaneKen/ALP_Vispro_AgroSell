<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Activity extends Model
{
    protected $primaryKey = 'idActivity';

    protected $fillable = [
        'idBumDES', 'type', 'title', 'value'
    ];

    public function bumdes()
    {
        return $this->belongsTo(Bumdes::class, 'idBumDES', 'idBumDES');
    }
}
