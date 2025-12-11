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
        Schema::create('orders', function (Blueprint $table) {
            $table->string('idOrder')->primary();
            $table->string('idMitra');
            $table->string('idBumDES');
            $table->string('buyer_name');
            $table->string('buyer_phone');
            $table->text('delivery_address');
            $table->enum('payment_status', ['unpaid', 'paid', 'proses', 'antar'])->default('unpaid');
            $table->date('order_date');
            $table->text('notes')->nullable();
            $table->timestamps();
            
            $table->foreign('idMitra')->references('idMitra')->on('mitra')->onDelete('cascade');
            $table->foreign('idBumDES')->references('idBumDES')->on('bumdes')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
