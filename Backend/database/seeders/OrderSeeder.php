<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Order;
use App\Models\OrderItem;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        // Order 1: Paid
        $order1 = Order::create([
            'idOrder' => 'ORD-001',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'buyer_name' => 'Catering Tukang Las',
            'buyer_phone' => '081234567890',
            'delivery_address' => 'Jl. Industri No. 45, Kecamatan Sambikerep, Surabaya',
            'payment_status' => 'paid',
            'order_date' => now()->subDays(2),
            'notes' => 'Kirim pagi hari'
        ]);

        OrderItem::create([
            'idOrder' => 'ORD-001',
            'idPangan' => 'P001',
            'quantity' => 25,
            'price_per_unit' => 11500
        ]);

        OrderItem::create([
            'idOrder' => 'ORD-001',
            'idPangan' => 'P002',
            'quantity' => 15,
            'price_per_unit' => 6500
        ]);

        // Order 2: Process
        $order2 = Order::create([
            'idOrder' => 'ORD-002',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'buyer_name' => 'Resto Anak Muda',
            'buyer_phone' => '081234567891',
            'delivery_address' => 'Jl. Pemuda No. 12, Kecamatan Wonokromo, Surabaya',
            'payment_status' => 'proses',
            'order_date' => now()->subDays(1),
            'notes' => null
        ]);

        OrderItem::create([
            'idOrder' => 'ORD-002',
            'idPangan' => 'P004',
            'quantity' => 20,
            'price_per_unit' => 4000
        ]);

        // Order 3: Unpaid
        $order3 = Order::create([
            'idOrder' => 'ORD-003',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'buyer_name' => 'Keane',
            'buyer_phone' => '081234567892',
            'delivery_address' => 'Jl. Raya Darmo Permai III No. 8, Surabaya',
            'payment_status' => 'unpaid',
            'order_date' => now(),
            'notes' => 'COD'
        ]);

        OrderItem::create([
            'idOrder' => 'ORD-003',
            'idPangan' => 'P002',
            'quantity' => 10,
            'price_per_unit' => 6500
        ]);
    }
}
