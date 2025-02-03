<?php
// Configurazione del database
$db_host = '34.154.239.168'; # ricc thingy
$db_name = 'image_catalog';
$db_user = 'appmod-phpapp-user';
$db_pass = '7A5q_MNmAPG8';

try {
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Errore di connessione: " . $e->getMessage());
}

session_start();
?>
