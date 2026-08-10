<?php
require 'connect.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$fname = $_POST["fname"];
$sname = $_POST["sname"];
$phonenum = $_POST["phonenum"];
$password = $_POST["password"];
$email = $_POST["email"];
$flag['success'] = 0;

$sql = "INSERT INTO users (fname, sname, phonenum, password, email)
         VALUES ('$fname', '$sname', '$phonenum', '$password', '$email')";

if ($res = mysqli_query($con, $sql)) {
    $flag['success'] = 1;
}
print(json_encode($flag));
mysqli_close($con);
