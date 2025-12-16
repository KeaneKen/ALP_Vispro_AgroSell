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
        Schema::create('activities', function (Blueprint $table) {
            $table->id('idActivity');
            $table->string('idBumDES');
            $table->enum('type', ['penjualan', 'pembelian', 'panen']);
            $table->string('title');
            $table->string('value');
            $table->timestamps();
            
            $table->foreign('idBumDES')->references('idBumDES')->on('bumdes')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('activities');
    }
};
