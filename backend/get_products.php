<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Select products with category name join
$sql = "SELECT p.product_id, p.name, p.price, p.unit, p.quantity, p.image, p.description, 
               COALESCE(c.name, 'General') AS category
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.category_id";

$result = mysqli_query($con, $sql);
$products = [];

if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $products[] = [
            'id' => (string)$row['product_id'],
            'name' => $row['name'],
            'category' => $row['category'],
            'price' => (double)$row['price'],
            'unit' => $row['unit'] ?? '',
            'imagePath' => $row['image'] ?? 'assets/placeholder.png'
        ];
    }
    echo json_encode(["success" => 1, "data" => $products]);
} else {
    echo json_encode(["success" => 0, "message" => "Database query failed"]);
}

mysqli_close($con);