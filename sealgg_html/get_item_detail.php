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
        'id' => $row['id'],                  // ✅ 상세페이지용 ID 포함
        'name' => $row['name'],
        'category' => $row['category'],
        'job' => $row['job'],
        'grade' => $row['grade'],
        'enhancement' => $row['enhancement'],
        'lv' => $row['lv'],
        'physicalAttack' => $row['physicalAttack'],
        'magicAttack' => $row['magicAttack'],
        'defense' => $row['defense'],
        'attackSpeed' => $row['attackSpeed'],
        'critical' => $row['critical'],
        'accuracy' => $row['accuracy'],
        'hp' => $row['hp'],
        'ap' => $row['ap'],
        'evade' => $row['evade'],
        'moveSpeed' => $row['moveSpeed'],
        'damageIncrease' => $row['damageIncrease'],
        'damageDecrease' => $row['damageDecrease'],
        'imagePath' => $row['imagePath'],
        'row' => $row['row'],
        'col' => $row['col']
    ];
}

echo json_encode($items, JSON_UNESCAPED_UNICODE);
$conn->close();
?>
