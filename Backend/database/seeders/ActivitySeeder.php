<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Activity;

class ActivitySeeder extends Seeder
{
    public function run(): void
    {
        Activity::create([
            'idBumDES' => 'B001',
            'type' => 'penjualan',
            'title' => 'Penjualan Padi ke Catering',
            'value' => 'Rp 6.000.000',
            'created_at' => now()->subHours(2)
        ]);

        Activity::create([
            'idBumDES' => 'B001',
            'type' => 'pembelian',
            'title' => 'Pembelian Pupuk Organik',
            'value' => 'Rp 3.500.000',
            'created_at' => now()->subHours(5)
        ]);

        Activity::create([
            'idBumDES' => 'B001',
            'type' => 'panen',
            'title' => 'Panen Jagung Super',
            'value' => '500 kg',
            'created_at' => now()->subDay()
        ]);

        Activity::create([
            'idBumDES' => 'B001',
            'type' => 'penjualan',
            'title' => 'Penjualan Cabai ke Pasar',
            'value' => 'Rp 4.200.000',
            'created_at' => now()->subDays(2)
        ]);
    }
}
