USE booking;

-- Вывести все отзывы об указанном объекте размещения

set @user = 1;
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


-- Вывести последние 2 зарегистированных отеля

select 
    pr.property_name as 'hotel name',
    pt.name as 'type',
    c.name as 'city',
    pr.address as 'address',
    pr.rating as 'rating'
from properties as pr
join property_types as pt on pt.id = pr.property_type_id
join cities as c on c.id = pr.city_id
where pt.id = 5
limit 2; 