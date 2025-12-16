<?php

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';

$kernel = $app->make(\Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$preorders = \App\Models\PreOrder::with('items')->limit(3)->get();

echo json_encode($preorders->toArray(), JSON_PRETTY_PRINT);
