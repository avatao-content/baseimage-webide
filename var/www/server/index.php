<?php
include 'errors.php';
session_start();
?>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>You should log in</title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="signin.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<?php
if (isset($_SESSION['user']) && !empty($_SESSION['user'])) {
  $db = new SQLite3('/db/database.sqlite3');
  $result = $db->query('SELECT * FROM users WHERE id = ' . $_SESSION['user']);
  $user = $result->fetchArray(SQLITE3_ASSOC);
  $db->close();
?>
<div class="container">
<div class="jumbotron">
<h1>Welcome, <?= $user['name'] ?></h1><br>
<?php
  if ($user['admin'] == 1) {
?>
<div class="alert alert-success" role="alert">It's dangerous to go alone! Take this: flag{OhYesLittleBobbyTablesWeCallHim}</div><br>
<?php
  } else if ($user['name'] == 'ceo') {
?>
<div class="alert alert-success" role="alert">Nice work, not-CEO.<br>Here is your secret information decrypted using your password: <?= $_SESSION['usersecret'] ?></div><br>
<?php
  }
?>
<a href="logout.php">Log out</a>
</div>
</div>
<?php
}
else {
?>
<div class="container">

      <form class="form-signin" action="login.php" method="post">
        <h2 class="form-signin-heading">You should log in</h2>
        <label for="inputName" class="sr-only">Name</label>
        <input type="text" name="name" class="form-control" placeholder="Name"autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" name="password" class="form-control" placeholder="Password">
        <div class="checkbox">
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
<?php
  if (isset($_GET['error']) && $_GET['error'] == 'failed') {
?>
<br>
<div class="alert alert-danger" role="alert">
  Login failed
</div>

<?php
	}
?>
<?php
  if (isset($_GET['error']) && $_GET['error'] == 'failed2') {
?>
<br>
<div class="alert alert-danger" role="alert">
  Hacking attempt detected, police has been notified!!!
</div>

<?php
	}
?>

      </form>

    </div> <!-- /container -->


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="ie10-viewport-bug-workaround.js"></script>


<?php
}
?>
</body>
</html>
