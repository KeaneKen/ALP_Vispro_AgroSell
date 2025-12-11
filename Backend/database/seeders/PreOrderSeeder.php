<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PreOrder;
use App\Models\PreOrderItem;

class PreOrderSeeder extends Seeder
{
    public function run(): void
    {
        // PO-001: Multiple products
        $po1 = PreOrder::create([
            'idPreOrder' => 'PO-001',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'order_date' => now(),
            'harvest_date' => now()->addDays(45),
            'delivery_date' => now()->addDays(47),
            'status' => 'approved',
            'payment_status' => 'paid',
            'total_amount' => 400000,
            'dp_amount' => 400000,
            'notes' => 'Pesanan untuk Catering Tukang Las'
        ]);

        PreOrderItem::create([
            'idPreOrder' => 'PO-001',
            'idPangan' => 'P002',
            'quantity' => 14,
            'price' => 6500,
            'plant_status' => '80% tanaman sudah mulai menguning dan mendekati masa panen.'
        ]);

        PreOrderItem::create([
            'idPreOrder' => 'PO-001',
            'idPangan' => 'P001',
            'quantity' => 20,
            'price' => 11500,
            'plant_status' => 'Panen diperkirakan siap dalam beberapa hari lagi.'
        ]);

        // PO-002: Single product
        $po2 = PreOrder::create([
            'idPreOrder' => 'PO-002',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'order_date' => now()->subDays(5),
            'harvest_date' => now()->addDays(20),
            'delivery_date' => now()->addDays(22),
            'status' => 'approved',
            'payment_status' => 'dp',
            'total_amount' => 240000,
            'dp_amount' => 120000,
            'notes' => 'Pesanan Resto Anak Muda'
        ]);

        PreOrderItem::create([
            'idPreOrder' => 'PO-002',
            'idPangan' => 'P003',
            'quantity' => 30,
            'price' => 8000,
            'plant_status' => 'Tanaman sedang dalam masa pertumbuhan optimal.'
        ]);

        // PO-003: Pending
        $po3 = PreOrder::create([
            'idPreOrder' => 'PO-003',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'order_date' => now()->subDays(2),
            'harvest_date' => now()->addMonths(3),
            'delivery_date' => now()->addMonths(3)->addDays(2),
            'status' => 'pending',
            'payment_status' => 'unpaid',
            'total_amount' => 450000,
            'dp_amount' => null,
            'notes' => 'Menunggu pembayaran DP'
        ]);

        PreOrderItem::create([
            'idPreOrder' => 'PO-003',
            'idPangan' => 'P003',
            'quantity' => 50,
            'price' => 9000,
            'plant_status' => 'Persiapan lahan sedang dilakukan.'
        ]);
    }
}
