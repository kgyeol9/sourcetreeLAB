<?php
header('Content-Type: application/json');

$host = "localhost";
$user = "heelack";
$pass = "As17608057!";
$db = "heelack";

$conn = new mysqli($host, $user, $pass, $db);
$conn->set_charset("utf8");

$sql = "SELECT * FROM tb_item";
$result = $conn->query($sql);

$items = [];
while ($row = $result->fetch_assoc()) {
    $items[] = [
    'id' => $row['id'], // ✅ 이 줄 추가
    'name' => $row['name'],
    'category' => $row['category'],
    'job' => $row['job'],
    'row' => $row['row'],
    'col' => $row['col'],
    'imagePath' => $row['imagePath']
];

}

echo json_encode($items, JSON_UNESCAPED_UNICODE);
$conn->close();
?>
