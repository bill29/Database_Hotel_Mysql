-----1: Show all hotels and cities belonging to the database
------  Because many of these will be used, we will use VIEW
CREATE VIEW HOTEL_CITY AS
     SELECT DISTINCT HOTEL.*,HOTEL_LOCATION.NAME_CITY
     FROM HOTEL,HOTEL_LOCATION
     WHERE HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL;
SELECT * FROM HOTEL_CITY;
---2 :Provide hotel information if you want to go to Shanghai, or TOKYO ...
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='SHANGHAI';
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE
     FROM HOTEL_CITY
     WHERE NAME_CITY='TOKYO';
---3 : Đưa ra 10 khách sạn tốt nhất tại 1 địa điểm , săp xếp theo điểm đánh gía của khách
-----Offering 10 best hotels at 1 location, arranged according to the guest rating
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='HA NOI' 
     ORDER BY REVIEW_RANK DESC LIMIT 10;
---4 : Như câu hỏi 3 nhưng là đánh gía theo 2 tiêu chí ,gía rẻ nhất , điểm review cao nhất, 
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='HA NOI' 
ORDER BY PRICE ASC , REVIEW_RANK DESC LIMIT 5;
---5 : Đưa ra các khách sạn như yêu cầu với đk khách sạn >4 sao, điểm review >=8 ở LONDON
------Offer the hotel as requested with hotel 4> star hotel, review point> = 8 in LONDON
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='LONDON'
AND REVIEW_RANK>=8 AND HOTEL_TYPE>=4; 
--6 : Như câu hỏi trên nhưng giới hạn 10 khách sạn và sắp xêp theo gí giảm dần
-----As per the question above but the 10-hotel limit is about to follow the descending order price
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='LONDON'
AND REVIEW_RANK>=8 AND HOTEL_TYPE>=4 ORDER by PRICE ASC LIMIT 10; 
--7 : Đưa ra gía tiền thấp nhất mà bạn phải trả nếu bạn muốn đến , ví dụ NEW YORK đưa ra tên khách sạn đó.
-----Give the lowest price you pay if you want to go somewhere, for example NEW YORK gives that hotel name.
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK'
AND PRICE<=ALL(SELECT PRICE FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK'); 
--8  : đưa ra gía trung bình của 1 loại khách sạn tại 1 thành phố : ví dụ NEW YORK , 4 SAO.
------Average price of 1 type of hotel in 1 city: example 4-star NEW YORK
SELECT AVG(PRICE), NAME_CITY FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK' AND HOTEL_TYPE=4;
--9 : Đưa ra các điểm đến của 1 thành phố do người dùng yêu cầu : ví dụ Lasvegas
------Given the popular locations of a city
SELECT  DISTINCT POPULAR_ADDRESS FROM HOTEL_LOCATION WHERE NAME_CITY='LAS VEGAS';
---10 : Đưa ra các khách sạn gần với địa điểm khách muốn đến nhất .
-------Show the hotels closest to the destination you want to visit.
 EXPLAIN SELECT ID_HOTEL,NAME_HOTEL FROM HOTEL_CITY WHERE ID_HOTEL IN( SELECT ID_HOTEL FROM HOTEL_LOCATION
WHERE HOTEL_LOCATION.POPULAR_ADDRESS ='AKIHABARA STATION' AND HOTEL_LOCATION.DISTANCE<= ALL(
	SELECT DISTANCE FROM HOTEL_LOCATION WHERE NAME_CITY='TOKYO' AND POPULAR_ADDRESS='AKIHABARA STATION'));
--10 cách 2 : liên kết 2 bảng hotel , hotel_location , rồi áp 1 loạt điều kiện
----link 2 tables of hotel, hotel_location, then apply conditions
EXPLAIN SELECT NAME_HOTEL FROM HOTEL ,HOTEL_LOCATION WHERE HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL AND
HOTEL_LOCATION.NAME_CITY='TOKYO' AND HOTEL_LOCATION.POPULAR_ADDRESS='AKIHABARA STATION' AND
DISTANCE<=ALL(SELECT DISTANCE FROM HOTEL_LOCATION WHERE NAME_CITY='TOKYO' AND 
POPULAR_ADDRESS='AKIHABARA STATION') ;
--- 11: ĐƯA RA CÁC KHÁCH SẠN TẠI 1 ĐỊA ĐIÊM , VÀ YÊU CÂÙ CÓ PHÒNG VÀO NGÀY XY;
--- Ví dụ Ha Noi , ngày 3/1/2018- 6/1/2018;
----Provide hotel information when there are places and dates

--- Example Ha Noi, March 3, 2018- 6/1/2018;
--- Tạo view
--- create view
CREATE VIEW HOTEL_ROOM_BOOKING_HANOI AS
SELECT HOTEL.*,HOTEL_LOCATION.NAME_CITY,ROOM.ID_ROOM,CHECK_IN,CHECK_OUT
FROM HOTEL,HOTEL_LOCATION,ROOM,ROOM_BOOKING
WHERE HOTEL_LOCATION.NAME_CITY='HA NOI' and HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL AND ROOM.ID_HOTEL=HOTEL.ID_HOTEL
AND ROOM.ID_HOTEL=ROOM_BOOKING.ID_HOTEL AND ROOM.ID_ROOM=ROOM_BOOKING.ID_ROOM;
------------ Use View
SELECT DISTINCT HOTEL_ROOM_BOOKING_HANOI.NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_ROOM_BOOKING_HANOI
WHERE (CHECK_IN >'2018-6-1' or  CHECK_OUT<'2018-3-1');
-----12 : Kết hợp với câu  11 tạo ra các câu khác như là :
----- Đưa ra thông tin các khách sạn thỏa mãn việc có phòng vào ngày x , đến ngày y , và gía phòng dưới 200
-----Combined with verse 11 create other sentences such as:
----- Provide information that hotels are satisfied with room availability on day x, date of y, and room rate below 200
SELECT DISTINCT HOTEL_ROOM_BOOKING_HANOI.NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_ROOM_BOOKING_HANOI
WHERE (CHECK_IN >'2018-6-1' or  CHECK_OUT<'2018-3-1') and PRICE<200;
----  : Bắt đầu từ câu này sẽ là các chức năng đưa ra các gợi ý cho người dùng khi họ không biết 
--------- đi đâu
-------------: Starting from this sentence will be functions that give suggestions to users when they don't know where to go
------14 Đưa ra gía trung bình/đêm của tất cả các thành phố 
------Average price / night of all cities
SELECT AVG(PRICE),NAME_CITY FROM HOTEL_CITY GROUP BY NAME_CITY;
-----15 Đưa ra 3 thành phố đắt nhất
------Giving 3 most expensive cities
SELECT AVG(PRICE) AS AVG,NAME_CITY FROM HOTEL_CITY GROUP BY NAME_CITY ORDER by AVG DESC LIMIT 3;
------16 Đưa ra các thành phố , tương ứng với các khách sạn đắt nhất của thành phố đó.
------ Offering cities, corresponding to the most expensive hotels of that city.
------17 : Đưa ra tổng các khách sạn mà chúng tôi có ở các thành phố thành phố ví dụ thượng hải ,
---------- LONDON, HANOI , TOKYO....
-------Given the total number of hotels we have in city cities, Shanghai example,
---------- LONDON, HANOI, TOKYO ....
SELECT COUNT(ID_HOTEL),NAME_CITY FROM HOTEL_CITY WHERE NAME_CITY in ('LONDON','SHANGHAI','TOKYO','HA NOI')
 GROUP BY NAME_CITY ;
 -----18 : Đưa ra khách sạn đông người thuê nhất ở Hà Nội tính đến thời điểm hiện tại.
---------Offering the most crowded hotel in Hanoi up to the present time.
 SELECT NAME_HOTEL, COUNT(CHECK_IN) AS SOLUOT FROM HOTEL_ROOM_BOOKING_HANOI GROUP BY NAME_HOTEL
  HAVING COUNT(CHECK_IN)>=ALL(
 	SELECT COUNT(CHECK_IN) FROM HOTEL_ROOM_BOOKING_HANOI GROUP BY NAME_HOTEL);
  ----19 : Đưa ra gợi ý những địa điểm đông người đi nhất trong năm nay
--------Suggest the most crowded places this year

  SELECT NAME_CITY,COUNT(CHECK_IN) AS SOLUOT FROM HOTEL_LOCATION,ROOM_BOOKING
  WHERE HOTEL_LOCATION.ID_HOTEL=ROOM_BOOKING.ID_HOTEL GROUP BY NAME_CITY 
  HAVING COUNT(CHECK_IN)>=ALL(SELECT COUNT(CHECK_IN) FROM HOTEL_LOCATION,ROOM_BOOKING
  WHERE HOTEL_LOCATION.ID_HOTEL=ROOM_BOOKING.ID_HOTEL GROUP BY NAME_CITY );
  ---20 : Cập nhật gía tất cả các khách sạn tại 1 thành phố ví dụ tp HO CHI MINH
--------Update prices of all hotels in 1 city, for example HO CHI MINH
  UPDATE HOTEL
  SET PRICE=PRICE*0.95
  WHERE HOTEL.ID_HOTEL IN( SELECT ID_HOTEL FROM HOTEL_LOCATION WHERE NAME_CITY='HO CHI MINH CITY');
  ----21 : Đưa ra các khách sạn mà bạn có thể thanh toán bằng đối tác PAYPAL tai LAS VEGAS
---------Offer hotels that you can pay with PAYPAL partners at LAS VEGAS
---------Offer hotels that you can pay with PAYPAL partners at LAS VEGAS
  SELECT NAME_HOTEL FROM PAY,HOTEL_CITY WHERE HOTEL_CITY.ID_HOTEL=PAY.ID_HOTEL AND NAME_PAY='PAYPAL' AND
  NAME_CITY='LAS VEGAS';
  ----22 :  Đưa ra các đối tác thanh toán va số lượng các khách sạn sử dụng .
---------Provide payment partners and the number of hotels used.
--------
  SELECT NAME_PAY , count(PAY.ID_HOTEL) from PAY,HOTEL_CITY WHERE HOTEL_CITY.ID_HOTEL=PAY.ID_HOTEL 
  GROUP BY NAME_PAY;-----1: Đưa ra tất cả các khách sạn và thành phố thuộc cơ sở dữ liệu
------  Vì sẽ sử dụng nhiều cái này nên ta sẽ dùng VIEW
CREATE VIEW HOTEL_CITY AS
     SELECT DISTINCT HOTEL.*,HOTEL_LOCATION.NAME_CITY
     FROM HOTEL,HOTEL_LOCATION
     WHERE HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL;
    ---10 Câu truy vấn đầu tiên sẽ là khách đã biết điểm đến và đưa ra dữ liệu theo yêu cầu
SELECT * FROM HOTEL_CITY;
------ Từ VIEW này ta sẽ dùng để giải một số câu khác nữa.
---2 : Đưa ra các khách sạn nếu bạn muốn đến Thượng Hải, hoặc là TOKYO...
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='SHANGHAI';
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE
     FROM HOTEL_CITY
     WHERE NAME_CITY='TOKYO';
---3 : Đưa ra 10 khách sạn tốt nhất tại 1 địa điểm , săp xếp theo điểm đánh gía của khách
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='HA NOI' 
     ORDER BY REVIEW_RANK DESC LIMIT 10;
---4 : Như câu hỏi 3 nhưng là đánh gía theo 2 tiêu chí ,gía rẻ nhất , điểm review cao nhất, 
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='HA NOI' 
ORDER BY PRICE ASC , REVIEW_RANK DESC LIMIT 5;
---5 : Đưa ra các khách sạn như yêu cầu với đk khách sạn >4 sao, điểm review >=8 ở LONDON
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='LONDON'
AND REVIEW_RANK>=8 AND HOTEL_TYPE>=4; 
--6 : Như câu hỏi trên nhưng giới hạn 10 khách sạn và , sắp xêp theo gía giảm dần
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='LONDON'
AND REVIEW_RANK>=8 AND HOTEL_TYPE>=4 ORDER by PRICE ASC LIMIT 10; 
--7 : Đưa ra gía tiền thấp nhất mà bạn phải trả nếu bạn muốn đến , ví dụ NEW YORK đưa ra tên khách sạn đó.
SELECT NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK'
AND PRICE<=ALL(SELECT PRICE FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK'); 
--8  : đưa ra gía trung bình của 1 loại khách sạn tại 1 thành phố : ví dụ NEW YORK , 4 SAO.
SELECT AVG(PRICE), NAME_CITY FROM HOTEL_CITY WHERE NAME_CITY='NEW YORK' AND HOTEL_TYPE=4;
--9 : Đưa ra các điểm đến của 1 thành phố do người dùng yêu cầu : ví dụ Lasvegas
SELECT  DISTINCT POPULAR_ADDRESS FROM HOTEL_LOCATION WHERE NAME_CITY='LAS VEGAS';
---10 : Đưa ra các khách sạn gần với địa điểm khách muốn đến nhất .
 EXPLAIN SELECT ID_HOTEL,NAME_HOTEL FROM HOTEL_CITY WHERE ID_HOTEL IN( SELECT ID_HOTEL FROM HOTEL_LOCATION
WHERE HOTEL_LOCATION.POPULAR_ADDRESS ='AKIHABARA STATION' AND HOTEL_LOCATION.DISTANCE<= ALL(
	SELECT DISTANCE FROM HOTEL_LOCATION WHERE NAME_CITY='TOKYO' AND POPULAR_ADDRESS='AKIHABARA STATION'));
--Do khoảng cách bằng nhau nên ta mới có nhiều hotel.
--10 cách 2 : liên kết 2 bảng hotel , hotel_location , rồi áp 1 loạt điều kiện
EXPLAIN SELECT NAME_HOTEL FROM HOTEL ,HOTEL_LOCATION WHERE HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL AND
HOTEL_LOCATION.NAME_CITY='TOKYO' AND HOTEL_LOCATION.POPULAR_ADDRESS='AKIHABARA STATION' AND
DISTANCE<=ALL(SELECT DISTANCE FROM HOTEL_LOCATION WHERE NAME_CITY='TOKYO' AND 
POPULAR_ADDRESS='AKIHABARA STATION') ;
--- 11: ĐƯA RA CÁC KHÁCH SẠN TẠI 1 ĐỊA ĐIÊM , VÀ YÊU CÂÙ CÓ PHÒNG VÀO NGÀY XY;
--- Ví dụ Ha Noi , ngày 3/1/2018- 6/1/2018;
--- Tạo view
CREATE VIEW HOTEL_ROOM_BOOKING_HANOI AS
SELECT HOTEL.*,HOTEL_LOCATION.NAME_CITY,ROOM.ID_ROOM,CHECK_IN,CHECK_OUT
FROM HOTEL,HOTEL_LOCATION,ROOM,ROOM_BOOKING
WHERE HOTEL_LOCATION.NAME_CITY='HA NOI' and HOTEL.ID_HOTEL=HOTEL_LOCATION.ID_HOTEL AND ROOM.ID_HOTEL=HOTEL.ID_HOTEL
AND ROOM.ID_HOTEL=ROOM_BOOKING.ID_HOTEL AND ROOM.ID_ROOM=ROOM_BOOKING.ID_ROOM;
------------ Sử dụng View
SELECT DISTINCT HOTEL_ROOM_BOOKING_HANOI.NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_ROOM_BOOKING_HANOI
WHERE (CHECK_IN >'2018-6-1' or  CHECK_OUT<'2018-3-1');
-----12 : Kết hợp với câu  11 tạo ra các câu khác như là :
----- Đưa ra thông tin các khách sạn thỏa mãn việc có phòng vào ngày x , đến ngày y , và gía phòng dưới 200
SELECT DISTINCT HOTEL_ROOM_BOOKING_HANOI.NAME_HOTEL,PRICE,REVIEW_RANK,HOTEL_TYPE FROM HOTEL_ROOM_BOOKING_HANOI
WHERE (CHECK_IN >'2018-6-1' or  CHECK_OUT<'2018-3-1') and PRICE<200;
----  : Bắt đầu từ câu này sẽ là các chức năng đưa ra các gợi ý cho người dùng khi họ không biết 
--------- đi đâu
------14 Đưa ra gía trung bình/đêm của tất cả các thành phố 
SELECT AVG(PRICE),NAME_CITY FROM HOTEL_CITY GROUP BY NAME_CITY;
-----15 Đưa ra 3 thành phố đắt nhất
SELECT AVG(PRICE) AS AVG,NAME_CITY FROM HOTEL_CITY GROUP BY NAME_CITY ORDER by AVG DESC LIMIT 3;
------16 Đưa ra các thành phố , tương ứng với các khách sạn xịn nhất của thành phố đó.
------17 : Đưa ra tổng các khách sạn mà chúng tôi có ở các thành phố thành phố ví dụ thượng hải ,
---------- LONDON, HANOI , TOKYO....
SELECT COUNT(ID_HOTEL),NAME_CITY FROM HOTEL_CITY WHERE NAME_CITY in ('LONDON','SHANGHAI','TOKYO','HA NOI')
 GROUP BY NAME_CITY ;
 -----18 : Đưa ra khách sạn đông người thuê nhất ở Hà Nội tính đến thời điểm hiện tại.
 SELECT NAME_HOTEL, COUNT(CHECK_IN) AS SOLUOT FROM HOTEL_ROOM_BOOKING_HANOI GROUP BY NAME_HOTEL
  HAVING COUNT(CHECK_IN)>=ALL(
 	SELECT COUNT(CHECK_IN) FROM HOTEL_ROOM_BOOKING_HANOI GROUP BY NAME_HOTEL);
  ----19 : Đưa ra gợi ý những địa điểm đông người đi nhất trong năm nay
  SELECT NAME_CITY,COUNT(CHECK_IN) AS SOLUOT FROM HOTEL_LOCATION,ROOM_BOOKING
  WHERE HOTEL_LOCATION.ID_HOTEL=ROOM_BOOKING.ID_HOTEL GROUP BY NAME_CITY 
  HAVING COUNT(CHECK_IN)>=ALL(SELECT COUNT(CHECK_IN) FROM HOTEL_LOCATION,ROOM_BOOKING
  WHERE HOTEL_LOCATION.ID_HOTEL=ROOM_BOOKING.ID_HOTEL GROUP BY NAME_CITY );
  ---20 : Cập nhật gía tất cả các khách sạn tại 1 thành phố ví dụ tp HO CHI MINH
  UPDATE HOTEL
  SET PRICE=PRICE*0.95
  WHERE HOTEL.ID_HOTEL IN( SELECT ID_HOTEL FROM HOTEL_LOCATION WHERE NAME_CITY='HO CHI MINH CITY');
  ----21 : Đưa ra các khách sạn mà bạn có thể thanh toán bằng đối tác PAYPAL tai LAS VEGAS
  SELECT NAME_HOTEL FROM PAY,HOTEL_CITY WHERE HOTEL_CITY.ID_HOTEL=PAY.ID_HOTEL AND NAME_PAY='PAYPAL' AND
  NAME_CITY='LAS VEGAS';
  ----22 :  Đưa ra các đối tác thanh toán va so luong khách sạn su dung .
  SELECT NAME_PAY , count(PAY.ID_HOTEL) from PAY,HOTEL_CITY WHERE HOTEL_CITY.ID_HOTEL=PAY.ID_HOTEL 
  GROUP BY NAME_PAY;
  ---- Đưa ra mức phân quyền , người sử dụng chỉ có quyền select tới các bảng là : hotel , pay , loaction,
  ---- Người quản lý được truy vấn , cập nhật với tất cả các bảng
  ---- Admin mới có toàn quyền truy vấn xóa xửa tất cả các bảng
  
