<?php
session_start();

echo "Session ID: " . session_id() . "<hr/>";
if(!isset($_SESSION["admin"]))
{
    echo "<h1 style='color: red;'>You are not authorized to view this page.</h1> <a href='index.php'>Back to login</a>";
}
else
{
    echo "<h2>You are logged in as " . $_SESSION["admin"]["user"] . " and you have been granted access.</h2>";
    echo "<a href='logout.php'>Logout</a>";
}
