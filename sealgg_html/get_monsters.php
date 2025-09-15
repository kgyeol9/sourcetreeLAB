<?php
header('Content-Type: application/json');

$host = "localhost";
$user = "heelack";
$pass = "As17608057!";
$db = "heelack";

$conn = new mysqli($host, $user, $pass, $db);
$conn->set_charset("utf8");

$sql = "SELECT * FROM tb_monster";
$result = $conn->query($sql);

$monsters = [];
while ($row = $result->fetch_assoc()) {
    // 문자열을 배열로 분리
    $row['drop_items'] = isset($row['drop_items']) ? explode(",", $row['drop_items']) : [];
    $row['field_array'] = isset($row['field']) ? explode(",", $row['field']) : [];

    $monsters[] = $row;
}

echo json_encode($monsters, JSON_UNESCAPED_UNICODE);
$conn->close();
?>
