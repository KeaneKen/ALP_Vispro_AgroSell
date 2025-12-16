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
        Schema::create('notifications', function (Blueprint $table) {
            $table->id('idNotification');
            $table->string('user_id');
            $table->enum('user_type', ['bumdes', 'mitra']);
            $table->string('title');
            $table->text('message');
            $table->enum('type', ['order', 'pre_order', 'payment', 'chat', 'promo', 'system']);
            $table->boolean('is_read')->default(false);
            $table->json('action_data')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
