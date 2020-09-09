USE booking;

-- Тригеры, проверяющий, что дата начала и окончания бронирования находится в будущем.
-- Если даты в прошлом, то устанавливает датой начала бронирования - текущую, а окончания - завтрашнюю.

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

insert into bookings (user_id, property_id, room_type_id, room_count, booked_from_date, booked_till_date, book_type)
values ('5', '8', '1', '1', '2020-08-15', '2020-08-20', 'requested');