USE master;
GO
--CREATE DATABASE CityTours;
GO
USE CityTours;
GO

IF OBJECT_ID('Users')			IS NOT NULL DROP TABLE users;

IF OBJECT_ID('RegisterUser')	IS NOT NULL DROP PROCEDURE RegisterUser

IF OBJECT_ID('Login')			IS NOT NULL DROP PROCEDURE Login
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