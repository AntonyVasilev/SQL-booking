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

select 
	property_name as name,
	'property type',
	'country',
	'city',
	address,
	rating