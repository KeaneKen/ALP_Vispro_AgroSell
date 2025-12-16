<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Pangan;

class PanganSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $products = [
            // === CABAI ===
            [
                'idPangan' => 'P001',
                'Nama_Pangan' => 'Cabai Maruti',
                'Deskripsi_Pangan' => 'Cabai varietas Maruti dengan tingkat kepedasan tinggi dan produktivitas unggul',
                'Harga_Pangan' => 35000,
                'idFoto_Pangan' => 'cabe 1.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P002',
                'Nama_Pangan' => 'Cabai Bhaskara',
                'Deskripsi_Pangan' => 'Cabai varietas Bhaskara dengan buah besar dan tahan penyakit',
                'Harga_Pangan' => 38000,
                'idFoto_Pangan' => 'cabe 2.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P003',
                'Nama_Pangan' => 'Cabai Kaliber',
                'Deskripsi_Pangan' => 'Cabai varietas Kaliber dengan hasil panen melimpah dan warna merah cerah',
                'Harga_Pangan' => 40000,
                'idFoto_Pangan' => 'cabe 3.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P004',
                'Nama_Pangan' => 'Cabai Salodua',
                'Deskripsi_Pangan' => 'Cabai varietas Salodua dengan daging tebal dan cocok untuk olahan',
                'Harga_Pangan' => 36000,
                'idFoto_Pangan' => 'cabe 1.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P005',
                'Nama_Pangan' => 'Cabai Master',
                'Deskripsi_Pangan' => 'Cabai varietas Master dengan kualitas premium dan rasa pedas khas',
                'Harga_Pangan' => 42000,
                'idFoto_Pangan' => 'cabe 2.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P006',
                'Nama_Pangan' => 'Cabai Kara',
                'Deskripsi_Pangan' => 'Cabai varietas Kara dengan ketahanan tinggi terhadap cuaca ekstrem',
                'Harga_Pangan' => 37000,
                'idFoto_Pangan' => 'cabe 3.jpg',
                'category' => 'Cabai',
            ],
            
            // === PADI ===
            [
                'idPangan' => 'P007',
                'Nama_Pangan' => 'Beras Ciliwung',
                'Deskripsi_Pangan' => 'Beras varietas Ciliwung dengan tekstur pulen dan aroma harum khas',
                'Harga_Pangan' => 12000,
                'idFoto_Pangan' => 'padi 1.jpg',
                'category' => 'Padi',
            ],
            [
                'idPangan' => 'P008',
                'Nama_Pangan' => 'Beras Ampari',
                'Deskripsi_Pangan' => 'Beras varietas Ampari dengan butir panjang dan rendah gula',
                'Harga_Pangan' => 13000,
                'idFoto_Pangan' => 'padi 2.jpg',
                'category' => 'Padi',
            ],
            [
                'idPangan' => 'P009',
                'Nama_Pangan' => 'Beras Kongko',
                'Deskripsi_Pangan' => 'Beras varietas Kongko dengan kualitas premium dan hasil panen tinggi',
                'Harga_Pangan' => 14000,
                'idFoto_Pangan' => 'padi 3.jpg',
                'category' => 'Padi',
            ],
        ];

        foreach ($products as $product) {
            // Use updateOrCreate so running the seeder multiple times is safe
            Pangan::updateOrCreate(
                ['idPangan' => $product['idPangan']],
                $product
            );
        }
    }
}
