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
        Schema::table('riwayat', function (Blueprint $table) {
            $table->enum('status', ['pending', 'processing', 'shipped', 'delivered', 'cancelled'])
                  ->default('pending')
                  ->after('idPayment');
            $table->string('delivery_address')->nullable()->after('status');
            $table->string('phone_number')->nullable()->after('delivery_address');
            $table->text('notes')->nullable()->after('phone_number');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('riwayat', function (Blueprint $table) {
            $table->dropColumn(['status', 'delivery_address', 'phone_number', 'notes']);
        });
    }
};
