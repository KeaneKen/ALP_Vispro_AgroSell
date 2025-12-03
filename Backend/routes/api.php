<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BumdesController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\MitraController;
use App\Http\Controllers\PanganController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\RiwayatController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('mitra', MitraController::class);

Route::apiResource('bumdes', BumdesController::class);

Route::apiResource('pangan', PanganController::class);

Route::apiResource('cart', CartController::class);

Route::apiResource('payment', PaymentController::class);

Route::apiResource('riwayat', RiwayatController::class);

Route::get('chat/conversation', [ChatController::class, 'betweenParticipants']);

Route::post('chat/{chat}/mark-read', [ChatController::class, 'markAsRead']);

Route::apiResource('chat', ChatController::class)->only(['index','store','show','destroy']);