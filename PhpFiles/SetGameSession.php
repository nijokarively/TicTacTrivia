<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection"); 

$name = $_GET['name'];
$id = $_GET['id'];


$query = "UPDATE gameSession SET p2Name = '$name', sessionFull = '1' WHERE sessionID = '$id'";

if (mysqli_query($con,$query)){
	echo json_encode("New record created successfully");
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
?> 
