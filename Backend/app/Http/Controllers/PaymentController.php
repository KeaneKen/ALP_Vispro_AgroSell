<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class PaymentController extends Controller
{
    /**
     * Display a listing of all payments
     */
    public function index()
    {
        try {
            $payments = Payment::with('mitra')->get();
            return response()->json([
                'success' => true,
                'data' => $payments
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve payments',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    private function generatePaymentId()
    {
        $lastPayment = Payment::orderBy('idPayment', 'desc')->first();
        
        if (!$lastPayment) {
            return 'PAY001';
        }
        
        // Extract the numeric part from the last ID
        $lastNumber = intval(substr($lastPayment->idPayment, 3));
        $newNumber = $lastNumber + 1;
        
        // Format with leading zeros (3 digits)
        return 'PAY' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    }

    /**
     * Store a new payment
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idCart' => 'required|string|exists:cart,idCart',
            'Total_Harga' => 'required|numeric|min:0',
            'payment_method' => 'nullable|string|max:50',
            'payment_details' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

            // Create payment record
            $payment = Payment::create([
                'idPayment' => $this->generatePaymentId(),
                'idMitra' => $request->user()->idMitra ?? null,
                'amount' => $request->amount,
                'payment_method' => $request->payment_method,
                'payment_details' => json_encode($request->payment_details ?? []),
                'status' => 'processing',
                'transaction_id' => 'TXN-' . Str::upper(Str::random(12)),
                'paid_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Payment processed successfully',
                'data' => $payment
            ], 201);

        }


    
    /**
     * Display the specified payment
     */
    public function show($id)
    {
        try {
            $payment = Payment::with(['mitra'])->find($id);

            if (!$payment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Payment not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $payment
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve payment',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Confirm payment status
     */
    public function confirmPayment(Request $request, $id)
    {
        try {
            $payment = Payment::find($id);

            if (!$payment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Payment not found'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'status' => 'required|in:completed,failed,cancelled',
                'notes' => 'nullable|string|max:500',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $payment->update([
                'status' => $request->status,
                'notes' => $request->notes,
                'confirmed_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Payment status updated successfully',
                'data' => $payment->fresh()
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update payment status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Get payments by mitra
    public function getByMitra($mitraId)
    {
        try {
            $payments = Payment::with(['mitra'])
                             ->where('idMitra', $mitraId)
                             ->orderBy('paid_at', 'desc')
                             ->get();

            return response()->json([
                'success' => true,
                'data' => $payments
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve payments for mitra',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get payments by status
     */
    public function getByStatus($status)
    {
        try {
            $payments = Payment::with('mitra')
                             ->where('status', $status)
                             ->orderBy('paid_at', 'desc')
                             ->get();

            return response()->json([
                'success' => true,
                'data' => $payments
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve payments by status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Refund a payment
     */
    public function refund(Request $request, $id)
    {
        try {
            $payment = Payment::find($id);

            if (!$payment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Payment not found'
                ], 404);
            }

            if ($payment->status !== 'completed') {
                return response()->json([
                    'success' => false,
                    'message' => 'Only completed payments can be refunded'
                ], 400);
            }

            $validator = Validator::make($request->all(), [
                'refund_amount' => 'required|numeric|min:0|max:' . $payment->amount,
                'reason' => 'required|string|max:500',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $payment->update([
                'status' => 'refunded',
                'refund_amount' => $request->refund_amount,
                'refund_reason' => $request->reason,
                'refunded_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Payment refunded successfully',
                'data' => $payment->fresh()
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to process refund',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
