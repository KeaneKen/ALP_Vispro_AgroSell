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
        Schema::create('chat', function (Blueprint $table) {
            $table->string('idChat')->primary();
            $table->string('idMitra');
            $table->string('idBumDes');
            $table->text('message');
            $table->enum('sender_type', ['mitra', 'bumdes']);
            $table->enum('status', ['sent', 'delivered', 'read'])->default('sent');
            $table->timestamp('sent_at')->useCurrent();
            $table->timestamp('read_at')->nullable();
            $table->timestamps();

            $table->foreign('idMitra')->references('idMitra')->on('mitra')->onDelete('cascade');
            $table->foreign('idBumDes')->references('idBumDES')->on('bumdes')->onDelete('cascade');
        
            $table->index(['idMitra', 'idBumDes']); 
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('chat');
    }
};
