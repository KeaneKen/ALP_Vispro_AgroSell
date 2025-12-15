<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Expands the category to support all frontend categories (MySQL only)
     */
    public function up(): void
    {
        // Only run for MySQL - skip for SQLite
        if (DB::getDriverName() === 'mysql') {
            DB::statement("ALTER TABLE pangan MODIFY COLUMN category VARCHAR(50) DEFAULT 'Lainnya'");
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Only run for MySQL - skip for SQLite
        if (DB::getDriverName() === 'mysql') {
            DB::statement("ALTER TABLE pangan MODIFY COLUMN category VARCHAR(50) DEFAULT 'Lainnya'");
        }
    }
};
