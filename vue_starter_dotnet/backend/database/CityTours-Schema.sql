USE master;
GO

-- Delete the  database (IF EXISTS)
DROP DATABASE IF EXISTS CityTours;
GO

CREATE DATABASE CityTours;
GO

USE CityTours;
GO

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
			(4, 'Sawyer Point Park & Yeatman''s Cove','705 E Pete Rose Way', 'Cincinnati', 45202, 'OH', 'SUN-SAT', '9AM-7PM', 2, 'Sawyer Point Park & Yeatman''s Cove are a pair of side-by-side parks on the riverfront of downtown Cincinnati, Ohio, United States. The two linear parks stretch one mile along the north shore of the Ohio River. Since 2012, the parks have been the location for the annual Bunbury Music Festival.'),
			(5, 'Ault Park', '5090 Observatory Ave', 'Cincinnati', 'OH', 45208, 'SUN-SAT', '9AM-7PM', 2, 'Ault Park is the fourth-largest park in Cincinnati at 223.949 acres, owned and operated by the Cincinnati Park Board. It lies in the Mount Lookout neighborhood on the city''s east side.'),
			(6, 'Findlay Market', '1801 Race St', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '7AM-6PM', 1, 'Longtime hub of vendors selling meat, produce & other local foods, plus a seasonal farmers'' market.'),
			(7, 'Rhinegeist Brewery', '1910 Elm St', 'Cincinnati', 'OH', 45202, 'SUN-SAT', '11AM-9PM', 1, 'Taproom located in a historic bottling plant offering house-brewed beers, Ping-Pong, cornhole & TVs.'),
			(8, 'Contemporary Arts Center','44 E 6th St', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '10AM-6PM', 3, 'The Contemporary Arts Center is a contemporary art museum in Cincinnati, Ohio and one of the first contemporary art institutions in the United States. The CAC is a non-collecting museum that focuses on new developments in painting, sculpture, photography, architecture, performance art and new media.'),
			(9, 'Cincinnati Art Museum', '953 Eden Park Dr', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '10AM-6PM', 3, 'The Cincinnati Art Museum is an art museum in the Eden Park neighborhood of Cincinnati, Ohio. Founded in 1881, it was the first purpose-built art museum west of the Alleghenies, and is one of the oldest in the United States.'),
			(10, 'Cincinnati Zoo & Botanical Garden', '3400 Vine St', 'Cincinnati', 'OH', 45220, 'SUN-SAT', '10AM-7PM', 2, 'Cincinnati Zoo & Botanical Garden is the fifth-oldest zoo in the United States, opening in 1875, after the Philadelphia Zoo, the Roger Williams Park Zoo, the Lincoln Park Zoo, and the Central Park Zoo. It is located in the Avondale neighborhood of Cincinnati, Ohio.'),
			(11, 'Washington Park', '1230 Elm St', 'Cincinnati', 'OH', 45202, 'SUN-SAT', '10AM-11PM', 2, 'Washington Park is bounded by West 12th, Race and Elm Streets in the Over-the-Rhine neighborhood of Cincinnati, Ohio, United States. The park is owned and operated by the Cincinnati Park Board. The 6-acre park served as Presbyterian and Episcopal cemeteries before it was acquired by the city from 1858 to 1863.'),
			(12, 'Taft Museum of Art', '316 Pike St', 'Cincinnati', 'OH', 45202, 'TUES-SUN', '10AM-6PM', 3, 'The Taft Museum of Art is housed in the 200-year-old historic house at 316 Pike Street. The house – the oldest domestic wooden structure in downtown Cincinnati in situ – was built about 1820 and housed several prominent Cincinnatians, including Martin Baum, Nicholas Longworth, David Sinton, Anna Sinton Taft and Charles Phelps Taft. It now holds a fine art collection, is on the National Register of Historic Places listings, and is a contributing property to the Lytle Park Historic District.'),
			(13, 'MadTree Brewing','3301 Madison Rd', 'Cincinnati', 'OH', 45209, 'SUN-SAT', '11AM-8PM', 1, 'Bustling taproom offering craft beers, wood-fired pizzas, growler fills & keg sales, plus a patio.'),
			(14, 'Great American Ball Park','100 Joe Nuxhall Way', 'Cincinnati', 'OH', 45202, 'OPEN FOR EVENTS', 'TIMES VARY', 4, 'Great American Ball Park is a baseball stadium in Cincinnati, Ohio, which is the home field of Major League Baseball''s Cincinnati Reds. It opened in 2003, replacing Cinergy Field, their home field from 1970 to 2002. The park''s name comes from Great American Insurance Group.'),
			(15, 'Paul Brown Stadium', '1 Paul Brown Stadium', 'Cincinnati', 'OH', 45202, 'OPEN FOR EVENTS', 'TIMES VARY', 4, 'Paul Brown Stadium is an outdoor football stadium in Cincinnati, Ohio. It is the home venue of the Cincinnati Bengals of the National Football League and opened on August 19, 2000.');
			
SET IDENTITY_INSERT Landmarks OFF;

SET IDENTITY_INSERT LandmarkImages ON;
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(1, 1, 'https://upload.wikimedia.org/wikipedia/en/8/8f/Skyline_Chili_Logo.png', 'Logo of skyline chili', 'wikipedia' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(2, 2, 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/TylerDavidsonFountainAtNight.jpg/386px-TylerDavidsonFountainAtNight.jpg', 'Fountain Square at night', 'wikipedia' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(3, 3, 'https://photos.citybeat.com/wp-content/uploads/2018/11/UnionTerminal_DevinLuginbill1.jpg', 'Museum Center', 'city beat' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(4, 4, 'https://cincinnatiusa.com/sites/default/files/styles/Array/public/attractionphotos/bunbury8_Enquirer%20Media_Adam%20Birkan.JPG', 'A Concert at Sawyer Point', 'cincinnati USA' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(5, 5, 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Ault_Pavilion_view.jpg/1280px-Ault_Pavilion_view.jpg', 'View from the Pavillion', 'wikipedia' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(6, 6, 'https://www.fox19.com/resizer/grZyGM6YGhHvsbVg6BLBofrIB_g=/1200x600/arc-anglerfish-arc2-prod-raycom.s3.amazonaws.com/public/QYIAY5NSPJGXHNDZJA33ETD47M.jpg', 'Diners at Findlay Market', 'fox 19' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(7, 7, 'https://photos.citybeat.com/wp-content/uploads/2018/10/RareBeerFest_DevinLuginbill3.jpg', 'The Taproom at Rhinegeist', 'city beat' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(8, 8, 'https://cincinnatiusa.com/sites/default/files/styles/Array/public/attractionphotos/Contemporary%20Arts%20Center_%40shamanslife%20%28NO%20logos%20or%20stamps%20on%20image%29.jpg', 'The Contemporary Arts Center', 'cincinnati USA' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(9, 9, 'https://sibcyclinenews.files.wordpress.com/2014/06/museumentrance2.jpg?w=768&h=512', 'The Art Museum After Rain', 'sibcy cline' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(10, 10, 'https://cincinnatiusa.com/sites/default/files/styles/Array/public/attractionphotos/Michelle%20Curley%203.JPG', 'An Idyllic Day at the Zoo', 'cincinnati USA' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(11, 11, 'https://cdn.citybeat.com/files/base/scomm/cb/image/2019/04/16x9/640w/WashingtonPark_HB.5cabc414016ae.jpg', 'View of Music Hall from Washington Park', 'city beat' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(12, 12, 'https://cdn.citybeat.com/files/base/scomm/cb/image/2019/08/640w/FarFlungWillowTrees_HB_9.5aeca34d5fc84.5d49b7971a33b.jpg', 'The Grounds Leading to The Taft House', 'city beat' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(13, 13, 'https://365cincinnati.com/wp-content/uploads/2019/05/indoor-bar-at-madtree-1536x1152.jpg', 'The Main Bar at Madtree''s Taproom', '365 cincinnati' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(14, 14, 'https://d1marr3m5x4iac.cloudfront.net/images/edpborder500/I0-001/003/981/612-7.jpeg_/great-american-ball-park-12.jpeg', 'The Stadium with The City''s Skyline Behind it', 'eventful' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(15, 15, 'https://d3pxppq3195xue.cloudfront.net/media/images/13/01/25/Paul-BrownExterior_966x668.jpg', 'The Stadium Lighting up the Night Sky', 'nbbj' );

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

IF OBJECT_ID('SelecetLandmarkInfo') IS NOT NULL DROP VIEW SelectLandmarkInfo
GO
CREATE VIEW SelectLandmarkInfo
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
	SelectLandmarkInfo
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