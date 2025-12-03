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
        Schema::create('pangan', function (Blueprint $table) {
            $table->string('idPangan')->primary();
            $table->string('idMitra');
            $table->string('Nama_Pangan');
            $table->text('Deskripsi_Pangan');
            $table->decimal('Harga_Pangan', 10, 2);
            $table->string('idFoto_Pangan')->nullable();
            $table->timestamps();
            
            $table->foreign('idMitra')->references('idMitra')->on('mitra')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pangan');
    }
};
