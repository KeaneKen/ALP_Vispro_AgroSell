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

    // Generate Pangan ID with P prefix (P001, P002, ...)
    private function generatePanganId() {
        $lastPangan = Pangan::orderBy('idPangan', 'desc')->first();
        
        if (!$lastPangan) {
            return 'P001';
        }
        
        // Extract the numeric part from the last ID
        $lastNumber = intval(substr($lastPangan->idPangan, 1));
        $newNumber = $lastNumber + 1;
        
        // Format with leading zeros (3 digits)
        return 'P' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    }

    // Auto-detect category from product name
    private function detectCategory($namaPangan) {
        $name = strtolower($namaPangan);
        
        if (str_contains($name, 'padi') || str_contains($name, 'beras') || str_contains($name, 'gabah')) {
            return 'Padi';
        } elseif (str_contains($name, 'jagung') || str_contains($name, 'corn')) {
            return 'Jagung';
        } elseif (str_contains($name, 'cabai') || str_contains($name, 'cabe') || str_contains($name, 'chili')) {
            return 'Cabai';
        }
        
        return 'Lainnya';
    }

    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'Nama_Pangan' => 'required|string|max:255',
            'Deskripsi_Pangan' => 'required|string|max:255',
            'Harga_Pangan' => 'required|numeric',
            'idFoto_Pangan' => 'required|string|max:255',
            'category' => 'nullable|in:Padi,Jagung,Cabai,Lainnya',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Auto-detect category if not provided
            $category = $request->category ?? $this->detectCategory($request->Nama_Pangan);
            
            $pangan = Pangan::create([
                'idPangan' => $this->generatePanganId(),
                'Nama_Pangan' => $request->Nama_Pangan,
                'Deskripsi_Pangan' => $request->Deskripsi_Pangan,
                'Harga_Pangan' => $request->Harga_Pangan,
                'idFoto_Pangan' => $request->idFoto_Pangan,
                'category' => $category,
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

    public function update(Request $request, $idPangan) {
        $validator = Validator::make($request->all(), [
            'Nama_Pangan' => 'string|max:255',
            'Deskripsi_Pangan' => 'string|max:255', 
            'Harga_Pangan' => 'numeric',
            'idFoto_Pangan' => 'string|max:255',
            'category' => 'nullable|in:Padi,Jagung,Cabai,Lainnya',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $pangan = Pangan::findOrFail($idPangan);
            
            // Auto-detect category if name is being updated and category is not provided
            $updateData = $request->only([
                'Nama_Pangan', 
                'Deskripsi_Pangan', 
                'Harga_Pangan', 
                'idFoto_Pangan',
                'category'
            ]);
            
            if (isset($updateData['Nama_Pangan']) && !isset($updateData['category'])) {
                $updateData['category'] = $this->detectCategory($updateData['Nama_Pangan']);
            }
            
            // Update only provided fields, idPangan stays the same
            $pangan->update($updateData);

            return response()->json([
                'success' => true,
                'message' => 'Pangan updated successfully',
                'data' => $pangan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update pangan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Show pangan details
    public function show($idPangan) {
        try {
            $pangan = Pangan::findOrFail($idPangan);
            return response()->json([
                'success' => true,
                'message' => 'Pangan retrieved successfully',
                'data' => $pangan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pangan not found'
            ], 404);
        }
    }
}
