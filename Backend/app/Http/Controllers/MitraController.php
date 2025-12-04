<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Mitra;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MitraController extends Controller
{
    public function index() {
        try {
            $mitras = \App\Models\Mitra::all();
            return response()->json($mitras, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to retrieve mitras'], 500);
        }
    }

    private function generateMitraId() {
        $lastMitra = Mitra::orderBy('idMitra', 'desc')->first();
        
        if (!$lastMitra) {
            return 'M001';
        }
        
        // Extract the numeric part from the last ID
        $lastNumber = intval(substr($lastMitra->idMitra, 1));
        $newNumber = $lastNumber + 1;
        
        // Format with leading zeros (3 digits)
        return 'M' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    }

    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'Nama_Mitra' => 'required|string|max:255',
            'Email_Mitra' => 'required|string|email|max:255|unique:mitra,Email_Mitra',
            'Password_Mitra' => 'required|string|min:8',
            'NoTelp_Mitra' => 'required|string|max:20',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $mitra = Mitra::create([
                'idMitra' => $this->generateMitraId(),
                'Nama_Mitra' => $request->Nama_Mitra,
                'Email_Mitra' => $request->Email_Mitra,
                'Password_Mitra' => Hash::make($request->Password_Mitra),
                'NoTelp_Mitra' => $request->NoTelp_Mitra,
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Mitra created successfully',
            'data' => $mitra
        ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create mitra',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($idMitra) {
        try {
            $mitra = Mitra::findOrFail($idMitra);
            return response()->json([
                'success' => true,
                'data' => $mitra
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Mitra not found'
            ], 404);
        }
    }
}
