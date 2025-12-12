<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bumdes extends Model
{
    protected $table = 'bumdes';
    protected $primaryKey = 'idBumDES';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idBumDES',
        'Nama_BumDES',
        'Email_BumDES',
        'Password_BumDES',
        'NoTelp_BumDES',
    ];

    // Accessors to provide consistent API
    public function getNameAttribute()
    {
        return $this->Nama_BumDES;
    }

    public function getEmailAttribute()
    {
        return $this->Email_BumDES;
    }

    public function getPhoneAttribute()
    {
        return $this->NoTelp_BumDES;
    }

    public function getPasswordAttribute()
    {
        return $this->Password_BumDES;
    }

    // Mutators for setting values
    public function setNameAttribute($value)
    {
        $this->attributes['Nama_BumDES'] = $value;
    }

    public function setEmailAttribute($value)
    {
        $this->attributes['Email_BumDES'] = $value;
    }

    public function setPhoneAttribute($value)
    {
        $this->attributes['NoTelp_BumDES'] = $value;
    }

    public function setPasswordAttribute($value)
    {
        $this->attributes['Password_BumDES'] = $value;
    }

    // Relationships
    public function chats()
    {
        return $this->hasMany(Chat::class, 'idBumDes', 'idBumDES');
    }
}
