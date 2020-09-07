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


-- Вывести последние 10 зарегистированных отелей

select pr.*
from properties as pr
join property_types as pt on pt.id = pr.property_type_id
where pt.name rlike 'hotel' -- использую rlike, т.к. при заполненении таблицы в названии могут встречаться пробелы в начале
order by created_at desc
limit 10; 