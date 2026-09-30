<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

$response = ["success" => 0, "message" => ""];

// Collect form fields matching database schema
$name = $_POST['name'] ?? '';
$category_id = $_POST['category_id'] ?? 1;
$price = $_POST['price'] ?? 0.0;
$unit = $_POST['unit'] ?? '1L';
$quantity = $_POST['quantity'] ?? 10;
$description = $_POST['description'] ?? '';

$imagePath = 'assets/placeholder.png'; // Default fallback

// Handle file upload if an image was picked from device gallery
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = 'uploads/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }
    
    $filename = time() . '_' . basename($_FILES['image']['name']);
    $targetFilePath = $uploadDir . $filename;

    if (move_uploaded_file($_FILES['image']['tmp_name'], $targetFilePath)) {
        // Full accessible server URL
        $imagePath = "http://10.0.2.2/backend/" . $targetFilePath;
    }
} elseif (!empty($_POST['image_url'])) {
    // If admin pasted a direct URL / Drive link instead
    $imagePath = $_POST['image_url'];
}

// Insert into ideal_db.products table
$sql = "INSERT INTO products (name, category_id, price, unit, quantity, image, description) 
        VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = $con->prepare($sql);
$stmt->bind_param("sidsiss", $name, $category_id, $price, $unit, $quantity, $imagePath, $description);

if ($stmt->execute()) {
    $response["success"] = 1;
    $response["message"] = "Product added successfully";
} else {
    $response["message"] = "Database insert failed: " . $stmt->error;
}

echo json_encode($response);
$stmt->close();
mysqli_close($con);
?>