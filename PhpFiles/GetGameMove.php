<?php 
$con = mysqli_connect("localhost", "root"); 
mysqli_select_db($con,"trivia") or die("No Dbase Connection");
$id = $_GET['id'];
$query = "SELECT * FROM gameMove WHERE gameID = '$id'";
$result = mysqli_query($con,$query) or die("query failed");
$num = mysqli_num_rows($result);
mysqli_close($con);
$rows = array();
while ($r = mysqli_fetch_assoc($result)) {
	$rows[] = $r;
}
echo json_encode($rows);
?> 
