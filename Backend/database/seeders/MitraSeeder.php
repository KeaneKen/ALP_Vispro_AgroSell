<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Mitra;
use Illuminate\Support\Facades\Hash;

class MitraSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Mitra::create([
            'idMitra' => 'M001',
            'Nama_Mitra' => 'Budi Tani Makmur',
            'Email_Mitra' => 'budi@tanimakmur.com',
            'Password_Mitra' => Hash::make('password123'),
            'NoTelp_Mitra' => '08123456789',
        ]);

        Mitra::create([
            'idMitra' => 'M002',
            'Nama_Mitra' => 'Siti Pertanian',
            'Email_Mitra' => 'siti@pertanian.com',
            'Password_Mitra' => Hash::make('password123'),
            'NoTelp_Mitra' => '08234567890',
        ]);

        Mitra::create([
            'idMitra' => 'M003',
            'Nama_Mitra' => 'Ahmad Petani Hebat',
            'Email_Mitra' => 'ahmad@petani.com',
            'Password_Mitra' => Hash::make('password123'),
            'NoTelp_Mitra' => '08345678901',
        ]);
    }
}
