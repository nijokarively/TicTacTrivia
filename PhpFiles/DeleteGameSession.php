<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection"); 

$name = $_GET['name'];


$query = "DELETE FROM gameSession WHERE p1Name = '$name' AND sessionFull = '0'";

if (mysqli_query($con,$query)){
	echo json_encode("New record created successfully");
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
?> 
