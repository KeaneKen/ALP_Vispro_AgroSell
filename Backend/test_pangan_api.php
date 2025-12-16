<?php

// Simple test script to verify pangan API works after removing idMitra

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "http://localhost:8000/api/pangan");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, false);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

curl_close($ch);

echo "HTTP Status Code: " . $httpCode . "\n";
echo "Response:\n";

if ($httpCode === 200) {
    $data = json_decode($response, true);
    if ($data) {
        // Display first pangan item to verify structure
        echo "First pangan item:\n";
        if (!empty($data[0])) {
            foreach ($data[0] as $key => $value) {
                echo "  $key: $value\n";
            }
            
            // Check if idMitra exists (it shouldn't)
            if (array_key_exists('idMitra', $data[0])) {
                echo "\n⚠️ WARNING: idMitra still exists in response!\n";
            } else {
                echo "\n✅ SUCCESS: idMitra has been successfully removed from pangan table!\n";
            }
        }
        
        echo "\nTotal pangan items: " . count($data) . "\n";
    } else {
        echo "Failed to parse JSON response\n";
    }
} else {
    echo $response . "\n";
}
