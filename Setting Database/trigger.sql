DELIMITER $$
CREATE TRIGGER check_in_out BEFORE INSERT ON ROOM_BOOKING
FOR EACH ROW
BEGIN
         IF NEW.ID_ROOM in (
                    select ID_ROOM
                    From ROOM_BOOKING
                    where (NEW.ID_ROOM = ROOM_BOOKING.ID_ROOM AND NEW.ID_HOTEL=ROOM_BOOKING.ID_HOTEL)
            ) THEN
                 IF EXISTS (
                        select *
                        from ROOM_BOOKING
                        where (NEW.CHECK_IN > ROOM_BOOKING.CHECK_IN and NEW.CHECK_IN < ROOM_BOOKING.CHECK_OUT) OR (NEW.CHECK_OUT>ROOM_BOOKING.CHECK_IN AND NEW.CHECK_OUT<ROOM_BOOKING.CHECK_OUT)
                 ) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR !!!';
                 END IF;
         END IF;
 END$$
 delimiter $$
create trigger check_date before INSERT ON ROOM_BOOKING 
  for each row 
   begin  
    if  new.CHECK_IN>=NEW.CHECK_OUT then
        SIGNAL SQLSTATE '45000'   
        SET MESSAGE_TEXT = 'Cannot insert hihi ';
      end if; 
      end; 
      $$
delimiter $$
create trigger check_hotel_2 before INSERT ON HOTEL 
  for each row 
   begin  
    if  (NEW.REVIEW_RANK<0 OR NEW.REVIEW_RANK >10) OR (NEW.HOTEL_TYPE<0 OR NEW.HOTEL_TYPE>5) then
        SIGNAL SQLSTATE '45000'   
        SET MESSAGE_TEXT = 'Cannot insert hihi ';
      end if; 
      end; 
      $$
