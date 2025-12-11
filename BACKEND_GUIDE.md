# Backend Implementation Guide

## Quick Start: Implementing Missing APIs

### Step 1: Create Migrations

```bash
cd Backend
php artisan make:migration create_pre_orders_table
php artisan make:migration create_pre_order_items_table
php artisan make:migration create_orders_table
php artisan make:migration create_order_items_table
php artisan make:migration create_notifications_table
php artisan make:migration create_activities_table
```

### Step 2: Define Migration Schemas

#### Pre-Orders Migration
```php
public function up() {
    Schema::create('pre_orders', function (Blueprint $table) {
        $table->string('idPreOrder')->primary();
        $table->string('idMitra');
        $table->string('idBumDES');
        $table->date('order_date');
        $table->date('harvest_date')->nullable();
        $table->date('delivery_date')->nullable();
        $table->enum('status', ['pending', 'approved', 'rejected', 'completed'])->default('pending');
        $table->enum('payment_status', ['unpaid', 'dp', 'paid'])->default('unpaid');
        $table->decimal('total_amount', 15, 2);
        $table->decimal('dp_amount', 15, 2)->nullable();
        $table->text('notes')->nullable();
        $table->timestamps();
        
        $table->foreign('idMitra')->references('idMitra')->on('mitra');
        $table->foreign('idBumDES')->references('idBumDES')->on('bumdes');
    });
}
```

#### Orders Migration
```php
public function up() {
    Schema::create('orders', function (Blueprint $table) {
        $table->string('idOrder')->primary();
        $table->string('idMitra');
        $table->string('idBumDES');
        $table->string('buyer_name');
        $table->string('buyer_phone');
        $table->text('delivery_address');
        $table->enum('payment_status', ['unpaid', 'paid', 'proses', 'antar'])->default('unpaid');
        $table->date('order_date');
        $table->text('notes')->nullable();
        $table->timestamps();
        
        $table->foreign('idMitra')->references('idMitra')->on('mitra');
        $table->foreign('idBumDES')->references('idBumDES')->on('bumdes');
    });
}
```

#### Notifications Migration
```php
public function up() {
    Schema::create('notifications', function (Blueprint $table) {
        $table->id('idNotification');
        $table->string('user_id');
        $table->enum('user_type', ['bumdes', 'mitra']);
        $table->string('title');
        $table->text('message');
        $table->enum('type', ['order', 'pre_order', 'payment', 'chat', 'promo', 'system']);
        $table->boolean('is_read')->default(false);
        $table->json('action_data')->nullable();
        $table->timestamps();
    });
}
```

### Step 3: Create Models

```bash
php artisan make:model PreOrder
php artisan make:model PreOrderItem
php artisan make:model Order
php artisan make:model OrderItem
php artisan make:model Notification
php artisan make:model Activity
```

#### PreOrder Model (app/Models/PreOrder.php)
```php
<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PreOrder extends Model
{
    protected $table = 'pre_orders';
    protected $primaryKey = 'idPreOrder';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'idPreOrder', 'idMitra', 'idBumDES', 'order_date', 
        'harvest_date', 'delivery_date', 'status', 
        'payment_status', 'total_amount', 'dp_amount', 'notes'
    ];

    protected $casts = [
        'order_date' => 'date',
        'harvest_date' => 'date',
        'delivery_date' => 'date',
        'total_amount' => 'decimal:2',
        'dp_amount' => 'decimal:2',
    ];

    public function mitra() {
        return $this->belongsTo(Mitra::class, 'idMitra', 'idMitra');
    }

    public function bumdes() {
        return $this->belongsTo(Bumdes::class, 'idBumDES', 'idBumDES');
    }

    public function items() {
        return $this->hasMany(PreOrderItem::class, 'idPreOrder', 'idPreOrder');
    }
}
```

### Step 4: Create Controllers

```bash
php artisan make:controller PreOrderController --resource
php artisan make:controller OrderController --resource
php artisan make:controller NotificationController --resource
```

#### PreOrderController Example
```php
<?php
namespace App\Http\Controllers;

use App\Models\PreOrder;
use Illuminate\Http\Request;

class PreOrderController extends Controller
{
    public function index()
    {
        $preOrders = PreOrder::with(['items.pangan', 'mitra', 'bumdes'])->get();
        return response()->json($preOrders);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'idMitra' => 'required|exists:mitra,idMitra',
            'idBumDES' => 'required|exists:bumdes,idBumDES',
            'order_date' => 'required|date',
            'harvest_date' => 'nullable|date',
            'delivery_date' => 'nullable|date',
            'total_amount' => 'required|numeric',
            'items' => 'required|array',
            'items.*.idPangan' => 'required|exists:pangan,idPangan',
            'items.*.quantity' => 'required|numeric',
            'items.*.price' => 'required|numeric',
        ]);

        // Generate ID
        $validated['idPreOrder'] = 'PO-' . str_pad(PreOrder::count() + 1, 3, '0', STR_PAD_LEFT);
        
        $preOrder = PreOrder::create($validated);
        
        // Create items
        foreach ($request->items as $item) {
            $preOrder->items()->create($item);
        }

        return response()->json($preOrder->load('items'), 201);
    }

    public function show($id)
    {
        $preOrder = PreOrder::with(['items.pangan', 'mitra', 'bumdes'])->findOrFail($id);
        return response()->json($preOrder);
    }

    public function approve($id)
    {
        $preOrder = PreOrder::findOrFail($id);
        $preOrder->update(['status' => 'approved']);
        return response()->json($preOrder);
    }
}
```

### Step 5: Define Routes (routes/api.php)

```php
use App\Http\Controllers\PreOrderController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\NotificationController;

// Pre-Orders
Route::get('/pre-orders', [PreOrderController::class, 'index']);
Route::post('/pre-orders', [PreOrderController::class, 'store']);
Route::get('/pre-orders/{id}', [PreOrderController::class, 'show']);
Route::put('/pre-orders/{id}', [PreOrderController::class, 'update']);
Route::put('/pre-orders/{id}/approve', [PreOrderController::class, 'approve']);
Route::delete('/pre-orders/{id}', [PreOrderController::class, 'destroy']);

// Orders
Route::get('/orders', [OrderController::class, 'index']);
Route::post('/orders', [OrderController::class, 'store']);
Route::get('/orders/{id}', [OrderController::class, 'show']);
Route::put('/orders/{id}', [OrderController::class, 'update']);

// Notifications
Route::get('/notifications', [NotificationController::class, 'index']);
Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);

// Payments - unpaid items
Route::get('/payments/unpaid', [PaymentController::class, 'getUnpaidItems']);

// Activities
Route::get('/bumdes/{id}/activities', [BumdesController::class, 'getActivities']);
```

### Step 6: Create Seeders

```bash
php artisan make:seeder PreOrderSeeder
php artisan make:seeder OrderSeeder
php artisan make:seeder NotificationSeeder
```

#### PreOrderSeeder Example
```php
<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PreOrder;
use App\Models\PreOrderItem;

class PreOrderSeeder extends Seeder
{
    public function run()
    {
        $po1 = PreOrder::create([
            'idPreOrder' => 'PO-001',
            'idMitra' => 'M001',
            'idBumDES' => 'B001',
            'order_date' => now(),
            'harvest_date' => now()->addDays(30),
            'delivery_date' => now()->addDays(35),
            'status' => 'approved',
            'payment_status' => 'dp',
            'total_amount' => 500000,
            'dp_amount' => 150000,
        ]);

        PreOrderItem::create([
            'idPreOrder' => 'PO-001',
            'idPangan' => 'P001',
            'quantity' => 50,
            'price' => 10000,
            'plant_status' => 'Tanaman dalam kondisi baik',
        ]);
    }
}
```

### Step 7: Run Migrations and Seeders

```bash
php artisan migrate
php artisan db:seed --class=PreOrderSeeder
php artisan db:seed --class=OrderSeeder
php artisan db:seed --class=NotificationSeeder
```

### Step 8: Update Frontend Repositories

Create repository files and update ViewModels to use them:

1. `pre_order_repository.dart` - Handle pre-order API calls
2. `order_repository.dart` - Handle order API calls  
3. `notification_repository.dart` - Handle notification API calls
4. `activity_repository.dart` - Handle activity API calls

### Step 9: Test APIs

```bash
# Test pre-orders
curl http://localhost:8000/api/pre-orders

# Test notifications
curl http://localhost:8000/api/notifications

# Test orders
curl http://localhost:8000/api/orders
```

---

## Priority Order

Implement in this order for fastest user-visible results:

1. **Notifications** (Simple, high visibility)
2. **Pre-Orders** (Core feature for Bumdes)
3. **Orders** (Core feature for transactions)
4. **Activities** (Profile enhancement)
5. **Chat** (Complex, lower priority)

---

**Tip:** Start the Laravel server with `php artisan serve` and monitor logs with `tail -f storage/logs/laravel.log`
