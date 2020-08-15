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
    property_name VARCHAR(100),
    property_type ENUM ('hotel', 'apartment', 'hostel', 'guest_house', 'villa', 'homestay', 'bed_and_breakfast'),
    country_id SMALLINT UNSIGNED NOT NULL UNIQUE,
    city_id INT UNSIGNED NOT NULL UNIQUE,
    address VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES `countries`(id),
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

DROP TABLE IF EXISTS room_types;
CREATE TABLE room_types(
    id SMALLINT UNSIGNED NOT NULL UNIQUE,
    name VARCHAR (50),
    max_sleeps TINYINT, -- максимальное количество спальных мест
    roomsize TINYINT,
    room_facilities SET ('bath', 'hower', 'toilet', 'heating', 'air_conditioning', 'TV', 'cable_internet', 'Wi-Fi', 'Telephone', 'kitchenette'),
    bed_type SET('double_bed', 'single_bed'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS property_profiles;
CREATE TABLE property_profiles(
    property_id BIGINT UNSIGNED NOT NULL UNIQUE,
    room_type_id SMALLINT UNSIGNED NOT NULL,
    room_count SMALLINT,
    property_facilities SET('parking', 'lift', '24-hour_front_desk', 'pets_allowed', 'luggage_storage'),
    languages_spoken SET('english', 'spanish', 'italian', 'dutch', 'french', 'russian'),
    bank_cards_allowed SET ('visa', 'mastercard', 'JCB', 'american_express', 'union_pay', 'diners_club', 'mir'),
    meals SET('breakfast', 'lunch', 'dinner'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);
