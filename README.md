# **Hotel Database Mysql**
This is a project for database course. It simulates the database of trivago website. However it's simple. 
## Who use 
Students who want to improve their Database skills. You can refer to ways to solve problems about a hotel website like trivago.
# Install
install mysql ([](https://www.tutorialspoint.com/mysql/mysql-installation.htm))
```
mysql -u username -p
CREATE DATABASE trivago;
USE trivago;
CREATE TABLE example ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );
INSERT INTO example ( id, name ) VALUES ( null, 'Sample data' );

```
## Relational entity model## 
![](https://images.viblo.asia/f2081afb-1116-47c3-b685-2f07746d4169.jpg)
## Query
After installing database and creating Trigger and creating table, insert data in order of hotel, hotel_location, Room, booking, pay
Try running the Query command:
eg:
![](https://images.viblo.asia/5aee93d9-6820-4319-b619-b61dab2da156.png)

