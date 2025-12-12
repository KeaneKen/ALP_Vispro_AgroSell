<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Bumdes;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;

class BumdesController extends Controller
{
    public function index() {
        try {
            $bumdes = \App\Models\Bumdes::all();
            return response()->json($bumdes, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch bumdes'], 500);
        }
    }

    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'idBumdes' => 'required|string|unique:bumdes,idBumDES',
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:bumdes,Email_BumDES',
            'password' => 'required|string|min:8',
            'phone' => 'required|string|max:20',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $bumdes = Bumdes::create([
                'idBumDES' => $request->idBumdes,
                'Nama_BumDES' => $request->name,
                'Email_BumDES' => $request->email,
                'Password_BumDES' => Hash::make($request->password),
                'NoTelp_BumDES' => $request->phone,
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Bumdes created successfully',
            'data' => $bumdes
        ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create bumdes',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Show bumdes details
    public function show($idBumdes) {
        try {
            $bumdes = Bumdes::findOrFail($idBumdes);
            return response()->json([
                'success' => true,
                'message' => 'Bumdes retrieved successfully',
                'data' => $bumdes
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Bumdes not found'
            ], 404);
        }
    }

}
