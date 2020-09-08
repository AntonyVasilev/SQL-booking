USE booking;

-- Представление со всеми объектами размещения с парковкой

create or replace view properties_with_parking as
select
	pr.property_name as 'property name',
    ct.name as 'city',
    co.name as 'country'
from properties as pr
join cities as ct on ct.id = pr.city_id
join countries as co on co.id = ct.country_id 
join property_profiles as pp on pp.property_id = pr.id
where pp.property_facilities like '%parking%'
order by co.name;


-- Передставление с подробной информацией об отелях

create or replace view prop_info as
select
    pr.property_name as 'name',
    pt.name as 'property type',
    concat(pr.address, ' ', c.name, ' ', c2.name) as 'adress',
    pr.rating as 'rating',
    pp.property_facilities as 'facilities',
    pp.meals as 'meals',
    pp.bank_cards_allowed  as 'payment cards',
    pp.languages_spoken as'languages'
from booking.properties pr
join booking.property_types pt on pt.id = pr.property_type_id
join booking.property_profiles pp on pp.property_id = pr.id 
join booking.cities c on c.id = pr.city_id 
join booking.countries c2 on c2.id = c.country_id ;


-- Представление с информацией о пользователях (не владельцах объектов размещения) с списком их настроек

create or replace view users_info as
select
    concat(u.firstname,' ',u.lastname) as 'user',
    pct.payment_card_type as 'preferred card type',
    s.smoking_preference as 'smoking preference',
    s.reservation_emails_id as 'reservation emails id',
    s.newsletter_preferences_id as 'newsletter preferences id'
from booking.users u 
join booking.settings s on s.user_id = u.id 
join booking.payment_card_types pct on pct.id = s.preferred_card_types_id
where u.property_owner = 0;


-- Представление с информацией о пользователях с краткой информацией о их объектах размещения

create or replace view property_owners as
select
	concat(u.firstname,' ',u.lastname) as 'user name',
	u.email as 'email',
	u.phone as 'phone',
	pr.property_name as 'property name',
	pt.name as 'property type',
	c.name as 'city',
	c2.name as 'country'
from booking.users u 
join booking.properties pr on pr.user_id = u.id
join booking.property_types pt on pt.id = pr.property_type_id 
join booking.cities c on c.id = pr.city_id 
join booking.countries c2 on c2.id = c.country_id 
where u.property_owner = 1;
