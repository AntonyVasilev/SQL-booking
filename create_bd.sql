DROP DATABASE IF EXISTS booking;
CREATE DATABASE booking;
USE booking;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
    password_hash VARCHAR(100),
    phone BIGINT UNSIGNED UNIQUE,
    property_owner BIT, -- является владельцем недвижимости в сервисе или обычным пользователем
    created_at DATETIME DEFAULT NOW(),
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'пользователи';

DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries`(
    id SMALLINT UNSIGNED NOT NULL UNIQUE,
    name VARCHAR(50),
    region VARCHAR(50)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id INT UNSIGNED NOT NULL UNIQUE,
    country_id SMALLINT UNSIGNED NOT NULL UNIQUE,
    name VARCHAR(50),
    FOREIGN KEY (country_id) REFERENCES `countries`(id)
);

DROP TABLE IF EXISTS properties;
CREATE TABLE properties(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    property_name VARCHAR(100),
    property_type ENUM ('hotel', 'apartment', 'hostel', 'guest_house', 'villa', 'homestay', 'bed_and_breakfast'),
    country_id SMALLINT UNSIGNED NOT NULL UNIQUE,
    city_id INT UNSIGNED NOT NULL UNIQUE,
    address VARCHAR(255),
    rating FLOAT,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES `countries`(id),
    FOREIGN KEY (city_id) REFERENCES cities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS room_types;
CREATE TABLE room_types(
    id SMALLINT UNSIGNED NOT NULL UNIQUE,
    name VARCHAR (50),
    max_sleeps TINYINT, -- максимальное количество спальных мест
    room_size TINYINT, -- площадь номера
    room_facilities SET ('bath', 'hower', 'toilet', 'heating', 'air_conditioning', 'TV', 'cable_internet', 'Wi-Fi', 'Telephone', 'kitchenette'), -- удобства в номере
    bed_type SET('double_bed', 'single_bed'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS property_profiles;
CREATE TABLE property_profiles(
    property_id BIGINT UNSIGNED NOT NULL UNIQUE,
    room_type_id SMALLINT UNSIGNED NOT NULL,
    room_count SMALLINT, -- общее количество номеров
    property_facilities SET('parking', 'lift', '24-hour_front_desk', 'pets_allowed', 'luggage_storage'), -- услуги в отеле
    languages_spoken SET('english', 'spanish', 'italian', 'dutch', 'french', 'russian'),
    bank_cards_allowed SET ('visa', 'mastercard', 'JCB', 'american_express', 'union_pay', 'diners_club', 'mir'),
    meals SET('breakfast', 'lunch', 'dinner'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
) COMMENT 'описание услуг и удобств объекта недвижимости';

DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
	property_id BIGINT UNSIGNED NOT NULL UNIQUE,
	room_type_id SMALLINT UNSIGNED NOT NULL,
	room_count TINYINT, -- количество забронированных номеров
	booked_from_date DATE,
	booked_till_date DATE,
	book_type ENUM ('requested', 'confirmed', 'canceled'),
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

DROP TABLE IF EXISTS reviews; 
CREATE TABLE reviews(
	id INT UNSIGNED NOT NULL UNIQUE,
	property_id BIGINT UNSIGNED NOT NULL UNIQUE,
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
	rating SMALLINT, -- оценка пользователя
	review_heading VARCHAR(50), -- заголовок отзыва
	whats_like VARCHAR (255), -- что понравилось
	whats_dislike VARCHAR (255), -- что не понравилось
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('sent', 'read'),
    sent_at DATETIME DEFAULT NOW(),
	read_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CHECK (initiator_user_id <> target_user_id),
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);

