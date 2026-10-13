<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require 'connect.php';

$response = [
    'success' => 0,
    'data' => [],
    'message' => ''
];

$phonenum = trim($_GET['phonenum'] ?? $_POST['phonenum'] ?? '');
$password = trim($_GET['password'] ?? $_POST['password'] ?? '');

if (empty($phonenum) || empty($password)) {
    $response['message'] = "Phone number and password are required.";
    echo json_encode($response);
    exit;
}

// Prepare statement to fetch user by phone number safely
$stmt = mysqli_prepare($con, "SELECT id, fname, sname, email, phonenum, password FROM users WHERE phonenum = ? LIMIT 1");

if ($stmt) {
    mysqli_stmt_bind_param($stmt, "s", $phonenum);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($row = mysqli_fetch_assoc($result)) {
        // Verify the typed password against the secure database hash
        if (password_verify($password, $row['password'])) {
            // Remove password field from the response data array for safety
            unset($row['password']);
            
            $response['success'] = 1;
            $response['data'][] = $row;
            $response['message'] = "Login successful.";
        } else {
            $response['message'] = "Invalid password.";
        }
    } else {
        $response['message'] = "User not found.";
    }
    mysqli_stmt_close($stmt);
} else {
    $response['message'] = "Database error.";
}

echo json_encode($response);
mysqli_close($con);