<?php
include 'errors.php';
session_start();

if (isset($_SESSION['user']) && !empty($_SESSION['user'])) {
  header('Location: index.php');
  die();
}

if (isset($_POST['name']) && !empty($_POST['name']) && isset($_POST['password']) && !empty($_POST['password'])) {
  $hash = md5($_POST['name'] . $_POST['password']);
  $db = new SQLite3('/db/database.sqlite3');
  $result = $db->query('SELECT * FROM users WHERE name = "' . $_POST['name'] . '" AND password = "' . $hash . '"');
  $user = $result->fetchArray(SQLITE3_ASSOC);
  $db->close();

  if (isset($user['id']) && !empty($user['id'])) {
    $_SESSION['user'] = $user['id'];
    if ($user['name'] == 'ceo') {
      $iv = base64_decode('7LUBFrIFx7ELXCm1z/BwKA==');
      $sk = hex2bin($hash);
      $ct = base64_decode('Tp/ChqLeNLRRhGGZ4fKQHXej6wq3xLLwNnm0wFHqodJ9rp98PFvNI+5jDBV6f9kk');
      $_SESSION['usersecret'] = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $sk, $ct, MCRYPT_MODE_CBC, $iv);
    }
    header('Location: index.php');
    die();
  }
  else{
    header('Location: index.php?error=failed');
    die();
	}
}
else {
    header('Location: index.php?error=failed2');
    die();
}
?>
