<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('pangan', function (Blueprint $table) {
            // Drop foreign key constraint first
            $table->dropForeign(['idMitra']);
            
            // Then drop the column
            $table->dropColumn('idMitra');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pangan', function (Blueprint $table) {
            // Re-add the column
            $table->string('idMitra')->after('idPangan');
            
            // Re-add the foreign key constraint
            $table->foreign('idMitra')->references('idMitra')->on('mitra')->onDelete('cascade');
        });
    }
};
