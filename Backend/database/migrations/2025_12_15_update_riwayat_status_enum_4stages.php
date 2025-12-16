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

        if ($driver === 'sqlite') {
            Schema::table('riwayat', function (Blueprint $table) {
                $table->string('status', 50)->default('processing')->change();
            });
        } else {
            // Convert to VARCHAR to support the new enum values (MySQL/MariaDB)
            DB::statement("ALTER TABLE riwayat MODIFY COLUMN status VARCHAR(50) DEFAULT 'processing'");
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
                $table->string('status', 50)->default('processing')->change();
            });
        } else {
            DB::statement("ALTER TABLE riwayat MODIFY COLUMN status VARCHAR(50) DEFAULT 'processing'");
        }
    }
};
