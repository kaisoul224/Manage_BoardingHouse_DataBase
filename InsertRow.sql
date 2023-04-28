
USE [Manage_BoardingHouse]
GO

--Insert value for Province table
CREATE PROCEDURE InsertProvince
(
    @ProvinceID int,
    @ProvinceName nvarchar(30)
)
AS
BEGIN
    INSERT INTO Province (Province_ID, Province_Name)
    VALUES (@ProvinceID, @ProvinceName)
END
GO

--Insert value for BoardingCategory table
CREATE PROCEDURE InsertBoardingCategory
(
    @BoardingCategoryID int,
    @BoardingCategoryName nvarchar(30)
)
AS
BEGIN
    INSERT INTO BoardingCategory (BoardingCategory_ID, BoardingCategory_Name)
    VALUES (@BoardingCategoryID, @BoardingCategoryName)
END
GO

--Insert value for BoardingHouse table
CREATE PROCEDURE InsertBoardingHouse
(
    @BoardingHouseID int,
    @BoardingHouseName nvarchar(50),
    @NumberOfRooms int,
    @PhoneNumber varchar(20),
    @Address nvarchar(100),
    @BoardingCategoryID int,
    @ProvinceID int
)
AS
BEGIN
    INSERT INTO BoardingHouse (BoardingHouse_ID, BoardingHouse_Name, NumberOfRooms, PhoneNumber, [Address], BoardingCategory_ID, Province_ID)
    VALUES (@BoardingHouseID, @BoardingHouseName, @NumberOfRooms, @PhoneNumber, @Address, @BoardingCategoryID, @ProvinceID)
END
GO

--Insert value for BuidingCaterogy table
CREATE PROCEDURE InsertBuidingCaterogy
   @BuidingCaterogy_ID int,
   @BuidingCaterogy_Name nvarchar(50)
AS
BEGIN
   INSERT INTO BuidingCaterogy (BuidingCaterogy_ID, BuidingCaterogy_Name)
   VALUES (@BuidingCaterogy_ID, @BuidingCaterogy_Name);
END
GO

--Insert value for NearBuiding table
CREATE PROCEDURE InsertNearBuiding
	@Buiding_ID int,
	@Buiding_Name nvarchar(50),
	@BuidingCaterogy_ID int
AS
BEGIN
   INSERT INTO NearBuiding (Buiding_ID, Buiding_Name, BuidingCaterogy_ID)
   VALUES (	@Buiding_ID, @Buiding_Name, @BuidingCaterogy_ID);
END
GO

--Insert value for Distance table
CREATE PROCEDURE InsertDistance
	@Buiding_ID int,
	@BoardingHouse_ID int,
	@Distance int
AS
BEGIN
   INSERT INTO Distance(Buiding_ID, BoardingHouse_ID, Distance)
   VALUES (	@Buiding_ID, @BoardingHouse_ID, @Distance);
END
GO

--Insert value for RoomCategory table
CREATE PROCEDURE InsertRoomCategory
	@RoomCategory_ID int,
	@RoomCategory_Name int
AS
BEGIN
   INSERT INTO RoomCategory(RoomCategory_ID, RoomCategory_Name)
   VALUES (	@RoomCategory_ID, @RoomCategory_Name);
END
GO

--Insert value for Room table
CREATE PROCEDURE InsertRoom
	@Room_ID int,
	@Room_Name nvarchar(30),
	@MaxGuests int,
	@Area float,
	@Price int,
	@Status bit,
	@RoomCategory_ID int,
	@BoardingHouse_ID int
AS
BEGIN
   INSERT INTO Room(Room_ID, Room_Name, MaxGuests, Area, Price, [Status], RoomCategory_ID, BoardingHouse_ID)
   VALUES (@Room_ID, @Room_Name, @MaxGuests, @Area, @Price, @Status, @RoomCategory_ID, @BoardingHouse_ID);
END
GO

