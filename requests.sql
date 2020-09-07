-- Вывести все отзывы об указанном объекте размещения

set @user = 18;
select * from reviews where property_id = @user;


-- Вывести все сообщения указанному пользователю без статуса "прочитано"

set @user = 5;
select * from messages where to_user_id = @user and status = 'sent';


-- Вывести количество объектов размещения в каждом городе

select
	c2.name as 'country',
    c.name as 'city',
    count(p.id) as 'count'
from properties as p
join cities as c on c.id = p.city_id
join countries as c2 on c2.id = c.country_id 
group by p.city_id
order by c2.name;


-- Вывести все бронирования пользователя

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
where b.user_id = '5';


-- Вывести все объекты размещения в стране с указаным типом кроватей

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
where bt.bed_type rlike 'single_bed';  -- использую rlike, т.к. при заполненении таблицы в названии могут встречаться пробелы в начале


-- Вывести последние 10 зарегистированных отелей

select pr.*
from properties as pr
join property_types as pt on pt.id = pr.property_type_id
where pt.name rlike 'hotel' -- использую rlike, т.к. при заполненении таблицы в названии могут встречаться пробелы в начале
order by created_at desc
limit 10; 