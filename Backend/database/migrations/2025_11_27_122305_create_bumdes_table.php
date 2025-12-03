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
        Schema::create('bumdes', function (Blueprint $table) {
            $table->string('idBumDES')->primary();
            $table->string('Nama_BumDES');
            $table->string('Email_BumDES')->unique();
            $table->string('Password_BumDES');
            $table->string('NoTelp_BumDES');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bumdes');
    }
};
