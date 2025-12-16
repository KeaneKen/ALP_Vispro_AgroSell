<?php

namespace App\Http\Controllers;

use App\Models\Riwayat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RiwayatController extends Controller
{
    public function index()
    {
        $records = Riwayat::with(['payment.cart.pangan'])
            ->latest('created_at')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $records,
        ], 200);
    }

    // Fixed method name and logic
    private function generateRiwayatId()
    {
        $lastRiwayat = Riwayat::orderBy('idHistory', 'desc')->first();
        
        if (!$lastRiwayat) {
            return 'R001';
        }
        
        // Extract the numeric part from the last ID (fixed field name)
        $lastNumber = intval(substr($lastRiwayat->idHistory, 1));
        $newNumber = $lastNumber + 1;
        
        // Format with leading zeros (3 digits)
        return 'R' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idPayment' => 'required|string|exists:payment,idPayment',
            'status' => 'nullable|in:processing,given_to_courier,on_the_way,arrived,completed,cancelled',
            'delivery_address' => 'nullable|string',
            'phone_number' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $history = Riwayat::create([
                'idHistory' => $this->generateRiwayatId(),
                'idPayment' => $request->idPayment,
                'status' => $request->status ?? 'processing',
                'delivery_address' => $request->delivery_address,
                'phone_number' => $request->phone_number,
                'notes' => $request->notes,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'History Created',
                'data' => $history->load('payment'),
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create history',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show(string $id)
    {
        $history = Riwayat::with(['payment.cart.pangan'])->find($id);

        if (! $history) {
            return response()->json([
                'success' => false,
                'message' => 'History not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $history,
        ], 200);
    }

    public function update(Request $request, string $id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:processing,given_to_courier,on_the_way,arrived,completed,cancelled',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $history = Riwayat::find($id);

        if (!$history) {
            return response()->json([
                'success' => false,
                'message' => 'History not found',
            ], 404);
        }

        try {
            $history->update(['status' => $request->status]);
            $history->load(['payment.cart.pangan']);

            return response()->json([
                'success' => true,
                'message' => 'Order status updated successfully',
                'data' => $history,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update order status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy(string $id)
    {
        $history = Riwayat::find($id);

        if (! $history) {
            return response()->json([                
                'success' => false, 'message' => 'History item not found',
            ], 404);
        }

        $history->delete();

        return response()->json([
            'success' => true,
            'message' => 'History item deleted successfully',
        ], 200);
    }

    /**
     * Get riwayat by mitra ID
     * Note: Since pangan.idMitra was dropped from schema, this now returns all riwayat
     * TODO: Add user tracking to payment/cart tables to enable proper filtering
     */
    public function getByMitra($mitraId)
    {
        // Return all riwayat since pangan.idMitra no longer exists
        // Frontend will need to filter locally if needed
        $riwayats = Riwayat::with(['payment.cart.pangan'])
            ->latest('created_at')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $riwayats,
            'note' => 'Filtering by mitra disabled - pangan.idMitra column removed',
        ], 200);
    }

    /**
     * Mitra confirms order received (Pesanan Selesai)
     */
    public function confirmDelivery($id)
    {
        $riwayat = Riwayat::find($id);
        
        if (!$riwayat) {
            return response()->json([
                'success' => false,
                'message' => 'Riwayat not found',
            ], 404);
        }

        // Can only confirm if status is 'arrived'
        if ($riwayat->status !== 'arrived') {
            return response()->json([
                'success' => false,
                'message' => 'Can only confirm delivery when order status is "arrived"',
            ], 400);
        }

        try {
            $riwayat->update([
                'status' => 'completed',
                'notes' => 'Pesanan telah diterima oleh Mitra',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pesanan telah dikonfirmasi sebagai selesai',
                'data' => $riwayat->load(['payment.cart.pangan']),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to confirm delivery',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get status labels for display
     */
    public function getStatusLabels()
    {
        return response()->json([
            'success' => true,
            'data' => [
                'processing' => [
                    'label' => 'Sedang Diproses',
                    'indonesian' => 'Pesanan sedang diproses',
                    'order' => 1,
                ],
                'given_to_courier' => [
                    'label' => 'Diberikan ke Kurir',
                    'indonesian' => 'Pesanan diberikan ke kurir',
                    'order' => 2,
                ],
                'on_the_way' => [
                    'label' => 'Dalam Perjalanan',
                    'indonesian' => 'Pesanan dalam perjalanan',
                    'order' => 3,
                ],
                'arrived' => [
                    'label' => 'Sampai Tujuan',
                    'indonesian' => 'Pesanan sampai di tujuan',
                    'order' => 4,
                ],
                'completed' => [
                    'label' => 'Pesanan Selesai',
                    'indonesian' => 'Pesanan telah diterima',
                    'order' => 5,
                ],
            ],
        ]);
    }
}
