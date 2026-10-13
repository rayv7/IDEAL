<?php
require 'connect.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$response = ['success' => 0, 'message' => ''];

$fname = trim($_POST["fname"] ?? '');
$sname = trim($_POST["sname"] ?? '');
$phonenum = trim($_POST["phonenum"] ?? '');
$password = trim($_POST["password"] ?? '');
$email = trim($_POST["email"] ?? '');

if (empty($fname) || empty($phonenum) || empty($password)) {
    $response['message'] = "Required fields missing";
    echo json_encode($response);
    exit;
}

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$stmt = mysqli_prepare($con, "INSERT INTO users (fname, sname, phonenum, password, email) VALUES (?, ?, ?, ?, ?)");

if ($stmt) {
    mysqli_stmt_bind_param($stmt, "sssss", $fname, $sname, $phonenum, $hashed_password, $email);
    if (mysqli_stmt_execute($stmt)){
        $response['success'] = 1;
        $response['message'] = "User successfully registered";
    } else {
        $response['message'] = "Unable to register user: Phonenumber or email may already exist";
    }
    mysqli_stmt_close($stmt);
} else {
    $response['message'] = "Database Error.";
}
echo json_encode($response);
mysqli_close($con);