<?php
require 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

$response = [
    'success' => 0,
    'user' => null
];

if (isset($_GET['email'])) {
    $email = $_GET['email'];

    $stmt = $con->prepare("SELECT fname, sname, phonenum, email FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    
    if ($stmt->execute()) {
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user_data = $result->fetch_assoc();
            
            $response['success'] = 1;
            $response['user'] = $user_data;
        } else {
            $response['message'] = "User not found.";
        }
    } else {
        $response['message'] = "Database query failed.";
    }

    $stmt->close();
} else {
    $response['message'] = "Missing required parameters.";
}

print(json_encode($response));
mysqli_close($con);
?>