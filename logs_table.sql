use booking;

-- Создание таблицы logs типа Archive.
drop table if exists logs;
create table logs(
    date_time DATETIME,
    table_name VARCHAR(10),
    id BIGINT,
    email_or_prop_name VARCHAR(255),
    event_type CHAR(6)
) engine=Archive;


/* Создание триггеров, который при каждом создании или обновлении записи в таблицах users и properties 
помещает в таблицу logs время и дата создания/обновления записи, название таблицы, идентификатор первичного ключа и 
содержимое полей email / property_name и тип события.
*/

delimiter //

drop trigger if exists users_insert//
create trigger users_insert after insert on users
for each row
begin 
    insert into logs values (new.created_at, 'users', new.id, new.email, 'create');
end//

drop trigger if exists users_update//
create trigger users_update after update on users
for each row
begin 
    insert into logs values (new.updated_at, 'users', new.id, new.email, 'update');
end//

drop trigger if exists properties_insert//
create trigger properties_insert after insert on properties
for each row
begin 
    insert into logs values (new.created_at, 'properties', new.id, new.property_name, 'create');
end//

drop trigger if exists properties_update//
create trigger properties_update after update on properties
for each row
begin 
    insert into logs values (new.created_at, 'properties', new.id, new.property_name, 'update');
end//

delimiter ;

/*
insert into users (firstname, lastname, email, phone, gender)
    values ('Jane', 'Doe', 'janedoe@example.com', '10002223334', 'f');
    
update users 
set email = 'jane@example.com'
where id = last_insert_id();

insert into properties (user_id, property_name, property_type_id, city_id, address)
    values ('44', 'test hotel', 1, '9', '658 Reyna Lake Lehnerchester, IL 19227-8321');
    
update properties 
set property_type_id = 2
where id = last_insert_id(); 
*/