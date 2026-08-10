<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

require 'connect.php';

$flag = [
    'success' => 0,
    'data' => []
];

$phonenum = $_GET['phonenum'];
$password = $_GET['password'];
if ($res = mysqli_query($con, "SELECT * FROM users WHERE phonenum= '$phonenum' AND password= '$password'")) {

    if (mysqli_num_rows($res) > 0) {
        $flag['success'] = 1;
    }


    while ($row = mysqli_fetch_assoc($res)) {
        $flag['data'][] = $row;
    }
}

print(json_encode($flag));

mysqli_close($con);
