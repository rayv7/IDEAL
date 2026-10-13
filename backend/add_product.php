<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$name = $_POST['name'] ?? '';
$price = $_POST['price'] ?? 0;
$unit = $_POST['unit'] ?? '';
$category_id = $_POST['category_id'] ?? null;
$quantity = $_POST['quantity'] ?? 50;
$description = $_POST['description'] ?? '';
// Receives the high-res Cloudinary HTTPS URL directly from Flutter
$image_path = $_POST['image_url'] ?? 'assets/placeholder.png';

$sql = "INSERT INTO products (name, price, unit, category_id, quantity, description, image) 
        VALUES ('$name', '$price', '$unit', '$category_id', '$quantity', '$description', '$image_path')";

if (mysqli_query($con, $sql)) {
    echo json_encode(["success" => 1, "message" => "Product added successfully"]);
} else {
    echo json_encode(["success" => 0, "message" => "Error adding product: " . mysqli_error($con)]);
}

mysqli_close($con);