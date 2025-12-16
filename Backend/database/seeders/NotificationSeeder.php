<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Notification;

class NotificationSeeder extends Seeder
{
    public function run(): void
    {
        Notification::create([
            'user_id' => 'M001',
            'user_type' => 'mitra',
            'title' => 'Pesanan Berhasil',
            'message' => 'Pesanan Padi IR64 Anda telah dikonfirmasi oleh BUMDes',
            'type' => 'order',
            'is_read' => false,
            'action_data' => json_encode(['route' => 'cart'])
        ]);

        Notification::create([
            'user_id' => 'M001',
            'user_type' => 'mitra',
            'title' => 'Produk Best Seller!',
            'message' => 'Padi Varietas IR64 menjadi produk terlaris minggu ini',
            'type' => 'promo',
            'is_read' => false,
            'action_data' => json_encode(['route' => 'product_detail', 'product_id' => 'P001'])
        ]);

        Notification::create([
            'user_id' => 'B001',
            'user_type' => 'bumdes',
            'title' => 'Pesanan Baru',
            'message' => 'Anda memiliki pesanan baru dari Catering Tukang Las',
            'type' => 'order',
            'is_read' => false,
            'action_data' => json_encode(['route' => 'orders', 'order_id' => 'ORD-001'])
        ]);

        Notification::create([
            'user_id' => 'M001',
            'user_type' => 'mitra',
            'title' => 'Pembayaran Berhasil',
            'message' => 'Pembayaran pesanan sebesar Rp 250.000 telah diterima',
            'type' => 'payment',
            'is_read' => true,
            'action_data' => json_encode(['route' => 'cart'])
        ]);

        Notification::create([
            'user_id' => 'M001',
            'user_type' => 'mitra',
            'title' => 'Update Sistem',
            'message' => 'Aplikasi telah diperbarui dengan fitur chat dan notifikasi',
            'type' => 'system',
            'is_read' => true,
            'action_data' => null
        ]);
    }
}
