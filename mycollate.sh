#!/bin/bash

# mycollate.sh <database> [<charset> <collation>]
# changes MySQL/MariaDB charset and collation for one database - all tables and
# all columns in all tables

DB="$1"
CHARSET="$2"
COLL="$3"

[ -n "$DB" ] || exit 1
[ -n "$CHARSET" ] || CHARSET="utf8mb4"
[ -n "$COLL" ] || COLL="utf8mb4_general_ci"

echo $DB
echo "ALTER DATABASE \`$DB\` CHARACTER SET $CHARSET COLLATE $COLL;" | mysql

echo "USE \`$DB\`; SHOW TABLES;" | mysql -s | (
    while read TABLE; do
        echo $DB.$TABLE
        echo "ALTER TABLE \`$TABLE\` CONVERT TO CHARACTER SET $CHARSET COLLATE $COLL;" | mysql $DB
    done
)
