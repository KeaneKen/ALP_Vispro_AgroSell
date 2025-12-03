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

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idHistory' => 'required|string|unique:riwayat,idHistory',
            'idPayment' => 'required|string|exists:payment,idPayment',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $history = Riwayat::create($validator->validated());

        return response()->json([
            'success' => true,
            'message' => 'History Created',
            'data' => $history->load('payment'),
        ], 201);
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
