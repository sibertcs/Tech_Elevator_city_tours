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
--BEGIN TRANSACTION
--SET IDENTITY_INSERT LandmarkCategories ON;
--	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(1, 'Food');
--	INSERT INTO LandmarkCategories (category_id, category_name) VALUES(2, 'Park');
--SET IDENTITY_INSERT LandmarkCategories OFF;

--SET IDENTITY_INSERT Landmarks ON;
--	INSERT INTO Landmarks (landmark_id, landmark_name, days_open, hours_of_operation, category_id ) VALUES(1, 'Carew Tower', 'MON-FRI', '8AM - 10PM', 1);
--	INSERT INTO Landmarks (landmark_id, landmark_name, days_open, hours_of_operation, category_id ) VALUES(2, 'Fountain Square', 'SAT SUN', '8AM - 6PM', 2)
--SET IDENTITY_INSERT Landmarks OFF;
--COMMIT TRANSACTION
GO

BEGIN TRANSACTION
-- ADD FOREIGN KEY CONSTRAINTS

ALTER TABLE Landmarks 
ADD FOREIGN KEY(category_id)
REFERENCES Categories(category_id);
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