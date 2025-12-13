<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Expands the category enum to support all frontend categories
     */
    public function up(): void
    {
        // For MySQL, we need to modify the enum column
        // First, change to string to allow any value temporarily
        Schema::table('pangan', function (Blueprint $table) {
            $table->string('category', 50)->default('Lainnya')->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pangan', function (Blueprint $table) {
            $table->string('category', 50)->default('Lainnya')->change();
        });
    }
};
