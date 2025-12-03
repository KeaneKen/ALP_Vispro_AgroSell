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

    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'idMitra' => 'required|string|unique:mitra,idMitra',
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
                'idMitra' => $request->idMitra,
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
}
