<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Expands the category to support all frontend categories
     */
    public function up(): void
    {
        // Simply run raw SQL to modify the enum - this works without doctrine/dbal
        DB::statement("ALTER TABLE pangan MODIFY COLUMN category VARCHAR(50) DEFAULT 'Lainnya'");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::statement("ALTER TABLE pangan MODIFY COLUMN category VARCHAR(50) DEFAULT 'Lainnya'");
    }
};
