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
    gender CHAR(1),
    property_owner BIT, -- является владельцем недвижимости в сервисе или обычным пользователем
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX users_firstname_lastname_idx(firstname, lastname),
    INDEX users_lastname_firstname_idx(lastname, firstname)
) COMMENT 'пользователи';

DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries`(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    name VARCHAR(50),
    region VARCHAR(50) -- Africa, Americas, Asia, Europe, Oceania
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    country_id SMALLINT UNSIGNED NOT NULL,
    name VARCHAR(50),
    FOREIGN KEY (country_id) REFERENCES `countries`(id)
);

DROP TABLE IF EXISTS payment_card_types;
CREATE TABLE payment_card_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	payment_card_type VARCHAR(20) -- mastercard, visa, jcb, unionpay, mir, american_express, diners_club
);

DROP TABLE IF EXISTS newsletter_preferences;
CREATE TABLE newsletter_preferences(
	id SERIAL,
	deal_discovery BIT,
	rewards BIT,
	refer_a_friend BIT, 
	search_assistant BIT,
	personal_offers_through_the_post BIT, -- «Персональные предложения» по обычной почте
	attractions_and_tours BIT,
	extra_services_for_your_stay BIT,
	restaurant_guides_and_offers BIT,
	shopping_and_events BIT,
	travel_guides BIT,
	transport_deals_and_offers BIT,
	emails_genius_programme BIT, -- Рассылка «Программа Genius»
	emails_genius_membership BIT -- Рассылка «Программа Genius: ваш статус и достижения»
);

DROP TABLE IF EXISTS reservation_emails;
CREATE TABLE reservation_emails(
	id SERIAL,
	upcoming_booking BIT,
	review_invites BIT,
	booking_confirmation_emails BIT
);

DROP TABLE IF EXISTS settings;
CREATE TABLE settings(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	preferred_card_types_id TINYINT UNSIGNED NOT NULL,
	smoking_preference ENUM ('yes', 'no'),
	reservation_emails_id BIGINT UNSIGNED NOT NULL,
	newsletter_preferences_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (preferred_card_types_id) REFERENCES payment_card_types(id),
	FOREIGN KEY (reservation_emails_id) REFERENCES reservation_emails(id),
	FOREIGN KEY (newsletter_preferences_id) REFERENCES newsletter_preferences(id)
);

DROP TABLE IF EXISTS property_types;
CREATE TABLE property_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	name VARCHAR(50) -- hotel, apartment, hostel, guest_house, villa, homestay, bed_and_breakfast
);

DROP TABLE IF EXISTS properties;
CREATE TABLE properties(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    property_name VARCHAR(100),
    property_type_id TINYINT UNSIGNED NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    address VARCHAR(255),
    rating FLOAT(2,1),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES cities(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (property_type_id) REFERENCES property_types(id),
    INDEX property_name_idx(property_name)
);

DROP TABLE IF EXISTS bed_types;
CREATE TABLE bed_types(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	bed_type VARCHAR(50) -- double_bed, single_bed, sofa_bed, queen_size_bed, king_size_bed, cot 
);

DROP TABLE IF EXISTS room_types;
CREATE TABLE room_types(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    room_type VARCHAR (50),
    max_sleeps TINYINT, -- максимальное количество спальных мест
    room_size TINYINT, -- площадь номера
    room_facilities SET ('bath', 'hower', 'toilet', 'heating', 'air_conditioning', 'TV', 'cable_internet', 'Wi-Fi', 'Telephone', 'kitchenette'), -- удобства в номере
    bed_type_id TINYINT UNSIGNED NOT NULL,
    smoke_allowed BIT,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (bed_type_id) REFERENCES bed_types(id),
    INDEX room_type_idx(room_type)
);

DROP TABLE IF EXISTS property_profiles;
CREATE TABLE property_profiles(
    property_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
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
	user_id BIGINT UNSIGNED NOT NULL,
	property_id BIGINT UNSIGNED NOT NULL,
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
	id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
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
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    `status` ENUM('sent', 'read'),
    sent_at DATETIME DEFAULT NOW(),
	read_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);