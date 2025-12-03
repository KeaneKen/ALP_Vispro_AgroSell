<?php

namespace App\Http\Controllers;
use App\Models\Pangan;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PanganController extends Controller
{
    public function index() {
        try {
            $pangan = \App\Models\Pangan::all();
            return response()->json($pangan, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to retrieve pangan'], 500);
        }
    }

    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'idPangan' => 'required|string|unique:pangan,idPangan',
            'name' => 'required|string|max:255',
            'type' => 'required|string|max:100',
            'price' => 'required|numeric',
            'stock' => 'required|integer',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $pangan = Pangan::create([
                'idPangan' => $request->idPangan,
                'name' => $request->name,
                'type' => $request->type,
                'price' => $request->price,
                'stock' => $request->stock,
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Pangan created successfully',
            'data' => $pangan
        ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create pangan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
