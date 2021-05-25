#!/bin/sh


mysql -u root -e "CREATE DATABASE scada;"
#mysql -u root -D sirs -e "CREATE TABLE exams(id INT AUTO_INCREMENT PRIMARY KEY, question TEXT, answer TEXT, publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP);"

#mysql -u root -D sirs -e "INSERT INTO exams(question, answer, publish_date) VALUES ('Should we implement a firewall to protect them from students?', 'Definitely!', now() + interval 180 day);"

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root' IDENTIFIED BY 'password';"
mysql -u root -ppassword -e "SELECT 1;"
mysql -u root -ppassword -D scada -e "CREATE TABLE candeeiros (firstname VARCHAR(30) NOT NULL, lastname VARCHAR(30) NOT NULL)"
mysql -u root -ppassword -D scada -e "INSERT INTO candeeiros (firstname, lastname) VALUES ('Fábio', 'Sousa')"
mysql -u root -ppassword -D scada -e "INSERT INTO candeeiros (firstname, lastname) VALUES ('Pedro', 'Godinho')"
mysql -u root -ppassword -D scada -e "INSERT INTO candeeiros (firstname, lastname) VALUES ('Samuel', 'Barata')"
