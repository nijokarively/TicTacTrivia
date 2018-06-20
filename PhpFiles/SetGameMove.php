<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection");

$position = $_GET['position'];
$player = $_GET['player'];
$id = $_GET['id'];

$query = "UPDATE gameMove SET $player = '$position' WHERE gameID = '$id'";

if (mysqli_query($con,$query)){
	echo json_encode("New move added successfully");
} else {
	echo "Error: " . $query . "<br>" . mysqli_error($conn);
}
?> 
