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
            'Nama_Mitra' => 'PT Tani Makmur - Budi Santoso',
            'Email_Mitra' => 'budi@tanimakmur.com',
            'Password_Mitra' => Hash::make('password123'),
            'NoTelp_Mitra' => '081234567890',
        ]);
    }
}
