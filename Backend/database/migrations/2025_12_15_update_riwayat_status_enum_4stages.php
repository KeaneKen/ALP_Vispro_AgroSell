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
        // Convert to VARCHAR to support the new enum values
        // MySQL doesn't support ALTER ENUM easily, so we use VARCHAR
        DB::statement("ALTER TABLE riwayat MODIFY COLUMN status VARCHAR(50) DEFAULT 'processing'");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::statement("ALTER TABLE riwayat MODIFY COLUMN status VARCHAR(50) DEFAULT 'processing'");
    }
};
