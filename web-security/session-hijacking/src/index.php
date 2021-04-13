<?php session_start(); ?>
<?php
if(isset($_SESSION["admin"]))
{
    header("Location: admin.php");
    exit();
}

if(isset($_POST["username"], $_POST["password"]))
{
    $username = htmlentities($_POST["username"]);
    $password = htmlentities($_POST["password"]);

    if($username == "admin" && $password == "admin")
    {
        //session_regenerate_id(true);  //uncomment this line for improved session security
        $_SESSION["admin"] = array(
          "user" => $username,
        );
        header("Location: admin.php");
        exit();
    } else { echo "<div style='color: red'>Incorrect username / password.</div>"; }
}
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Login</title>
</head>
<body>
<?php echo "Session ID: " . session_id(); ?><hr/>
<form method="post">
    <p>Username: <input type="text" name="username" /></p>
    <p>Password: <input type="password" name="password" /></p>
    <input type="submit" value="Login" />
</form>
</body>
</html>
