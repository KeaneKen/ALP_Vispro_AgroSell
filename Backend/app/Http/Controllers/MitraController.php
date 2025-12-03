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
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:mitra,email',
            'phone' => 'required|string|max:20',
            'address' => 'required|string|max:500',
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
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'phone' => $request->phone,
                'address' => $request->address,
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
