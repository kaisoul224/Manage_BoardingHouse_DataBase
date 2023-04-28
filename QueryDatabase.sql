SELECT *
FROM Province

SELECT *
FROM BoardingCategory
GO

SELECT *
FROM BoardingHouse
GO

SELECT *
FROM BuidingCaterogy
GO

SELECT *
FROM NearBuiding
GO

SELECT *
FROM RoomCategory
GO

SELECT *
FROM Room
GO

SELECT *
FROM Distance
GO

--Show all boarding house in @Province_name
CREATE FUNCTION fn_GetBoardingHousesByProvince (@provinceName NVARCHAR(30))
RETURNS TABLE
AS
	RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name, bh.NumberOfRooms, bh.PhoneNumber, bh.Address, bc.BoardingCategory_Name
	FROM BoardingHouse bh
	JOIN Province p ON bh.Province_ID = p.Province_ID
	JOIN BoardingCategory bc ON bh.BoardingCategory_ID = bc.BoardingCategory_ID
	WHERE p.Province_Name = @provinceName
GO

--Show all nearbuiding near with boardinghouse
CREATE FUNCTION fn_GetBuildingsNearBoardingHouse (@boardingHouseId INT)
RETURNS TABLE
AS
	RETURN
	SELECT nb.Buiding_ID, nb.Buiding_Name, bc.BuidingCaterogy_Name, d.Distance
	FROM NearBuiding nb
	JOIN Distance d ON nb.Buiding_ID = d.Buiding_ID
	JOIN BoardingHouse bh ON d.BoardingHouse_ID = bh.BoardingHouse_ID
	JOIN BuidingCaterogy bc ON nb.BuidingCaterogy_ID = bc.BuidingCaterogy_ID
	WHERE bh.BoardingHouse_ID = @boardingHouseId
GO

--Show all boardinghouse depend on caterogy and province
CREATE FUNCTION fn_GetBoardingHousesByCategoryAndProvince (@categoryName NVARCHAR(30), @provinceName NVARCHAR(30))
RETURNS TABLE
AS
RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name, bh.NumberOfRooms, bh.PhoneNumber, bh.Address, bc.BoardingCategory_Name
	FROM BoardingHouse bh
	JOIN Province p ON bh.Province_ID = p.Province_ID
	JOIN BoardingCategory bc ON bh.BoardingCategory_ID = bc.BoardingCategory_ID
	WHERE bc.BoardingCategory_Name = @categoryName AND p.Province_Name = @provinceName
GO

-- Show all boarding house have the price between min and max value in a province
CREATE FUNCTION fn_GetBoardingHousesByProvinceAndPriceRange (@provinceName NVARCHAR(30), @minPrice INT, @maxPrice INT)
RETURNS TABLE
AS
RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name,Room_ID, [Status], Price
	FROM BoardingHouse bh
	JOIN Province p ON bh.Province_ID = p.Province_ID
	JOIN BoardingCategory bc ON bh.BoardingCategory_ID = bc.BoardingCategory_ID
	JOIN Room r ON bh.BoardingHouse_ID = r.BoardingHouse_ID
	WHERE p.Province_Name = @provinceName AND r.Price BETWEEN @minPrice AND @maxPrice
GO


--Show all boarding house have the price below max value
CREATE FUNCTION fn_GetBoardingHousesByPriceRange (@provinceName NVARCHAR(30),  @maxPrice INT)
RETURNS TABLE
AS
	RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name,Room_ID, [Status], Price
	FROM BoardingHouse bh
	JOIN Province p ON bh.Province_ID = p.Province_ID
	JOIN BoardingCategory bc ON bh.BoardingCategory_ID = bc.BoardingCategory_ID
	JOIN Room r ON bh.BoardingHouse_ID = r.BoardingHouse_ID
	WHERE p.Province_Name = @provinceName AND r.Price <= @maxPrice;
GO


-- Show all boardinghouse that near a nearbuilding
CREATE FUNCTION fn_GetBoardingHousesNearBuilding (@buildingName NVARCHAR(50))
RETURNS TABLE
AS
	RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name, bh.NumberOfRooms, Distance, bh.PhoneNumber, bh.Address
	FROM BoardingHouse bh
	JOIN Distance d ON bh.BoardingHouse_ID = d.BoardingHouse_ID
	JOIN NearBuiding nb ON d.Buiding_ID = nb.Buiding_ID
	WHERE nb.Buiding_Name = @buildingName;
GO

-- Show all boardingHouse that have availableRooms > @minAvailableRooms
CREATE FUNCTION fn_GetBoardingHousesWithAvailableRooms (@provinceName NVARCHAR(30), @minAvailableRooms INT)
RETURNS TABLE
AS
	RETURN
	SELECT bh.BoardingHouse_ID, bh.BoardingHouse_Name, bh.NumberOfRooms, numAvailableRooms, bh.PhoneNumber, bh.Address
	FROM BoardingHouse bh
	
	JOIN (
		SELECT Room.BoardingHouse_ID, COUNT(*) AS numAvailableRooms
		FROM Room

		WHERE Room.Status = 0
		GROUP BY Room.BoardingHouse_ID
	) AS availableRooms ON bh.BoardingHouse_ID = availableRooms.BoardingHouse_ID
	JOIN Province c on bh.Province_ID = c.Province_ID
	WHERE availableRooms.numAvailableRooms >= @minAvailableRooms and c.Province_Name like @provinceName;
GO
---------------------------------------------------------------------------------------------------------


--Query to show all boarding house in a province
select * from fn_GetBoardingHousesByProvince (N'Cần Thơ')
select * from fn_GetBoardingHousesByProvince (N'Bạc Liêu')
select * from fn_GetBoardingHousesByProvince (N'TP Hồ Chí Minh')

--Query to show all nearbuiding near with a boardinghouse
select * from fn_GetBuildingsNearBoardingHouse (1)
select * from fn_GetBuildingsNearBoardingHouse (8)
select * from fn_GetBuildingsNearBoardingHouse (5)

--Query to show all boardingHouse by Catagory and Province name 
select * from fn_GetBoardingHousesByCategoryAndProvince(N'Nhà Trọ Sinh Viên', N'Cần Thơ')
select * from fn_GetBoardingHousesByCategoryAndProvince(N'Nhà Trọ Lao Động', N'Cần Thơ')

--Query to show all boardingHouse have the price between min and max value in a province
select * from fn_GetBoardingHousesByProvinceAndPriceRange (N'TP Hồ Chí Minh', 2000000, 3000000)
select * from fn_GetBoardingHousesByProvinceAndPriceRange (N'Cần Thơ', 1400000, 2000000)

--Query to show all boardingHouse have the price below max value in a province
select * from fn_GetBoardingHousesByPriceRange(N'Cần Thơ', 2000000)
select * from fn_GetBoardingHousesByPriceRange(N'TP Hồ Chí Minh', 3000000)

--Query to show all boardinghouse that near a nearbuilding
select * from fn_GetBoardingHousesNearBuilding(N'Đại học FPT TP Cần Thơ')
select * from fn_GetBoardingHousesNearBuilding(N'Đại học FPT TP Hồ Chí Minh')

-- Query to show all boardingHouse that have availableRooms > minAvailableRooms
select * from fn_GetBoardingHousesWithAvailableRooms (N'TP Hồ Chí Minh',2)
select * from fn_GetBoardingHousesWithAvailableRooms (N'Cần Thơ',2)