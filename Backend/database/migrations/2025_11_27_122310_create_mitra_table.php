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
        Schema::create('mitra', function (Blueprint $table) {
            $table->string('idMitra')->primary();
            $table->string('idPerusahaan');
            $table->string('Nama_Mitra');
            $table->string('Email_Mitra')->unique();
            $table->string('Password_Mitra');
            $table->string('NoTelp_Mitra');
            $table->timestamps();
            
            $table->foreign('idPerusahaan')->references('idPerusahaan')->on('perusahaan')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mitra');
    }
};
