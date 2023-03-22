<?php

  if(isset($_GET['host'])) {

    system("ping -c 3 ".$_GET['host'], $result_code);


    if($result_code == 0) {

      echo "<br/><br/>";
      echo "Host is alive!";
      echo "<br/><br/>";

    } else {

      echo "<br/><br/>";
      echo "Host is unreachable...";
      echo "<br/><br/>";

    }

  }

?>

<form action="ping.php">
Insert hostname: <input type="text" name="host"><br/>
<input type="submit" value="Submit">
</form>

