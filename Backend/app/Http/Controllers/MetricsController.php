<?php

namespace App\Http\Controllers;

use App\Models\Pangan;
use App\Models\PreOrder;
use App\Models\Payment;
use App\Models\Mitra;
use App\Models\Bumdes;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MetricsController extends Controller
{
    /**
     * Get dashboard metrics
     */
    public function dashboard(Request $request)
    {
        try {
            // Total products
            $totalProducts = Pangan::count();

            // Available products (using all products since no stok column)
            $availableProducts = Pangan::count();

            // Pre-order products (pending pre-orders)
            $preOrderProducts = PreOrder::where('status', 'pending')->count();

            // Categories count (using 0 for now as Kategori_Pangan might not exist)
            $categoriesCount = 0;

            // Total sales (from payments using Total_Harga)
            $totalSales = Payment::sum('Total_Harga') ?? 0;

            // Active orders (using all payments since no status column)
            $activeOrders = Payment::count();

            // Total mitras
            $totalMitras = Mitra::count();

            // Total bumdes
            $totalBumdes = Bumdes::count();

            return response()->json([
                'success' => true,
                'data' => [
                    'products' => [
                        'total' => $totalProducts,
                        'available' => $availableProducts,
                        'preOrder' => $preOrderProducts,
                    ],
                    'categories' => $categoriesCount,
                    'sales' => [
                        'total' => (float) $totalSales,
                        'activeOrders' => $activeOrders,
                    ],
                    'users' => [
                        'mitras' => $totalMitras,
                        'bumdes' => $totalBumdes,
                    ],
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch dashboard metrics',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
