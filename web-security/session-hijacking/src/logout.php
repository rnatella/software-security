<?php
session_start();
//session_regenerate_id(true);  //uncomment this line for improved session security
session_unset();
session_destroy();
header("Location: index.php");
exit();
