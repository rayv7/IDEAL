<?php
$host = "sql200.infinityfree.com";
$user = "if0_43151861";
$password = "6889Blue6998";
$db = "if0_43151861_ideal_db";
$con = mysqli_connect($host, $user, $password, $db);

if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}