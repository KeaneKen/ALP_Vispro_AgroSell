<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\Pangan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CartController extends Controller
{
    public function index()
    {
        $carts = Cart::with('pangan')->get()->map(function($cart) {
            return [
            'idCart' => $cart->idCart,
            'Jumlah_Pembelian' => $cart->Jumlah_Pembelian,
            'pangan' => [
                'Nama_Pangan' => $cart->pangan->Nama_Pangan,
                'Harga_Pangan' => $cart->pangan->Harga_Pangan,
            ],
            'created_at' => $cart->created_at,
            'updated_at' => $cart->updated_at,
            ];
        });
        
        return response()->json([
            'success' => true,
            'message' => 'Cart items retrieved successfully',
            'data' => $carts,
        ], 200);
    }
    
    private function generateCartId()
    {
        $lastCart = Cart::orderBy('idCart', 'desc')->first();
        
        if (!$lastCart) {
            return 'C001';
        }
        
        // Extract the numeric part from the last ID
        $lastNumber = intval(substr($lastCart->idCart, 1));
        $newNumber = $lastNumber + 1;
        
        // Format with leading zeros (3 digits)
        return 'C' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idPangan' => 'required|string|exists:pangan,idPangan',
            'Jumlah_Pembelian' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Debug: Check if data exists
            if (!$request->has('idPangan') || !$request->idPangan) {
                return response()->json([
                    'success' => false,
                    'message' => 'idPangan is required and cannot be empty'
                ], 400);
            }

            $cart = Cart::create([
                'idCart' => $this->generateCartId(),
                'idPangan' => $request->idPangan,
                'Jumlah_Pembelian' => $request->Jumlah_Pembelian,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Cart item created successfully',
                'data' => $cart->load('pangan'),
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create cart item',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show(string $id)
    {
        $cart = Cart::with(['pangan:Nama_Pangan,Harga_Pangan', 'payment'])->find($id);

        if (! $cart) {
            return response()->json([
            'success' => false,
            'message' => 'Cart item not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $cart,
        ], 200);
    }


    public function update(Request $request, string $id)
    {
        $cart = Cart::find($id);

        if (! $cart) {
            return response()->json([
                'success' => false,
                'message' => 'Cart item not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'idPangan' => 'sometimes|required|string|exists:pangan,idPangan',
            'Jumlah_Pembelian' => 'sometimes|required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $cart->update($validator->validated());

        return response()->json([
            'success' => true,
            'message' => 'Cart item updated successfully',
            'data' => $cart->fresh()->load(['pangan', 'payment']),
        ], 200);
    }

    public function destroy(string $id)
    {
        $cart = Cart::find($id);

        if (! $cart) {
            return response()->json([
                'success' => false,
                'message' => 'Cart item not found',
            ], 404);
        }

        $cart->delete();

        return response()->json([
            'success' => true,
            'message' => 'Cart item deleted successfully',
        ], 200);
    }

    public function getByPangan(string $panganId)
    {
        if (! Pangan::whereKey($panganId)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Pangan not found',
            ], 404);
        }

        $items = Cart::with(['pangan', 'payment'])
            ->where('idPangan', $panganId)
            ->orderByDesc('created_at')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $items,
        ], 200);
    }
}
