<?php

if(isset($_GET['image_url'])) {

  $url = $_GET['image_url'];

  # Fetch the image from the user supplied URL
  $file = fopen($url, 'rb');

  # Dump image file,
  # send proper header for png images
  header("Content-Type: image/png");
  fpassthru($file);

} else {

  # Ask user to enter image URL

  echo '<form>';
  echo 'Enter image URL: <input type="text" name="image_url"><br/><br/>';
  echo '<input type="submit" value="Submit">';
  echo '</form>';

}

?>
