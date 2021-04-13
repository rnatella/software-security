## Session Hijacking
Session hijacking is one of the many security exploits a website or web application can have. Session hijacking is when an attacker steals the session ID of a valid user and uses this session ID to send fraudulent request to the server and grant unauthorized access.

A simple session ID regeneration when user privileges change (from regular visitor to logged in user for example) can prevent this. This is often overlooked or forgotten hence a nice reminder. It is one of the several methods to prevent session hijacking and session fixation.

Uncomment the line

    session_regenerate_id(true);
    
in index.php and logout.php and see how session ID changes every time you login and logout from the system. This makes it difficult for the attacker to exploit the stolen session ID.

Here are screenshots of successfully performed session hijacking and granting unauthorized access. I'm using <a href="https://www.getpostman.com/" target="_blank">Postman</a> to send requests with the hijacked session ID.

1

![Url](https://i.imgur.com/LiG9Z8H.png)

2
![Url](https://i.imgur.com/Du6R2hZ.png)

3 Now let's login using admin/admin as username/password combination (notice how the session ID is the same all the time)
![Url](https://i.imgur.com/wpOfNJY.png)

4 Sending request via Postman this time. Notice the session ID is different since this is a different request and we're not allowed to view the admin page.
![Url](https://i.imgur.com/1eSAeBL.png)

5 
![Url](https://i.imgur.com/9ZawDj2.png)

6 
![Url](https://i.imgur.com/ie2qZmJ.png)

7 We send the request again and this time we see the admin page
![Url](https://i.imgur.com/ucJNASn.png)