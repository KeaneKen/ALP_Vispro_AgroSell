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
Route::post('mitra/login', [MitraController::class, 'login']);
Route::post('mitra/{idMitra}/upload-profile-picture', [MitraController::class, 'uploadProfilePicture']);

Route::apiResource('bumdes', BumdesController::class);
Route::post('bumdes/login', [BumdesController::class, 'login']);
Route::post('bumdes/{idBumdes}/upload-profile-picture', [BumdesController::class, 'uploadProfilePicture']);

Route::apiResource('pangan', PanganController::class);

Route::apiResource('cart', CartController::class);

Route::apiResource('payment', PaymentController::class);

Route::apiResource('riwayat', RiwayatController::class);

Route::get('chat/conversation', [ChatController::class, 'conversation']);

Route::post('chat/{chat}/mark-read', [ChatController::class, 'markAsRead']);

Route::apiResource('chat', ChatController::class)->only(['index','store','show','destroy']);