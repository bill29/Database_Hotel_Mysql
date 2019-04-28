# **Hotel Database Mysql**
This is a project for database course. It simulates the database of trivago website. However it's simple. 
## Who use 
Students who want to improve their Database skills. You can refer to ways to solve problems about a hotel website like trivago.
# Install
[Install MySQL server on ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04)

[Install MySQL server on Windows10](https://www.onlinetutorialspoint.com/mysql/install-mysql-on-windows-10-step-by-step.html)

[Install MySQL server on MacOS](https://tableplus.io/blog/2018/11/how-to-download-mysql-mac.html)

After installing Mysql server.
 
```
mysql -u username -p
CREATE DATABASE trivago;
USE trivago;
CREATE TABLE example ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );
INSERT INTO example ( id, name ) VALUES ( null, 'Sample data' );

```
## Relational entity model 
![](https://images.viblo.asia/0a6fbd1e-42b0-4ee3-b700-92ec0844b7d2.png)

## Query
After installing database and creating Trigger and creating table, insert data in order of hotel, hotel_location, Room, booking, pay
Try running the Query command:
eg:
![](https://images.viblo.asia/5aee93d9-6820-4319-b619-b61dab2da156.png)
# Plan :
Because there is not much time in the school year. Therefore, in order to complete the Project, I will create an online hotel booking website.
I promise to finish it by the summer of 2019.
