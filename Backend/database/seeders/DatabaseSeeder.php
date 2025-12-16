<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            MitraSeeder::class,
            BumdesSeeder::class,
            PanganSeeder::class,
            PreOrderSeeder::class,
            OrderSeeder::class,
            NotificationSeeder::class,
            ActivitySeeder::class,
        ]);
    }
}

