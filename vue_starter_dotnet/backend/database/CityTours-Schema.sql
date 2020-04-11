USE master;
GO

-- Delete the  database (IF EXISTS)
DROP DATABASE IF EXISTS CityTours;
GO

CREATE DATABASE CityTours;
GO

USE CityTours;
GO

IF OBJECT_ID('ItineraryLandmarks')		IS NOT NULL DROP TABLE ItineraryLandmarks;

IF OBJECT_ID('Itineraries')				IS NOT NULL DROP TABLE Itineraries;

IF OBJECT_ID('Users')					IS NOT NULL DROP TABLE Users;

IF OBJECT_ID('RegisterUser')			IS NOT NULL DROP PROCEDURE RegisterUser;

IF OBJECT_ID('Login')					IS NOT NULL DROP PROCEDURE Login;

IF OBJECT_ID('LandmarkImages')			IS NOT NULL	DROP TABLE LandmarkImages;

IF OBJECT_ID('LandmarkCategories')		IS NOT NULL DROP TABLE LandmarkCategories;

IF OBJECT_ID('Landmarks')				IS NOT NULL	DROP TABLE Landmarks;
GO

BEGIN TRANSACTION
CREATE TABLE Users(
	user_id		INT	IDENTITY(1,1),
	email		VARCHAR(254)	NOT NULL,
	password	VARCHAR(64)		NOT NULL,
	salt		VARCHAR(64)		NOT NULL,
	role		VARCHAR(16)		DEFAULT('user'),
	CONSTRAINT Users_PK PRIMARY KEY (user_id)
)

CREATE TABLE Itineraries(
	itinerary_id	INT IDENTITY(1,1),
	user_id			INT NOT NULL,
	name			VARCHAR(100),
	itinerary_date	DATE,
	starting_location VARCHAR(100),
	currently_selected BIT DEFAULT 0,
	CONSTRAINT Itineraries_PK PRIMARY KEY (itinerary_id, user_id)
)

CREATE TABLE ItineraryLandmarks(
	itinerary_id    INT NOT NULL,
	landmark_id     INT NOT NULL,
	sort_order      INT NOT NULL,
	CONSTRAINT ItineraryLandmarks_PK PRIMARY KEY (itinerary_id, landmark_id)
)


CREATE TABLE Landmarks(
	landmark_id				INT IDENTITY(1,1),
	landmark_name			VARCHAR(100)	NOT NULL,
	street_address			VARCHAR(100)	NOT NULL,
	city					VARCHAR(100)	NOT NULL,
	state					VARCHAR(2)		NOT NULL,
	zip_code				INTEGER			NOT NULL,
	days_open				VARCHAR(100)	NOT NULL, -- eg Mon-Fri, Mon Wed Fri, Mon - Sun
    hours_of_operation		VARCHAR(100)	NOT NULL, -- eg 8AM - 8PM, 8AM - 12PM : 1PM - 5PM
	category_id				INTEGER			NOT NULL,
	description				VARCHAR(1000)	NOT NULL,
	CONSTRAINT Landmarks_PK PRIMARY KEY (landmark_id) 
)

CREATE TABLE LandmarkCategories(
	category_id		INT IDENTITY(1,1),
	category_name   VARCHAR(100) NOT NULL
	CONSTRAINT LandmarkCategories_PK PRIMARY KEY (category_id)
)

CREATE TABLE LandmarkImages(
	landmark_id			INT				NOT NULL,
	image_id			INT				IDENTITY(1,1),
	image_url			VARCHAR(1000)	NOT NULL,
	description			VARCHAR(1000)	NOT NULL,
	credits				VARCHAR(1000)	NOT NULL,
	CONSTRAINT	LandmarkImages_PK PRIMARY KEY (landmark_id, image_id)
)

ALTER TABLE Landmarks ADD CONSTRAINT LandmarkImages_Landmarks_FK
FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id)

ALTER TABLE Itineraries ADD CONSTRAINT Itineraries_Users_FK
FOREIGN KEY (user_id) REFERENCES Users (user_id)

COMMIT TRANSACTION
GO

--Add Test Data
BEGIN TRANSACTION
SET IDENTITY_INSERT LandmarkCategories ON;
	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(1, 'Food');
	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(2, 'Park');
	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(3, 'Museum');
	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(4, 'Arena/Stadium');
SET IDENTITY_INSERT LandmarkCategories OFF;

SET IDENTITY_INSERT Landmarks ON;
	INSERT INTO Landmarks (landmark_id, landmark_name, street_address, city, state, zip_code, days_open, hours_of_operation, category_id, description ) 
	VALUES	(1, 'Skyline Chili', '290 Ludlow Ave', 'Cincinnati', 'OH', 45220,  'MON-FRI', '8AM - 10PM', 1, 'Cincinnati style chili'),
			(2, 'Fountain Square','520 Vine St', 'Cincinnati', 'OH', 45202, 'SAT SUN', '8AM - 6PM', 2, 'Center of the city'),
			(3, 'Musem Center at Union Terminal','1301 Western Ave', 'Cincinnati', 'OH', 45203, 'SUN-SAT', '10AM -6PM', 3, 'Cincinnati Museum Center at Union Terminal is home to the Cincinnati History Museum, Duke Energy Children''s Museum, Museum of Natural History & Science, and Robert D. Lindner Family OMNIMAX Theater.'),
			(4, 'Sawyer Point Park & Yeatman''s Cove','705 E Pete Rose Way', 'Cincinnati', 'OH', 45202, 'SUN-SAT', '9AM-7PM', 2, 'Sawyer Point Park & Yeatman''s Cove are a pair of side-by-side parks on the riverfront of downtown Cincinnati, Ohio, United States. The two linear parks stretch one mile along the north shore of the Ohio River. Since 2012, the parks have been the location for the annual Bunbury Music Festival.'),
			(5, 'Ault Park', '5090 Observatory Ave', 'Cincinnati', 'OH', 45208, 'SUN-SAT', '9AM-7PM', 2, 'Ault Park is the fourth-largest park in Cincinnati at 223.949 acres, owned and operated by the Cincinnati Park Board. It lies in the Mount Lookout neighborhood on the city''s east side.'),
			(6, 'Findlay Market', '1801 Race St', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '7AM-6PM', 1, 'Longtime hub of vendors selling meat, produce & other local foods, plus a seasonal farmers'' market.'),
			(7, 'Rhinegeist Brewery', '1910 Elm St', 'Cincinnati', 'OH', 45202, 'SUN-SAT', '11AM-9PM', 1, 'Taproom located in a historic bottling plant offering house-brewed beers, Ping-Pong, cornhole & TVs.'),
			(8, 'Contemporary Arts Center','44 E 6th St', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '10AM-6PM', 3, 'The Contemporary Arts Center is a contemporary art museum in Cincinnati, Ohio and one of the first contemporary art institutions in the United States. The CAC is a non-collecting museum that focuses on new developments in painting, sculpture, photography, architecture, performance art and new media.'),
			(9, 'Cincinnati Art Museum', '953 Eden Park Dr', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '10AM-6PM', 3, 'The Cincinnati Art Museum is an art museum in the Eden Park neighborhood of Cincinnati, Ohio. Founded in 1881, it was the first purpose-built art museum west of the Alleghenies, and is one of the oldest in the United States.'),
			(10, 'Cincinnati Zoo & Botanical Garden', '3400 Vine St', 'Cincinnati', 'OH', 45220, 'SUN-SAT', '10AM-7PM', 2, 'Cincinnati Zoo & Botanical Garden is the fifth-oldest zoo in the United States, opening in 1875, after the Philadelphia Zoo, the Roger Williams Park Zoo, the Lincoln Park Zoo, and the Central Park Zoo. It is located in the Avondale neighborhood of Cincinnati, Ohio.'),
			(11, 'Washington Park', '1230 Elm St', 'Cincinnati', 'OH', 45202, 'SUN-SAT', '10AM-11PM', 2, 'Washington Park is bounded by West 12th, Race and Elm Streets in the Over-the-Rhine neighborhood of Cincinnati, Ohio, United States. The park is owned and operated by the Cincinnati Park Board. The 6-acre park served as Presbyterian and Episcopal cemeteries before it was acquired by the city from 1858 to 1863.'),
			(12, 'Taft Museum of Art', '316 Pike St', 'Cincinnati', 'OH', 45202, 'WED-SUN', '11AM-5PM', 3, 'The Taft Museum of Art is housed in the 200-year-old historic house at 316 Pike Street. The house – the oldest domestic wooden structure in downtown Cincinnati in situ – was built about 1820 and housed several prominent Cincinnatians, including Martin Baum, Nicholas Longworth, David Sinton, Anna Sinton Taft and Charles Phelps Taft. It now holds a fine art collection, is on the National Register of Historic Places listings, and is a contributing property to the Lytle Park Historic District.'),
			(13, 'MadTree Brewing','3301 Madison Rd', 'Cincinnati', 'OH', 45209, 'SUN-SAT', '11AM-8PM', 1, 'Bustling taproom offering craft beers, wood-fired pizzas, growler fills & keg sales, plus a patio.'),
			(14, 'Great American Ball Park','100 Joe Nuxhall Way', 'Cincinnati', 'OH', 45202, 'OPEN FOR EVENTS', 'TIMES VARY', 4, 'Great American Ball Park is a baseball stadium in Cincinnati, Ohio, which is the home field of Major League Baseball''s Cincinnati Reds. It opened in 2003, replacing Cinergy Field, their home field from 1970 to 2002. The park''s name comes from Great American Insurance Group.'),
			(15, 'Paul Brown Stadium', '1 Paul Brown Stadium', 'Cincinnati', 'OH', 45202, 'OPEN FOR EVENTS', 'TIMES VARY', 4, 'Paul Brown Stadium is an outdoor football stadium in Cincinnati, Ohio. It is the home venue of the Cincinnati Bengals of the National Football League and opened on August 19, 2000.');
			
SET IDENTITY_INSERT Landmarks OFF;

SET IDENTITY_INSERT LandmarkImages ON;
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(1, 1, 'https://i.imgur.com/39XnIpm.jpg', 'A Classic 3-way', 'imgur' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(2, 2, 'https://cdn.wedding-spot.com/__sized__/images/venues/14674/Fountain-Square-Cincinnati-OH-12fa7214-7bcd-4335-83ca-641f93415a7e-97450e389c42885476f1fbe9bc5bca5a.jpg', 'Setting up for a Concert', 'cdn' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(3, 3, 'https://www.fox19.com/resizer/zk9s08le9XZqv9r_OMweNs2KQ5o=/1200x600/arc-anglerfish-arc2-prod-raycom.s3.amazonaws.com/public/62R2JFQZMVGRXDRUJQZ32F7FXE.jpg', 'Museum Center at Night', 'fox 19' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(4, 4, 'https://www.cincinnatiparks.com/wp-content/uploads/2019/04/Smale-Riverfront-Park-Heekin-Playground-Slide.jpg', 'Slides at Sawyer Point', 'cincinnati parks' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(5, 5, 'https://cdn.wedding-spot.com/__sized__/images/venues/4097/Ault-Park-Pavilion-Cincinnati-OH-84c08ce9-6d6b-4c40-911b-2f5463ea0eb6-97450e389c42885476f1fbe9bc5bca5a.jpg', 'Setting up for a Wedding', 'cdn' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(6, 6, 'https://www.gannett-cdn.com/-mm-/363fa591bf68e82c3e833d8ccf05f64e76fe4ada/c=0-258-5084-3130/local/-/media/2017/06/03/Cincinnati/Cincinnati/636320947999485551-060317-GERMAN-HERITAGE-35.jpg?width=1600&height=800&fit=crop', 'Diners at Findlay Market', 'gannett' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(7, 7, 'https://cdn.craftbeer.com/wp-content/uploads/20180801121856/Rooftop-Breweries-Hero.jpg', 'The Rooftop at Rhinegeist', 'craftbeer.com' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(8, 8, 'https://blog.virginatlantic.com/wp-content/uploads/2016/05/5865i989892B378D4E81C.jpg', 'The Strinking Facade of the Contemporary Arts Center', 'virginia atlantic' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(9, 9, 'https://cdn.wedding-spot.com/__sized__/images/venues/8360/Cincinnati-Art-Museum-Cincinnati-OH-520aaa25-9b54-4be9-962e-5ae1d3e76176-97450e389c42885476f1fbe9bc5bca5a.jpg', 'Front Entrance of the Art Museum', 'cdn' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(10, 10, 'https://www.fox19.com/resizer/HVSX4vAgX_T6wkGTnIRG5r6EiaY=/1200x600/arc-anglerfish-arc2-prod-raycom.s3.amazonaws.com/public/EMBZ3YKIENFNFA7NIRHHW3IFM4.jpg', 'Everyone''s Favorite Hippo, Fiona', 'fox 19' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(11, 11, 'https://www.gannett-cdn.com/-mm-/13c67fbf77a16dabe79f291ad1930ca157e9d115/c=0-315-3558-2325/local/-/media/2015/12/29/Cincinnati/Cincinnati/635869977343471707-cover.jpg?width=1600&height=800&fit=crop', 'View of Music Hall from Washington Park', 'gannett' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(12, 12, 'https://app.contenttools.co/system/images/photos/000/082/151/thumb/Taft_Museum_of_Art_celebrates_Slow_Art_D_2810840000_16521646_ver1.0_640_480.jpg?1463007607', 'The Taft House', 'WCPO' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(13, 13, 'https://media.xogrp.com/images/5971621b-d20d-4fd5-8db8-8e0dab4a34ca~rs_840.h?ordering=explicit', 'The Biergarten at Madtree''s Taproom', 'the knot' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(14, 14, 'https://www.fox19.com/resizer/7fVCMgsFFHVeh049YNY3iNu6cpc=/1200x600/arc-anglerfish-arc2-prod-raycom.s3.amazonaws.com/public/WUXDKNK7QJBEBLN3Z2R3UDGN3I.jpg', 'The Stadium with The Ohio River Behind im the Background', 'fox 19' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(15, 15, 'https://cdn10.bigcommerce.com/s-fw2plafw/products/4608/images/6080/8336-2__07798.1429237559.1280.1280.jpg?c=2', 'The Stadium Sits on the Riverfront', 'cdn' );

SET IDENTITY_INSERT LandmarkImages OFF;
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
-- ADD FOREIGN KEY CONSTRAINTS

ALTER TABLE Landmarks 
ADD CONSTRAINT Landmarks_LandmarkCatergories FOREIGN KEY(category_id)
REFERENCES LandmarkCategories(category_id);

COMMIT TRANSACTION
GO




GO
CREATE PROCEDURE RegisterUser
	@emailAddress	VARCHAR(254),
	@password		VARCHAR(64),
	@salt			VARCHAR(64),
	@role			VARCHAR(16) = 'user'
AS
BEGIN TRANSACTION
	-- Registers new user if email isn't already in database
	-- Returns "successful" if successful registration, "already_registered" if already registered, "unsuccessful" if unsuccessful
	DECLARE @alreadyRegistered AS BIT = 0;
	DECLARE @returnCode AS VARCHAR(100) = 'unsuccesful';

	-- Check if email
	SET @alreadyRegistered =
	(
		-- Get the count of rows with the email address provided
		SELECT
			CASE
				WHEN	
					COUNT(*) > 0
				THEN
					1
				ELSE
					0
			END
		FROM
			Users
		WHERE
			email = @emailAddress
	)

	-- If email address doesnt already exist, insert into users, otherwise set return code = -1
	IF(@alreadyRegistered = 0)
	BEGIN
		INSERT INTO Users (email, password, salt, role)
		VALUES (@emailAddress, @password, @salt, @role)
		SET @returnCode = 'succesful';
	END
	ELSE
	BEGIN
		SET @returnCode = 'already_registered';
	END

	SELECT @returnCode;

COMMIT TRANSACTION
GO

CREATE PROCEDURE Login
	@emailAddress	VARCHAR(254),
	@password		VARCHAR(64),
	@salt			VARCHAR(64)
AS
BEGIN

	DECLARE @result AS VARCHAR(16) =
	(
		SELECT
			role
		FROM
			Users
		WHERE
			email		= @emailAddress
		AND	password	= @password
		AND	salt		= @salt
	)

	IF(@result IS NULL)
	BEGIN
		SET @result = 'invalid-login'
	END

	SELECT @result
END
GO

IF OBJECT_ID('SelecetLandmarkInfo') IS NOT NULL DROP VIEW AllLandmarkInfo
GO
CREATE VIEW AllLandmarkInfo
AS
SELECT
	A.landmark_id,
	A.landmark_name,
	A.days_open,
	A.hours_of_operation,
	A.description AS landmark_description,
	A.street_address,
	A.city,
	A.state,
	A.zip_code,
	B.category_id,
	B.category_name,
	C.image_id,
	C.image_url,
	C.description AS image_description,
	C.credits	
FROM
	Landmarks AS A
	INNER JOIN LandmarkCategories AS B
	ON (A.category_id = B.category_id)
	LEFT JOIN LandmarkImages AS C
	ON (A.landmark_id = C.landmark_id)
GO


IF OBJECT_ID('SearchForLandmark') IS NOT NULL DROP PROCEDURE SearchForLandmark
GO
CREATE PROCEDURE SearchForLandmark
	@query VARCHAR(100)
AS
BEGIN
SELECT DISTINCT
	*
FROM
	AllLandmarkInfo
WHERE
	landmark_name			LIKE '%'+@query+'%'
OR	landmark_description	LIKE '%'+@query+'%'
OR	category_name			LIKE '%'+@query+'%'
OR	image_description		LIKE '%'+@query+'%'
OR	credits					LIKE '%'+@query+'%'
END
GO

IF OBJECT_ID('GetLandmarkImages') IS NOT NULL DROP PROCEDURE GetLandmarkImages;
GO
CREATE PROCEDURE GetLandmarkImages
	@landmarkID INT
AS
BEGIN
	SELECT
		*
	FROM
		LandmarkImages
	WHERE
		landmark_id = @landmarkID
END
GO

IF OBJECT_ID('GetLandmarkByID') IS NOT NULL DROP PROCEDURE GetLandmarkByID
GO

CREATE PROCEDURE GetLandmarkByID
	@landmarkID INT
AS
BEGIN
	SELECT
		*
	FROM
		AllLandmarkInfo
	WHERE
		landmark_id = @landmarkID
END
GO

IF OBJECT_ID('UserItineraryLandmarks') IS NOT NULL DROP VIEW UserItineraryLandmarks
GO

CREATE VIEW UserItineraryLandmarks
AS
SELECT
	A.user_id,
	B.itinerary_id,
	B.itinerary_date,
	B.name,
	B.starting_location,
	B.currently_selected,
	C.landmark_id,
	C.sort_order
FROM
	Users AS A
	INNER JOIN Itineraries AS B
		LEFT JOIN ItineraryLandmarks AS C
		ON B.itinerary_id = C.itinerary_id
	ON A.user_id = B.user_id

GO

IF OBJECT_ID('GetItinerary') IS NOT NULL DROP PROCEDURE GetItinerary
GO

CREATE PROCEDURE GetItinerary
	@itinerary_id INT
AS
BEGIN
	SELECT
		*
	FROM
		UserItineraryLandmarks
	WHERE
		itinerary_id = @itinerary_id
	ORDER BY
		sort_order ASC
END
GO

IF OBJECT_ID('GetUsersItineraries') IS NOT NULL DROP PROCEDURE GetUsersItineraries
GO

CREATE PROCEDURE GetUsersItineraries
	@user_id INT
AS
BEGIN
	SELECT 
		*
	FROM
		Itineraries
	WHERE
		user_id = @user_id
	ORDER BY
		currently_selected DESC, itinerary_date DESC
END
GO

IF OBJECT_ID('GetSelectedItinerary') IS NOT NULL DROP PROCEDURE GetSelectedItinerary
GO

CREATE PROCEDURE GetSelectedItinerary
	@user_id INT
AS
BEGIN
	DECLARE @hasItinerary AS BIT =
	(
		SELECT
			CASE
				WHEN
					COUNT(*) > 0
				THEN
					1
				ELSE
					0
			END
		FROM
			UserItineraryLandmarks
		WHERE
			user_id				= @user_id
	)
	
	IF(@hasItinerary = 0)
	BEGIN
		EXECUTE CreateItinerary @user_id
	END

	SELECT
		*
	FROM
		UserItineraryLandmarks
	WHERE
		user_id				= @user_id
	AND	currently_selected	= 1
END
GO

IF OBJECT_ID('SetSelectedItinerary') IS NOT NULL DROP PROCEDURE SetSelectedItinerary
GO

CREATE PROCEDURE SetSelectedItinerary
	@itinerary_id INT,
	@user_id INT
AS 
BEGIN
	UPDATE Itineraries
	SET currently_selected = 1
	WHERE 
		itinerary_id	= @itinerary_id
	AND user_id			= @user_id

	UPDATE Itineraries
	SET currently_selected = 0
	WHERE
		itinerary_id <> @itinerary_id
	AND user_id = @user_id
END
GO
IF OBJECT_ID('CreateItinerary') IS NOT NULL DROP PROCEDURE CreateItinerary
GO

CREATE PROCEDURE CreateItinerary
	@user_id int,
	@name VARCHAR(100) = 'New Itinerary',
	@date DATE = NULL,
	@starting_location VARCHAR(100) = ''
AS
BEGIN TRANSACTION
	IF(@date IS NULL)
	BEGIN
		SET @date = CONVERT(DATE, GETDATE())
	END

	INSERT INTO Itineraries (user_id, name, itinerary_date, starting_location, currently_selected)
	VALUES					(@user_id, @name, @date, @starting_location, 1)

	DECLARE @new_id AS INT = SCOPE_IDENTITY();

	UPDATE Itineraries
	SET
		currently_selected = 0
	WHERE
		user_id			= @user_id
	AND itinerary_id	<> @new_id 

	--SELECT @new_id
COMMIT TRANSACTION
GO

IF OBJECT_ID('EditItinerary') IS NOT NULL DROP PROCEDURE EditItinerary
GO

CREATE PROCEDURE EditItinerary
	@itinerary_id		INT,
	@name				VARCHAR(100) = NULL,
	@date				DATE = NULL,
	@starting_location	VARCHAR(100) = NULL
AS
BEGIN TRANSACTION

	UPDATE Itineraries
	SET
		name = 
				(
					SELECT
						CASE
							WHEN
								@name IS NULL
							THEN
								name
							ELSE
								@name
						END
					FROM
						Itineraries
					WHERE
						itinerary_id = @itinerary_id
				),
		itinerary_date = 
				(
					SELECT
						CASE
							WHEN
								@date IS NULL
							THEN
								itinerary_date
							ELSE
								@date
						END
					FROM
						Itineraries
					WHERE
						itinerary_id = @itinerary_id
				),
		starting_location = 
				(
					SELECT
						CASE
							WHEN
								@starting_location IS NULL
							THEN
								starting_location
							ELSE
								@starting_location
						END
					FROM
						Itineraries
					WHERE
						itinerary_id = @itinerary_id
				)
			WHERE
				itinerary_id = @itinerary_id
					
COMMIT TRANSACTION
GO

IF OBJECT_ID('DeleteItinerary')	IS NOT NULL DROP PROCEDURE DeleteItinerary
GO

CREATE PROCEDURE DeleteItinerary
	@itinerary_id	INT
AS
BEGIN TRANSACTION
	DELETE FROM ItineraryLandmarks
	WHERE itinerary_id = @itinerary_id

	DELETE FROM Itineraries
	WHERE itinerary_id = @itinerary_id
COMMIT TRANSACTION
GO

IF OBJECT_ID('AddLandmarkToItinerary') IS NOT NULL DROP PROCEDURE AddLandmarkToItinerary
GO

CREATE PROCEDURE AddLandmarkToItinerary
	@itinerary_id INT,
	@landmark_id INT
AS
BEGIN TRANSACTION
	IF((SELECT COUNT(*) FROM UserItineraryLandmarks WHERE itinerary_id = @itinerary_id AND landmark_id = @landmark_id) = 0)
	BEGIN
		DECLARE @sort_order AS INT =
		(
			SELECT
				COALESCE(MAX(sort_order), 0) + 1
			FROM
				ItineraryLandmarks
			WHERE
				itinerary_id = @itinerary_id
		)
	
		INSERT INTO ItineraryLandmarks (itinerary_id,  landmark_id, sort_order)
		VALUES (@itinerary_id, @landmark_id, @sort_order)
	END

COMMIT TRANSACTION
GO
IF OBJECT_ID('EditItineraryLandmarkSortOrder') IS NOT NULL DROP PROCEDURE EditItineraryLandmarkSortOrder
GO

CREATE PROCEDURE EditItineraryLandmarkSortOrder
	@itinerary_id INT,
	@landmark_id INT,
	@sort_order INT
AS
BEGIN TRANSACTION
	UPDATE ItineraryLandmarks
	SET sort_order = @sort_order
	WHERE
		itinerary_id	= @itinerary_id
	AND	landmark_id		= @landmark_id
COMMIT TRANSACTION
GO

IF OBJECT_ID('RemoveLandmarkFromItinerary') IS NOT NULL DROP PROCEDURE RemoveLandmarkFromItinerary
GO

CREATE PROCEDURE RemoveLandmarkFromItinerary
	@itinerary_id INT,
	@landmark_id INT
AS
BEGIN TRANSACTION
	DELETE FROM ItineraryLandmarks
	WHERE
		itinerary_id	= @itinerary_id
	AND landmark_id		= @landmark_id

	-- Automagically update the sort order if there's at least 1 landmark in the itinerary
	IF((SELECT COUNT(*) FROM ItineraryLandmarks WHERE itinerary_id = @itinerary_id) > 0)
	BEGIN
		UPDATE ItineraryLandmarks 
		SET
			sort_order = A.new_sort_order
		FROM
		ItineraryLandMarks AS T
		INNER JOIN
		(
			SELECT
				itinerary_id,
				landmark_id,
				sort_order,
				ROW_NUMBER() OVER -- 1 , 2 , 3 , 4 
				(
					PARTITION BY itinerary_id ORDER BY sort_order ASC
				) AS new_sort_order
			FROM
				ItineraryLandmarks					
		) AS A
		ON T.itinerary_id = A.itinerary_id
		AND T.landmark_id = A.landmark_id
		WHERE
				T.itinerary_id	= @itinerary_id	
	END

	-- Select everything from itinerary view so the caller can update their local copy
	SELECT
		*
	FROM
		UserItineraryLandmarks
	WHERE
		itinerary_id = @itinerary_id
	ORDER BY
		sort_order ASC

COMMIT TRANSACTION
GO
SET IDENTITY_INSERT Users ON
INSERT INTO Users(user_id, email, password, salt, role)
VALUES (1, 'test', 'test', 'test1234', 'test')
SET IDENTITY_INSERT Users OFF

SET IDENTITY_INSERT Itineraries ON
INSERT INTO Itineraries(itinerary_id,user_id,name, itinerary_date, starting_location, currently_selected)
VALUES (1,1,'Test',GETDATE(),'Test',1)
SET IDENTITY_INSERT Itineraries OFF

INSERT INTO ItineraryLandmarks (itinerary_id, landmark_id, sort_order)
VALUES	(1,1,1),
		(1,2,2),
		(1,3,3),
		(1,5,4)


--EXECUTE RemoveLandmarkFromItinerary 1, 2
--SELECT * FROM UserItineraryLandmarks WHERE itinerary_id = 5
--SELECT * FROM Itineraries
SELECT * FROM Users
EXECUTE RemoveLandmarkFromItinerary 1, 3
--SELECT * FROM UserItineraryLandmarks
--EXECUTE DeleteItinerary 3
--EXECUTE GetSelectedItinerary 1
--EXECUTE EditItinerary 3, null, '04/12/2020', '1234 Main St'
--EXECUTE SetSelectedItinerary 1, 1
--EXECUTE GetUsersItineraries 1