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
        Schema::table('mitra', function (Blueprint $table) {
            $table->string('profile_picture')->nullable()->after('NoTelp_Mitra');
        });

        Schema::table('bumdes', function (Blueprint $table) {
            $table->string('profile_picture')->nullable()->after('NoTelp_BumDES');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('mitra', function (Blueprint $table) {
            $table->dropColumn('profile_picture');
        });

        Schema::table('bumdes', function (Blueprint $table) {
            $table->dropColumn('profile_picture');
        });
    }
};
