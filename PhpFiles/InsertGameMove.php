<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection");

$id = $_GET['id'];

$query = "INSERT INTO gameMove VALUES ('$id','-10','-10')";

if (mysqli_query($con,$query)){
	echo json_encode("New move added successfully");
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
?> 
