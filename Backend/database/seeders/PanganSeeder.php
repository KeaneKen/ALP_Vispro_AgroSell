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
            [
                'idPangan' => 'P001',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Beras Premium',
                'Deskripsi_Pangan' => 'Beras berkualitas tinggi dengan tekstur pulen',
                'Harga_Pangan' => 12000,
                'idFoto_Pangan' => 'beras.jpg',
                'category' => 'Padi',
            ],
            [
                'idPangan' => 'P002',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Jagung Manis',
                'Deskripsi_Pangan' => 'Jagung segar dan manis langsung dari petani',
                'Harga_Pangan' => 8000,
                'idFoto_Pangan' => 'jagung.jpg',
                'category' => 'Jagung',
            ],
            [
                'idPangan' => 'P003',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Kedelai Organik',
                'Deskripsi_Pangan' => 'Kedelai organik berkualitas untuk tempe dan tahu',
                'Harga_Pangan' => 15000,
                'idFoto_Pangan' => 'kedelai.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P004',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Singkong Segar',
                'Deskripsi_Pangan' => 'Singkong segar pilihan dari kebun lokal',
                'Harga_Pangan' => 5000,
                'idFoto_Pangan' => 'singkong.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P005',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Ubi Ungu',
                'Deskripsi_Pangan' => 'Ubi ungu manis kaya nutrisi',
                'Harga_Pangan' => 7000,
                'idFoto_Pangan' => 'ubi.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P006',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Kentang',
                'Deskripsi_Pangan' => 'Kentang segar untuk berbagai olahan',
                'Harga_Pangan' => 9000,
                'idFoto_Pangan' => 'kentang.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P007',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Kacang Hijau',
                'Deskripsi_Pangan' => 'Kacang hijau berkualitas untuk bubur dan kolak',
                'Harga_Pangan' => 11000,
                'idFoto_Pangan' => 'kacang_hijau.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P008',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Gandum',
                'Deskripsi_Pangan' => 'Gandum pilihan untuk tepung berkualitas',
                'Harga_Pangan' => 13000,
                'idFoto_Pangan' => 'gandum.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P009',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Sagu',
                'Deskripsi_Pangan' => 'Sagu murni dari pohon sagu asli',
                'Harga_Pangan' => 10000,
                'idFoto_Pangan' => 'sagu.jpg',
                'category' => 'Lainnya',
            ],
            [
                'idPangan' => 'P010',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Gabah Kering',
                'Deskripsi_Pangan' => 'Gabah padi kering siap digiling',
                'Harga_Pangan' => 6500,
                'idFoto_Pangan' => 'gabah.jpg',
                'category' => 'Padi',
            ],
            [
                'idPangan' => 'P011',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Jagung Pipilan',
                'Deskripsi_Pangan' => 'Jagung pipilan kering berkualitas',
                'Harga_Pangan' => 7500,
                'idFoto_Pangan' => 'jagung_pipil.jpg',
                'category' => 'Jagung',
            ],
            [
                'idPangan' => 'P012',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Cabai Merah Besar',
                'Deskripsi_Pangan' => 'Cabai merah besar segar dan pedas',
                'Harga_Pangan' => 35000,
                'idFoto_Pangan' => 'cabai_merah.jpg',
                'category' => 'Cabai',
            ],
            [
                'idPangan' => 'P013',
                'idMitra' => 'M001',
                'Nama_Pangan' => 'Cabai Rawit Hijau',
                'Deskripsi_Pangan' => 'Cabai rawit hijau super pedas',
                'Harga_Pangan' => 45000,
                'idFoto_Pangan' => 'cabai_rawit.jpg',
                'category' => 'Cabai',
            ],
        ];

        foreach ($products as $product) {
            Pangan::create($product);
        }
    }
}
