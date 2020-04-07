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
	city					VARCHAR(100)	NOT NULL,
	state					VARCHAR(2)		NOT NULL,
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
SET IDENTITY_INSERT LandmarkCategories OFF;

SET IDENTITY_INSERT Landmarks ON;
	INSERT INTO Landmarks (landmark_id, landmark_name, city, state, days_open, hours_of_operation, category_id, description ) 
	VALUES	(1, 'Skyline Chili', 'Cincinnati', 'OH',  'MON-FRI', '8AM - 10PM', 1, 'Cincinnati style chili'),
			(2, 'Fountain Square', 'Cincinnati', 'OH', 'SAT SUN', '8AM - 6PM', 2, 'Center of the city');
SET IDENTITY_INSERT Landmarks OFF;

SET IDENTITY_INSERT LandmarkImages ON;
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(1, 1, 'https://upload.wikimedia.org/wikipedia/en/8/8f/Skyline_Chili_Logo.png', 'Logo of skyline chili', 'wikipedia' );
	INSERT INTO LandmarkImages (landmark_id, image_id, image_url, description, credits)
	VALUES(2, 2, 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/TylerDavidsonFountainAtNight.jpg/386px-TylerDavidsonFountainAtNight.jpg', 'Fountain Square at night', 'wikipedia' );
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
	A.city,
	A.state,
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
	INNER JOIN LandmarkImages AS C
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