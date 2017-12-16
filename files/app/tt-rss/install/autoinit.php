<?php
    function db_connect($host, $user, $pass, $db, $type, $port = false) {
        if ($type == "pgsql") {

            $string = "dbname=$db user=$user";

            if ($pass) {
                $string .= " password=$pass";
            }

            if ($host) {
                $string .= " host=$host";
            }

            if ($port) {
                $string = "$string port=" . $port;
            }

            $link = pg_connect($string);

            return $link;

        } else if ($type == "mysql") {
            if ($port)
                return mysqli_connect($host, $user, $pass, $db, $port);
            else
                return mysqli_connect($host, $user, $pass, $db);
        }
    }
    
    function db_query($link, $query, $type, $die_on_error = true) {
        if ($type == "pgsql") {
            $result = pg_query($link, $query);
            if (!$result) {
                $query = htmlspecialchars($query); // just in case
                if ($die_on_error) {
                    die("Query <i>$query</i> failed [$result]: " . ($link ? pg_last_error($link) : "No connection"));
                }
            }
            return $result;
        } else if ($type == "mysql") {

            $result = mysqli_query($link, $query);

            if (!$result) {
                $query = htmlspecialchars($query);
                if ($die_on_error) {
                    die("Query <i>$query</i> failed: " . ($link ? mysqli_error($link) : "No connection"));
                }
            }
            return $result;
        }
    }

    require "/app/tt-rss/config.php";

    @$DB_HOST = DB_HOST;
    @$DB_TYPE = DB_TYPE;
    @$DB_USER = DB_USER;
    @$DB_NAME = DB_NAME;
    @$DB_PASS = DB_PASS;
    @$DB_PORT = DB_PORT;
    @$SELF_URL_PATH = SELF_URL_PATH;

    $link = db_connect($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $DB_TYPE, $DB_PORT);
    $result = @db_query($link, "SELECT true FROM ttrss_feeds", $DB_TYPE, false);
    if ($result) {
        print("tt-rss tables is exists.");
    } else {
        $lines = explode(";", preg_replace("/[\r\n]/", "", file_get_contents("/app/tt-rss/schema/ttrss_schema_".$DB_TYPE.".sql")));

        foreach ($lines as $line) {
            if (strpos($line, "--") !== 0 && $line) {
                db_query($link, $line, $DB_TYPE);
            }
        }

        print("Database initialization completed.");
    }
?>