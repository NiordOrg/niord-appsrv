
CREATE DATABASE niord CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER 'niord'@'localhost' IDENTIFIED BY 'niord';
GRANT ALL PRIVILEGES ON *.* TO 'niord'@'localhost' WITH GRANT OPTION;
CREATE USER 'niord'@'%' IDENTIFIED BY 'niord';
GRANT ALL PRIVILEGES ON *.* TO 'niord'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


