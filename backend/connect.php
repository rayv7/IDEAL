<?php
$host = getenv('MYSQLHOST') ?: 'localhost';
$user = getenv('MYSQLUSER') ?: 'root';
$password = getenv('MYSQLPASSWORD') ?: '';
$dbname = getenv('MYSQLDATABASE') ?: 'ideal_db';
$port = getenv('MYSQLPORT') ?: 3306;

$con = mysqli_connect($host, $user, $password, $dbname, (int)$port);

if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}