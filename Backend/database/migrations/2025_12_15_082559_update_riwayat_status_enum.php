<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $driver = DB::getDriverName();

        // SQLite doesn't support MODIFY/ENUM; fallback to VARCHAR change
        if ($driver === 'sqlite') {
            Schema::table('riwayat', function (Blueprint $table) {
                $table->string('status', 50)->default('processing')->change();
            });
        } else {
            // MySQL/MariaDB path: alter enum values
            DB::statement("ALTER TABLE riwayat MODIFY COLUMN status ENUM('processing', 'given_to_courier', 'on_the_way', 'arrived', 'completed', 'cancelled') DEFAULT 'processing'");
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        $driver = DB::getDriverName();

        if ($driver === 'sqlite') {
            Schema::table('riwayat', function (Blueprint $table) {
                $table->string('status', 50)->default('pending')->change();
            });
        } else {
            // Revert to old enum values for MySQL/MariaDB
            DB::statement("ALTER TABLE riwayat MODIFY COLUMN status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending'");
        }
    }
};
