<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

$response = ["success" => 0, "message" => ""];

if (isset($_POST['name']) && !empty(trim($_POST['name']))) {
    $category_name = trim($_POST['name']);

    // Insert category into the categories table
    $stmt = $con->prepare("INSERT INTO categories (name) VALUES (?)");
    $stmt->bind_param("s", $category_name);

    if ($stmt->execute()) {
        $response["success"] = 1;
        $response["message"] = "Category created successfully";
        $response["category_id"] = $stmt->insert_id;
    } else {
        $response["message"] = "Error inserting category: " . $stmt->error;
    }

    $stmt->close();
} else {
    $response["message"] = "Category name is required";
}

echo json_encode($response);
mysqli_close($con);