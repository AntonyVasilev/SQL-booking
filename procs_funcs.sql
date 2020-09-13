USE booking;

-- Добавление пользователя

drop procedure if exists add_user;

delimiter //

create procedure add_user(firstname VARCHAR(50), lastname VARCHAR(50), email VARCHAR(120), password_hash VARCHAR(100), 
phone BIGINT, genger CHAR(1), OUT transaction_result VARCHAR(200))
begin
	declare is_rollback BOOL default 0;
	declare code VARCHAR(80);
	declare error_text VARCHAR(130);
	
	declare continue handler for sqlexception
	begin
		set is_rollback = 1;
		get stacked diagnostics condition 1
			code = RETURNED_SQLSTATE, error_text = MESSAGE_TEXT;
		set transaction_result = concat (code, '; ', error_text);
	end;
	
	start transaction;
		insert into users (firstname, lastname, email, password_hash, phone, gender)
		values (firstname, lastname, email, password_hash, phone, genger);
		
	if is_rollback then
		ROLLBACK;
	else
		set transaction_result = 'Transaction complete.';
		COMMIT;
	end if;
end//

delimiter ;

/*
call add_user('John', 'Doe', 'johndoe@example.com', '1be548f4b7d4738743800078e7e1bee9bd5aec11ac', 
			'44986789543', 'm', @transaction_result);
select @transaction_result;
*/


-- Добавление объекта размещения

drop procedure if exists add_property;

delimiter //

create procedure add_property(user_id bigint, property_name varchar(100), property_type_id tinyint, city_id int, 
				address varchar(255), room_type_id smallint, room_count smallint, property_facilities varchar(255), 
				languages_spoken varchar(255), bank_cards_allowed varchar(255), meals varchar(255), OUT transaction_result VARCHAR(200))
begin
	declare is_rollback BOOL default 0;
	declare code VARCHAR(80);
	declare error_text VARCHAR(130);
	
	declare continue handler for sqlexception
	begin
		set is_rollback = 1;
		get stacked diagnostics condition 1
			code = RETURNED_SQLSTATE, error_text = MESSAGE_TEXT;
		set transaction_result = concat (code, '; ', error_text);
	end;
	
	start transaction;
		insert into properties (user_id, property_name, property_type_id, city_id, address)
		values (user_id, property_name, property_type_id, city_id, address);
	
		insert into property_profiles (property_id, room_type_id, room_count, property_facilities, 
				languages_spoken, bank_cards_allowed, meals)
		values (last_insert_id(), room_type_id, room_count, (property_facilities), 
				(languages_spoken), (bank_cards_allowed), (meals));
		
	if is_rollback then
		ROLLBACK;
	else
		set transaction_result = 'Transaction complete.';
		COMMIT;
	end if;
end//

delimiter ;

/*
call add_property('26','undeground','1','3','56794 Marianne Squares Suite 186 Sarinatown, WY 23946','1','142',
			'lift,24-hour_front_desk,pets_allowed,luggage_storage','english,spanish,italian,dutch,french,russian',
			'visa,mastercard','breakfast,dinner', @transaction_result);
select @transaction_result;
*/


-- Выводит информацию об объектах размещения в указанном городе

drop procedure if exists properties_in_city;

delimiter //

create procedure properties_in_city (for_city VARCHAR(50))
begin
    select 
        pr.id as 'id',
        pr.property_name as 'name',
        pts.`name` as 'property type',
        cn.`name` as 'country',
        c.`name` as 'city',
        pr.address as 'adress',
        pr.rating as 'rating',
        prf.room_count as 'room count',
        prf.property_facilities as 'property facilities',
        prf.languages_spoken as 'languages spoken',
        prf.bank_cards_allowed as 'bank cards allowed',
        prf.meals as 'meals'
    from properties as pr
    join cities as c on c.id = pr.city_id
    join property_types as pts on pts.id = pr.property_type_id
    join countries as cn on cn.id = c.country_id 
    join property_profiles as prf on prf.property_id = pr.id
    where c.`name` = for_city;
end//

delimiter ;

-- call properties_in_city('Littelton');


-- Выводит все объекты размещения в стране с указаным типом кроватей


drop procedure if exists properties_by_bed;

delimiter //

create procedure properties_by_bed (bed_type VARCHAR(50))
begin
	select
		pr.property_name as 'property name',
    	pt.name as 'property type',
    	rt.room_type as 'room type',
    	bt.bed_type as 'bed type',
    	ct.name as 'city',
    	co.name as 'country'
	from properties as pr
	join property_types as pt on pt.id = pr.property_type_id
	join property_profiles as pp on pp.property_id = pr.id
	join room_types as rt on rt.id = pp.room_type_id
	join bed_types as bt on bt.id = rt.bed_type_id
	join cities as ct on ct.id = pr.city_id
	join countries as co on co.id = ct.country_id 
	where bt.bed_type rlike bed_type;  -- использую rlike, т.к. при заполненении таблицы в названии могут встречаться пробелы в начале
end//

delimiter ;

-- call properties_by_bed('single_bed');


-- Выводит все бронирования пользователя

drop procedure if exists user_bookings;

delimiter //

create procedure user_bookings (user_id BIGINT)
begin
	select
		concat(u.firstname, ' ', lastname) as 'user name',
    	u.email as 'e-mail',
    	pr.property_name as 'hotel name',
    	rt.room_type as'room type',
    	b.room_count as 'room count',
    	b.booked_from_date as 'check in date',
		b.booked_till_date as 'check out date',
    	b.book_type as 'booking status'
	from bookings as b
	join users as u on u.id = b.user_id
	join properties as pr on pr.id = b.property_id
	join room_types as rt on rt.id = b.room_type_id
	where b.user_id = user_id;
end//

delimiter ;

-- call user_bookings(5);


-- Функция подсчета количества подтвержденных бронирований за последние 2 года для конкретного пользователя 
-- для последущего присвоения ему статуса Genius. Программа лояльности Genius в данной БД не реализована.

drop function if exists genius_status_count;

delimiter //

create function genius_status_count (for_user BIGINT)
returns INT READS SQL DATA
begin
    declare bookings_count INT;
    
    set bookings_count = (select count(*)
    from bookings as b
    where b.user_id = for_user 
    and b.book_type = 'confirmed'
    and (b.booked_till_date + interval 2 year) < now()); 

    return bookings_count;
end//

delimiter ;

-- select genius_status_count(2);
