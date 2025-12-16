<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Bumdes;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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
            'idBumDES' => 'required|string|unique:bumdes,idBumDES',
            'Nama_BumDES' => 'required|string|max:255',
            'Email_BumDES' => 'required|string|email|max:255|unique:bumdes,Email_BumDES',
            'Password_BumDES' => 'required|string|min:8',
            'NoTelp_BumDES' => 'required|string|max:20',
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

    // Upload profile picture
    public function uploadProfilePicture(Request $request, $idBumdes) {
        $validator = Validator::make($request->all(), [
            'profile_picture' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);
        
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }
        
        try {
            $bumdes = Bumdes::findOrFail($idBumdes);
            
            // Delete old profile picture if exists
            if ($bumdes->profile_picture && Storage::exists('public/profile_pictures/' . $bumdes->profile_picture)) {
                Storage::delete('public/profile_pictures/' . $bumdes->profile_picture);
            }
            
            // Store new profile picture
            $file = $request->file('profile_picture');
            $filename = $idBumdes . '_' . time() . '.' . $file->getClientOriginalExtension();
            $file->storeAs('public/profile_pictures', $filename);
            
            // Update database
            $bumdes->profile_picture = $filename;
            $bumdes->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Profile picture uploaded successfully',
                'data' => [
                    'profile_picture_url' => asset('storage/profile_pictures/' . $filename)
                ]
            ], 200);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to upload profile picture',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Login bumdes
    public function login(Request $request) {
        $validator = Validator::make($request->all(), [
            'Email_BumDES' => 'required|string|email',
            'Password_BumDES' => 'required|string',
        ]);
        
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }
        
        try {
            // Find bumdes by email
            $bumdes = Bumdes::where('Email_BumDES', $request->Email_BumDES)->first();
            
            if (!$bumdes) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email tidak terdaftar'
                ], 401);
            }
            
            // Verify password
            if (!Hash::check($request->Password_BumDES, $bumdes->Password_BumDES)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Password salah'
                ], 401);
            }
            
            // Login successful
            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => $bumdes
            ], 200);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Login failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
