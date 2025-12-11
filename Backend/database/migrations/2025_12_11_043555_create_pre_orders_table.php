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
        Schema::create('pre_orders', function (Blueprint $table) {
            $table->string('idPreOrder')->primary();
            $table->string('idMitra');
            $table->string('idBumDES');
            $table->date('order_date');
            $table->date('harvest_date')->nullable();
            $table->date('delivery_date')->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected', 'completed'])->default('pending');
            $table->enum('payment_status', ['unpaid', 'dp', 'paid'])->default('unpaid');
            $table->decimal('total_amount', 15, 2);
            $table->decimal('dp_amount', 15, 2)->nullable();
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
        Schema::dropIfExists('pre_orders');
    }
};
