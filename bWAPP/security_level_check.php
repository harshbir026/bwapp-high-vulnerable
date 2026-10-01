<?php

/*

bWAPP, or a buggy web application, is a free and open source deliberately insecure web application.
It helps security enthusiasts, developers and students to discover and to prevent web vulnerabilities.
bWAPP covers all major known web vulnerabilities, including all risks from the OWASP Top 10 project!
It is for security-testing and educational purposes only.

Enjoy!

Malik Mesellem
Twitter: @MME_IT

bWAPP is licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (http://creativecommons.org/licenses/by-nc-nd/4.0/). Copyright © 2014 MME BVBA. All rights reserved.

*/

include("admin/settings.php");

$addresses = array();
@list($ip, $len) = explode('/', $AIM_subnet);

if(($min = ip2long($ip)) !== false)
{

    $max = ($min | (1<<(32-$len))-1);
    for($i = $min; $i < $max; $i++)
    $addresses[] = long2ip($i);

}

if(!(isset($_COOKIE["security_level"])) && !(in_array($_SERVER["REMOTE_ADDR"], $AIM_IPs)) && !(in_array($_SERVER["REMOTE_ADDR"], $addresses)))
{

    // High (2) is the hosted default on every endpoint until a level is chosen.
    $_COOKIE["security_level"] = "2";
    setcookie("security_level", "2", time()+60*60*24*365, "/", "", false, false);

}

?>