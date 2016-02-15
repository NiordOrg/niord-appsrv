
CREATE DATABASE niordkc CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER 'niordkc'@'localhost' IDENTIFIED BY 'niordkc';
GRANT ALL PRIVILEGES ON *.* TO 'niordkc'@'localhost' WITH GRANT OPTION;
CREATE USER 'niordkc'@'%' IDENTIFIED BY 'niordkc';
GRANT ALL PRIVILEGES ON *.* TO 'niordkc'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


