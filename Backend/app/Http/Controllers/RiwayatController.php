<?php

namespace App\Http\Controllers;

use App\Models\Riwayat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RiwayatController extends Controller
{
    public function index()
    {
        $records = Riwayat::with('payment')->latest('created_at')->get();

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
            // Removed idHistory from validation - now auto-generated
            'idPayment' => 'required|string|exists:payment,idPayment',
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
        $history = Riwayat::with('payment')->find($id);

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
}
