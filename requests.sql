-- Вывести все отзывы об указанном отеле

set @user = 18;
select * from reviews where property_id = @user;


-- Вывести все сообщения указанному пользователю без статуса "прочитано"

set @user = 5;
select * from messages where to_user_id = @user and status = 'sent';


-- Вывести количество бронирований, совершенных мужчинами и женщинами

select 
	'male',
	count(id) as count 
from bookings
where user_id in
(select id from users where gender = 'm')
union 
select 
	'female',
	count(id) as count 
from bookings
where user_id in
(select id from users where gender = 'f');


-- Вывести информацию об отелях в указанном городе

set @city = 'Port Rubiemouth';
select 
	id as hotel_id,
	property_name as name,
	(select name from property_types where id = (select property_type_id from properties where id = hotel_id)) as 'property type',
	(select name from countries where id = (select country_id from properties where id = hotel_id)) as country,
	(select name from cities where id = (select city_id from properties where id = hotel_id)) as city,
	address,
	rating,
	(select room_count from property_profiles where property_id = hotel_id) as 'room count',
	(select property_facilities from property_profiles where property_id = hotel_id) as 'property facilities',
	(select languages_spoken from property_profiles where property_id = hotel_id) as 'languages spoken',
	(select bank_cards_allowed from property_profiles where property_id = hotel_id) as 'bank cards allowed',
	(select meals from property_profiles where property_id = hotel_id) as 'meals'
from properties
where city_id in (select id from cities where name = @city);