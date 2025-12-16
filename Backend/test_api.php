<?php
// Test API to check if database is seeded

require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

// Check database connection and data
try {
    echo "Testing database connection...\n";
    
    // Test Pangan table
    $panganCount = \App\Models\Pangan::count();
    echo "✅ Pangan table has {$panganCount} records\n";
    
    if ($panganCount > 0) {
        echo "\nSample Pangan data:\n";
        $samples = \App\Models\Pangan::take(3)->get();
        foreach ($samples as $pangan) {
            echo "- {$pangan->idPangan}: {$pangan->Nama_Pangan} (Image: {$pangan->idFoto_Pangan})\n";
        }
    } else {
        echo "❌ No pangan data found! Please run: php artisan db:seed\n";
    }
    
    // Test other tables
    $mitraCount = \App\Models\Mitra::count();
    $bumdesCount = \App\Models\Bumdes::count();
    
    echo "\n📊 Database Statistics:\n";
    echo "- Mitra: {$mitraCount} records\n";
    echo "- Bumdes: {$bumdesCount} records\n";
    echo "- Pangan: {$panganCount} records\n";
    
    if ($panganCount == 0) {
        echo "\n⚠️ To seed the database, run:\n";
        echo "php artisan migrate:fresh --seed\n";
    }
    
} catch (Exception $e) {
    echo "❌ Database error: " . $e->getMessage() . "\n";
    echo "\n⚠️ Make sure:\n";
    echo "1. MySQL/database is running\n";
    echo "2. .env file is configured correctly\n";
    echo "3. Database exists\n";
}
