<?php
$mysqli = new mysqli("data", "user", "pass", "testdb");

if ($mysqli->connect_error) {
    die("Erreur de connexion à la base de données : " . $mysqli->connect_error);
}

$result = $mysqli->query("SELECT valeur FROM compteur WHERE id=1");
$row = $result->fetch_assoc();
$valeur = $row["valeur"] + 1;

$mysqli->query("UPDATE compteur SET valeur=$valeur WHERE id=1");

echo "<h1>Compteur : $valeur</h1>";

$mysqli->close();
?>