-- Вывести информацию об объектах размещения в указанном городе

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

call properties_in_city('Port Rubiemouth');