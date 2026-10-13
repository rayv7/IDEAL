<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'connect.php';

$query = "SELECT category_id, name FROM categories";

$result = mysqli_query($con, $query);

$categories = array();

if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        array_push($categories, array(
            'category_id' => (string)$row['category_id'],
            'name' => $row['name']
        ));
    }
    echo json_encode(array("success" => 1, "data" => $categories));
} else {
    echo json_encode(array("success" => 0, "message" => "No categories found", "data" => array()));
}

mysqli_close($con);