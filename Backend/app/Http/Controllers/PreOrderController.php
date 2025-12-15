<?php

namespace App\Http\Controllers;

use App\Models\PreOrder;
use App\Models\PreOrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class PreOrderController extends Controller
{
    /**
     * Get all pre-orders, optionally filtered by status or user
     */
    public function index(Request $request)
    {
        try {
            $query = PreOrder::with(['mitra', 'bumdes', 'items.pangan']);

            // Filter by status
            if ($request->has('status')) {
                $query->where('status', $request->status);
            }

            // Filter by mitra
            if ($request->has('idMitra')) {
                $query->where('idMitra', $request->idMitra);
            }

            // Filter by bumdes
            if ($request->has('idBumDES')) {
                $query->where('idBumDES', $request->idBumDES);
            }

            $preOrders = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $preOrders->map(function ($po) {
                    return [
                        'id' => $po->idPreOrder,
                        'supplierName' => $po->mitra->Nama_Mitra ?? 'Unknown',
                        'orderDate' => $po->order_date->format('Y-m-d'),
                        'deliveryDate' => $po->delivery_date ? $po->delivery_date->format('Y-m-d') : null,
                        'totalAmount' => (float) $po->total_amount,
                        'status' => $po->status,
                        'paymentStatus' => $po->payment_status,
                        'items' => $po->items->map(function ($item) {
                            return [
                                'productName' => $item->pangan->namaPangan ?? 'Unknown',
                                'quantity' => $item->quantity,
                                'price' => (float) $item->price,
                                'unit' => $item->pangan->satuan ?? 'pcs',
                            ];
                        }),
                    ];
                }),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch pre-orders',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get single pre-order detail
     */
    public function show($id)
    {
        try {
            $preOrder = PreOrder::with(['mitra', 'bumdes', 'items.pangan'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => [
                    'id' => $preOrder->idPreOrder,
                    'supplierName' => $preOrder->mitra->Nama_Mitra ?? 'Unknown',
                    'orderDate' => $preOrder->order_date->format('Y-m-d'),
                    'deliveryDate' => $preOrder->delivery_date ? $preOrder->delivery_date->format('Y-m-d') : null,
                    'totalAmount' => (float) $preOrder->total_amount,
                    'status' => $preOrder->status,
                    'paymentStatus' => $preOrder->payment_status,
                    'dpAmount' => (float) ($preOrder->dp_amount ?? 0),
                    'notes' => $preOrder->notes,
                    'items' => $preOrder->items->map(function ($item) {
                        return [
                            'productName' => $item->pangan->namaPangan ?? 'Unknown',
                            'quantity' => $item->quantity,
                            'price' => (float) $item->price,
                            'unit' => $item->pangan->satuan ?? 'pcs',
                        ];
                    }),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pre-order not found',
                'error' => $e->getMessage(),
            ], 404);
        }
    }

    /**
     * Create new pre-order
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'idMitra' => 'required|string',
            'idBumDES' => 'required|string',
            'order_date' => 'required|date',
            'delivery_date' => 'nullable|date',
            'total_amount' => 'required|numeric',
            'notes' => 'nullable|string',
            'items' => 'required|array',
            'items.*.idPangan' => 'required|string',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.price' => 'required|numeric',
        ]);

        try {
            DB::beginTransaction();

            $preOrder = PreOrder::create([
                'idPreOrder' => 'PO-' . strtoupper(Str::random(8)),
                'idMitra' => $validated['idMitra'],
                'idBumDES' => $validated['idBumDES'],
                'order_date' => $validated['order_date'],
                'delivery_date' => $validated['delivery_date'] ?? null,
                'total_amount' => $validated['total_amount'],
                'notes' => $validated['notes'] ?? null,
                'status' => 'pending',
            ]);

            foreach ($validated['items'] as $item) {
                PreOrderItem::create([
                    'idPreOrder' => $preOrder->idPreOrder,
                    'idPangan' => $item['idPangan'],
                    'quantity' => $item['quantity'],
                    'price' => $item['price'],
                ]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pre-order created successfully',
                'data' => ['id' => $preOrder->idPreOrder],
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Failed to create pre-order',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update pre-order
     */
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'delivery_date' => 'nullable|date',
            'status' => 'nullable|in:pending,approved,rejected,completed',
            'notes' => 'nullable|string',
        ]);

        try {
            $preOrder = PreOrder::findOrFail($id);
            $preOrder->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Pre-order updated successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update pre-order',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Approve pre-order
     */
    public function approve($id)
    {
        try {
            $preOrder = PreOrder::findOrFail($id);
            $preOrder->update(['status' => 'approved']);

            return response()->json([
                'success' => true,
                'message' => 'Pre-order approved successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to approve pre-order',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
