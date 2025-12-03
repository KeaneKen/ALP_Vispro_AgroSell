<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('mitra', function (Blueprint $table) {
            if (Schema::hasColumn('mitra', 'idPerusahaan')) {
                // Drop legacy foreign key if it still exists
                try {
                    $table->dropForeign('mitra_idperusahaan_foreign');
                } catch (\Throwable $e) {
                    // ignore if FK already gone
                }

                $table->dropColumn('idPerusahaan');
            }
        });
    }

    public function down(): void
    {
        Schema::table('mitra', function (Blueprint $table) {
            if (! Schema::hasColumn('mitra', 'idPerusahaan')) {
                $table->string('idPerusahaan')->nullable();

                try {
                    $table->foreign('idPerusahaan')->references('idPerusahaan')->on('perusahaan')->nullOnDelete();
                } catch (\Throwable $e) {
                    // perusahaan table might not exist anymore
                }
            }
        });
    }
};
