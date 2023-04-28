USE [Manage_BoardingHouse]
GO

--Trigger for Province
CREATE TRIGGER trg_Province_CheckName
ON Province
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted i JOIN Province p ON i.Province_Name = p.Province_Name WHERE i.Province_ID <> p.Province_ID)
  BEGIN
    RAISERROR('Province_Name must be unique', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

--Trigger for BoardingHouse
CREATE TRIGGER trg_BoardingHouse_CheckIDs
ON BoardingHouse
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE Province_ID IS NULL)
  BEGIN
    RAISERROR('Province_ID cannot be NULL', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

CREATE TRIGGER trg_BoardingHouse_CheckNumberOfRooms
ON BoardingHouse
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE NumberOfRooms <= 0)
  BEGIN
    RAISERROR('Price must be greater than 0', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

CREATE TRIGGER trg_BoardingHouse_CheckPhoneNumbers
ON BoardingHouse
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT * FROM inserted WHERE LEN(PhoneNumber) <> 10)
  BEGIN
    RAISERROR('Phone number must be 10 characters', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

--Trigger for NearBuiding
CREATE TRIGGER trg_NearBuiding_CheckIDs
ON NearBuiding
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE BuidingCaterogy_ID IS NULL)
  BEGIN
    RAISERROR('BuidingCaterogy_ID cannot be NULL', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

CREATE TRIGGER trg_NearBuiding_CheckName
ON NearBuiding
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted i JOIN NearBuiding p ON i.Buiding_Name = p.Buiding_Name WHERE i.Buiding_ID <> p.Buiding_ID)
  BEGIN
    RAISERROR('Building_Name must be unique', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

--Trigger for Distance
CREATE TRIGGER trg_Distance_CheckDistance
ON Distance
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE Distance <= 0)
  BEGIN
    RAISERROR('Distance must be greater than 0', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

CREATE TRIGGER trg_Distance_CheckIDs
ON Distance
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE Buiding_ID IS NULL OR BoardingHouse_ID IS NULL)
  BEGIN
    RAISERROR('Buiding_ID and BoardingHouse_ID cannot be NULL', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

--Trigger for Room
CREATE TRIGGER trg_Room_CheckIDs
ON Room
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE RoomCategory_ID IS NULL OR BoardingHouse_ID IS NULL)
  BEGIN
    RAISERROR('RoomCategory_ID and BoardingHouse_ID cannot be NULL', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

CREATE TRIGGER trg_Room_CheckArea
ON Room
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE Area <= 0)
  BEGIN
    RAISERROR('Area must be greater than 0', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO


CREATE TRIGGER trg_Room_CheckPrice
ON Room
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted WHERE Price <= 0)
  BEGIN
    RAISERROR('Price must be greater than 0', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

--Trigger for BuidingCaterogy
CREATE TRIGGER trg_BuidingCaterogy_CheckName
ON BuidingCaterogy
AFTER INSERT, UPDATE
AS
BEGIN
  IF EXISTS(SELECT 1 FROM inserted i JOIN BuidingCaterogy bc ON i.BuidingCaterogy_Name = bc.BuidingCaterogy_Name WHERE i.BuidingCaterogy_ID <> bc.BuidingCaterogy_ID)
  BEGIN
    RAISERROR('BuidingCaterogy_Name must be unique', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO

