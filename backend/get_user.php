<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}     

$response = [
    'success' => 0,
    'data'    => [],
    'message' => ''
];

$phonenum = trim($_GET['phonenum'] ?? '');

if ($phonenum === '') {
    $response['message'] = "Missing phone number.";
    echo json_encode($response);
    exit;
}

$stmt = mysqli_prepare($con, "SELECT fname, sname, email, phonenum FROM users WHERE phonenum = ? LIMIT 1");

if (!$stmt) {
    $response['message'] = "Query preparation failed.";
    echo json_encode($response);
    exit;
}

mysqli_stmt_bind_param($stmt, "s", $phonenum);
mysqli_stmt_execute($stmt);
$res = mysqli_stmt_get_result($stmt);

while ($row = mysqli_fetch_assoc($res)) {
    $response['data'][] = $row;
}

if (count($response['data']) > 0) {
    $response['success'] = 1;
} else {
    $response['message'] = "User not found.";
}

mysqli_stmt_close($stmt);
mysqli_close($con);

echo json_encode($response);