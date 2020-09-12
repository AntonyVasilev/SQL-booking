USE booking;

-- Тригеры, проверяющие, что дата начала и окончания бронирования находится в будущем.
-- Если даты в прошлом, то устанавливают датой начала бронирования - текущую, а окончания - завтрашнюю.

delimiter //

drop trigger if exists check_insert_from_date//
create trigger check_insert_from_date before insert on booking.bookings 
for each row
begin
	if NEW.booked_from_date < CURRENT_DATE() THEN 
		set NEW.booked_from_date = CURRENT_DATE(); 
	end if;
end//

drop trigger if exists check_update_from_date//
create trigger check_update_from_date before update on booking.bookings 
for each row
begin 
	if NEW.booked_from_date < CURRENT_DATE() THEN 
		set NEW.booked_from_date = CURRENT_DATE();
	end if;
end//

drop trigger if exists check_insert_till_date//
create trigger check_insert_till_date before insert on booking.bookings 
for each row
begin
	if NEW.booked_till_date < CURRENT_DATE() THEN 
		set NEW.booked_till_date = (CURRENT_DATE() + interval 1 DAY);
	end if;
end//

drop trigger if exists check_update_till_date//
create trigger check_update_till_date before update on booking.bookings 
for each row
begin
	if NEW.booked_till_date < CURRENT_DATE() THEN 
		set NEW.booked_till_date = (CURRENT_DATE() + interval 1 DAY);
	end if;
end//

delimiter ;

/*insert into bookings (user_id, property_id, room_type_id, room_count, booked_from_date, booked_till_date, book_type)
values ('5', '8', '1', '1', '2020-08-15', '2020-08-20', 'requested');

set @insert_id = LAST_INSERT_ID(); 

update bookings 
set booked_from_date = '2020-11-15', 
	booked_till_date = '2020-11-20'
where id = @insert_id;

update bookings 
set booked_from_date = '2020-08-15', 
	booked_till_date = '2020-08-20'
where id = @insert_id;
*/


-- Тригер, запрещающий изменение города и/или адреса нахождения объекта размещения

drop trigger if exists check_update_property_city_address;

delimiter //

create trigger check_update_property_city_address before update on booking.properties
for each row
begin
	if NEW.city_id <> OLD.city_id or NEW.address <> OLD.address then
		SIGNAL SQLSTATE '45000' SET message_text = 'Update canceled. You can\'t change property location!';
	end if;
end//

delimiter ;

/*
update properties 
Stashed changes
set city_id = '5'
where id = '1';

update properties 
set address = '56794 Marianne Squares Suite 186 Sarinatown, WY 23946'
where id = '3';

update properties 
set address = '56794 Marianne Squares Suite 186 Sarinatown, WY 23946',
	city_id = '5'
where id = '3';
*/