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
        Schema::create('order_items', function (Blueprint $table) {
            $table->id();
            $table->string('idOrder');
            $table->string('idPangan');
            $table->integer('quantity');
            $table->decimal('price_per_unit', 15, 2);
            $table->timestamps();
            
            $table->foreign('idOrder')->references('idOrder')->on('orders')->onDelete('cascade');
            $table->foreign('idPangan')->references('idPangan')->on('pangan')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_items');
    }
};
