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
        Schema::create('pre_order_items', function (Blueprint $table) {
            $table->id();
            $table->string('idPreOrder');
            $table->string('idPangan');
            $table->integer('quantity');
            $table->decimal('price', 15, 2);
            $table->text('plant_status')->nullable();
            $table->timestamps();
            
            $table->foreign('idPreOrder')->references('idPreOrder')->on('pre_orders')->onDelete('cascade');
            $table->foreign('idPangan')->references('idPangan')->on('pangan')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pre_order_items');
    }
};
