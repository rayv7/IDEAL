<?php
// connect.example.php - Rename this file to connect.php and fill in your credentials
$host = "your_mysql_host";
$user = "your_db_user";
$password = "your_db_password";
$db = "your_db_name";

$con = mysqli_connect($host, $user, $password, $db);

if (!$con) {
    die("Database connection failed: " . mysqli_connect_error());
}