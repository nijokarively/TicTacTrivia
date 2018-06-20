<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection");

$name = $_GET['name'];

$query = "INSERT INTO gameSession VALUES (DEFAULT, '$name', DEFAULT, '1','0')";

if (mysqli_query($con,$query)){
	echo json_encode("New move added successfully");
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
?> 
