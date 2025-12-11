<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Bumdes;
use Illuminate\Support\Facades\Hash;

class BumdesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Bumdes::create([
            'idBumDES' => 'B001',
            'Nama_BumDES' => 'BumDes Sejahtera Desa',
            'Email_BumDES' => 'admin@bumdessejahtera.com',
            'Password_BumDES' => Hash::make('password123'),
            'NoTelp_BumDES' => '081234567891',
        ]);
    }
}
