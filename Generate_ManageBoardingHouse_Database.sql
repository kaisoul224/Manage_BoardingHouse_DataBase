USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Manage_BoardingHouse')
BEGIN
	ALTER DATABASE [Manage_BoardingHouse] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [Manage_BoardingHouse] SET ONLINE;
	DROP DATABASE [Manage_BoardingHouse];
END

GO

CREATE DATABASE [Manage_BoardingHouse]
GO

USE [Manage_BoardingHouse]
GO

/*******************************************************************************
	Drop tables if exists
*******************************************************************************/
DECLARE @sql nvarchar(MAX) 
SET @sql = N'' 

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(KCU1.TABLE_SCHEMA) 
    + N'.' + QUOTENAME(KCU1.TABLE_NAME) 
    + N' DROP CONSTRAINT ' -- + QUOTENAME(rc.CONSTRAINT_SCHEMA)  + N'.'  -- not in MS-SQL
    + QUOTENAME(rc.CONSTRAINT_NAME) + N'; ' + CHAR(13) + CHAR(10) 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

EXECUTE(@sql) 

GO
DECLARE @sql2 NVARCHAR(max)=''

SELECT @sql2 += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql2 
GO 

CREATE TABLE Province
(
	Province_ID int,
	Province_Name nvarchar(30),
	Primary key (Province_ID)
)
GO
CREATE TABLE BoardingCategory
(
	BoardingCategory_ID int,
	BoardingCategory_Name nvarchar(30),
	Primary key (BoardingCategory_ID)
)
GO
CREATE TABLE BoardingHouse
(
	BoardingHouse_ID int,
	BoardingHouse_Name nvarchar(50),
	NumberOfRooms int not null,
	PhoneNumber varchar(10),
	[Address] nvarchar(100),
	Primary key (BoardingHouse_ID),
	BoardingCategory_ID int Foreign key references BoardingCategory,
	Province_ID int Foreign key references Province
)
GO
CREATE TABLE BuidingCaterogy
(
	BuidingCaterogy_ID int,
	BuidingCaterogy_Name nvarchar(50),
	Primary key (BuidingCaterogy_ID)
)
GO
CREATE TABLE NearBuiding
(
	Buiding_ID int,
	Buiding_Name nvarchar(50),
	Primary key (Buiding_ID),
	BuidingCaterogy_ID int Foreign key references BuidingCaterogy
)
GO

CREATE TABLE Distance
(	
	Buiding_ID int Foreign key references NearBuiding,
	BoardingHouse_ID int Foreign key references BoardingHouse,
	Distance int not null
)

GO
CREATE TABLE RoomCategory
(
	RoomCategory_ID int,
	RoomCategory_Name nvarchar(30),
	Primary key (RoomCategory_ID)
)
GO
CREATE TABLE Room
(
	Room_ID int,
	Room_Name nvarchar(30),
	MaxGuests int not null,
	Area float not null,
	Price int,
	[Status] bit not null,
	Primary key(Room_ID),
	RoomCategory_ID int Foreign key references RoomCategory,
	BoardingHouse_ID int Foreign key references BoardingHouse
)
GO

-- Insert row for Province table (Province_ID)
-- Insert row for BoardingCategory table (BoardingCategory_ID, BoardingCategory_Name)
-- Insert row for BoardingHouse table (BoardingHouse_ID - BoardingHouse_Name - NumberOfRooms - PhoneNumber - Address - BoardingCategory_ID - Province_ID)
-- Insert row for BuidingCaterogy table (BuidingCaterogy_ID, BuidingCaterogy_Name)
-- Insert row for NearBuiding table (Buiding_ID, Buiding_Name, distance, BuidingCaterogy_ID)
-- Insert row for Distance table (BoardingHouse_ID, Buiding_ID, Distance)
-- Insert row for RoomCategory table (RoomCategory_ID, RoomCategory_name, Price)
-- Insert row for Room table (Room_ID, Room_Name, MaxGuests, Area, Price, Status, RoomCategory_ID, BoardingHouse_ID)


--BuidingCaterogy 
INSERT INTO BuidingCaterogy VALUES (1, N'Đại Học')
INSERT INTO BuidingCaterogy VALUES (2, N'Cao Đẳng')
INSERT INTO BuidingCaterogy VALUES (3, N'Bệnh Viện')
INSERT INTO BuidingCaterogy VALUES (4, N'Trung Tâm Thương Mại')
INSERT INTO BuidingCaterogy VALUES (5, N'Khu Công Nghiệp')
INSERT INTO BuidingCaterogy VALUES (6, N'Chợ')

--BoardingCategory
INSERT INTO BoardingCategory VALUES (1, N'Nhà Trọ Sinh Viên')
INSERT INTO BoardingCategory VALUES (2, N'Nhà Trọ Lao Động')
INSERT INTO BoardingCategory VALUES (3, N'Nhà Trọ Khác')

--RoomCategory
INSERT INTO RoomCategory VALUES (1, N'Gác Lửng')
INSERT INTO RoomCategory VALUES (2, N'Không Gác')

---Cần Thơ

INSERT INTO Province VALUES (1, N'Cần Thơ')
INSERT INTO NearBuiding VALUES (1, N'Đại học FPT TP Cần Thơ',1)
INSERT INTO NearBuiding VALUES (2, N'Đại học Y Dược',1)
INSERT INTO NearBuiding VALUES (3, N'Đại học Nam Cần Thơ',1)
INSERT INTO NearBuiding VALUES (4, N'Đại học Cần Thơ',1)
INSERT INTO NearBuiding VALUES (5, N'Bệnh Viện Nhi Đồng Cần thơ',3)
INSERT INTO NearBuiding VALUES (6, N'Bệnh Viện Đột Quỵ Tim Mạch (SIS)',3)
INSERT INTO NearBuiding VALUES (7, N'Bệnh Viện Đa Khoa Cần Thơ',3)
INSERT INTO NearBuiding VALUES (8, N'Bệnh Viện Quốc Tế Phương Châu',3)
INSERT INTO NearBuiding VALUES (9, N'TTTM Vincom Plaza Xuân Khánh',4)
INSERT INTO NearBuiding VALUES (10, N'Đại học Công Nghệ Kỹ Thuật',1)
INSERT INTO NearBuiding VALUES (11, N'Cao đẳng Y tế Cần Thơ',2)
INSERT INTO NearBuiding VALUES (12, N'TTTM Lotte Mart',4)
INSERT INTO NearBuiding VALUES (13, N'TTTM Sense City Cần Thơ',4)

INSERT INTO BoardingHouse VALUES (1, N'Kiều Mỵ', 14,'0983902830', N'G10/11, Đường số 3, Khu dân cư mặt trời đỏ, P. Long Tuyền, Q. Bình Thủy',1,1)
INSERT INTO Distance VALUES (1,1,1000)
INSERT INTO Distance VALUES (2,1,2630)
INSERT INTO Distance VALUES (3,1,2040)
INSERT INTO Distance VALUES (4,1,4750)
INSERT INTO Distance VALUES (5,1,800)
INSERT INTO Distance VALUES (6,1,700)
INSERT INTO Distance VALUES (7,1,3680)
INSERT INTO Distance VALUES (8,1,2310)
INSERT INTO Distance VALUES (9,1,6320)
INSERT INTO Distance VALUES (10,1,5700)
INSERT INTO Distance VALUES (11,1,6100)
INSERT INTO Distance VALUES (12,1,4200)
INSERT INTO Distance VALUES (13,1,5900)
INSERT INTO Room VALUES (1, N'1',2,20,1400000,1,1,1)
INSERT INTO Room VALUES (2, N'2',3,20,1400000,1,1,1)
INSERT INTO Room VALUES (3, N'3',3,20,1400000,1,1,1)
INSERT INTO Room VALUES (4, N'4',3,20,1400000,1,1,1)
INSERT INTO Room VALUES (5, N'5',3,20,1400000,1,1,1)
INSERT INTO Room VALUES (6, N'6',4,20,1400000,1,1,1)
INSERT INTO Room VALUES (7, N'7',3,20,1400000,1,1,1)
INSERT INTO Room VALUES (8, N'8',3,20,1000000,1,2,1)
INSERT INTO Room VALUES (9, N'9',3,20,1000000,1,2,1)
INSERT INTO Room VALUES (10, N'10',3,20,1000000,1,2,1)
INSERT INTO Room VALUES (11, N'11',3,20,1000000,1,2,1)
INSERT INTO Room VALUES (12, N'12',2,20,1000000,1,2,1)
INSERT INTO Room VALUES (13, N'13',3,20,1000000,1,2,1)
INSERT INTO Room VALUES (14, N'14',3,20,1000000,1,2,1)

INSERT INTO BoardingHouse VALUES (2, N'Diễm Thúy', 5,'0334394430', N'G7 Đường số 3, P. Long Tuyền, Q. Bình Thủy, TP Cần Thơ',2,1)
INSERT INTO Distance VALUES (1,2,1100)
INSERT INTO Distance VALUES (2,2,2800)
INSERT INTO Distance VALUES (3,2,2140)
INSERT INTO Distance VALUES (4,2,5010)
INSERT INTO Distance VALUES (5,2,950)
INSERT INTO Distance VALUES (6,2,810)
INSERT INTO Distance VALUES (7,2,3780)
INSERT INTO Distance VALUES (8,2,2410)
INSERT INTO Distance VALUES (9,2,6410)
INSERT INTO Distance VALUES (10,2,5600)
INSERT INTO Distance VALUES (11,2,6020)
INSERT INTO Distance VALUES (12,2,4040)
INSERT INTO Distance VALUES (13,2,5630)
INSERT INTO Room VALUES (15, N'1',3,15,1200000,1,1,2)
INSERT INTO Room VALUES (16, N'2',3,15,1200000,1,1,2)
INSERT INTO Room VALUES (17, N'3',3,15,1200000,1,1,2)
INSERT INTO Room VALUES (18, N'4',3,15,1200000,1,1,2)
INSERT INTO Room VALUES (19, N'5',3,15,1200000,1,1,2)

INSERT INTO BoardingHouse VALUES (3, N'Nguyen Giang', 12,'0329972112',N'701B-701C, Liên Tổ 12-20, Đường Nguyễn Văn Cừ (nối dài),Phường An Khánh, Q. Ninh Kiều, TP Cần Thơ',3,1)
INSERT INTO Distance VALUES (1,3,3010)
INSERT INTO Distance VALUES (2,3,1300)
INSERT INTO Distance VALUES (3,3,2320)
INSERT INTO Distance VALUES (4,3,1600)
INSERT INTO Distance VALUES (5,3,6090)
INSERT INTO Distance VALUES (6,3,2300)
INSERT INTO Distance VALUES (7,3,3000)
INSERT INTO Distance VALUES (8,3,4010)
INSERT INTO Distance VALUES (9,3,3050)
INSERT INTO Distance VALUES (10,3,700)
INSERT INTO Distance VALUES (11,3,400)
INSERT INTO Distance VALUES (12,3,300)
INSERT INTO Distance VALUES (13,3,3900)
INSERT INTO Room VALUES (20, N'1',3,20,2200000,1,2,3)
INSERT INTO Room VALUES (21, N'2',3,20,2200000,1,2,3)
INSERT INTO Room VALUES (22, N'3',3,20,2200000,1,2,3)
INSERT INTO Room VALUES (23, N'4',3,20,2200000,1,2,3)
INSERT INTO Room VALUES (24, N'5',3,20,2200000,1,2,3)
INSERT INTO Room VALUES (25, N'6',3,20,2200000,0,2,3)
INSERT INTO Room VALUES (26, N'7',4,20,2600000,1,1,3)
INSERT INTO Room VALUES (27, N'8',4,20,2600000,1,1,3)
INSERT INTO Room VALUES (28, N'9',4,20,2600000,0,1,3)
INSERT INTO Room VALUES (29, N'10',4,20,2600000,1,1,3)
INSERT INTO Room VALUES (30, N'11',4,20,2600000,1,1,3)
INSERT INTO Room VALUES (31, N'12',4,20,2600000,1,1,3)

--- TP Hồ Chí Minh'
INSERT INTO Province VALUES (2, N'TP Hồ Chí Minh')
INSERT INTO NearBuiding VALUES (14, N'Đại học FPT TP Hồ Chí Minh',1)
INSERT INTO NearBuiding VALUES (15, N'Đại Học Nguyễn Tất Thành',1)
INSERT INTO NearBuiding VALUES (16, N'Đại Học Hoa sen ',1)
INSERT INTO NearBuiding VALUES (17, N'Đại học Tài chính - Marketing',1)
INSERT INTO NearBuiding VALUES (18, N'Đại học Tôn Đức Thắng',1)
INSERT INTO NearBuiding VALUES (19, N'Bệnh Viện Nhi Đồng Thành Phố HCM',3)
INSERT INTO NearBuiding VALUES (20, N'Bệnh Viện Quận 7 ',3)
INSERT INTO NearBuiding VALUES (21, N'Bệnh Viện FV',3)
INSERT INTO NearBuiding VALUES (22, N'TTTM Go! Nguyễn Thị Thập',4)
INSERT INTO NearBuiding VALUES (23, N'TTTM Lotte Mart Quận 7',4)
INSERT INTO NearBuiding VALUES (24, N'Đại học Hutech',1)
INSERT INTO NearBuiding VALUES (25, N'Bệnh Viện khu 12',3)

INSERT INTO BoardingHouse VALUES (4, N'Phú Vương', 20,'093100774', N'120, Đ. Nguyễn Thái Bình, P. Nguyễn Thái Bình, Q. 1, TP HCM',1,2)
INSERT INTO Distance VALUES (14,4,3100)
INSERT INTO Distance VALUES (15,4,4800)
INSERT INTO Distance VALUES (16,4,5800)
INSERT INTO Distance VALUES (17,4,2440)
INSERT INTO Distance VALUES (18,4,5000)
INSERT INTO Distance VALUES (19,4,4000)
INSERT INTO Distance VALUES (20,4,800)
INSERT INTO Distance VALUES (21,4,1780)
INSERT INTO Distance VALUES (22,4,2410)
INSERT INTO Distance VALUES (23,4,2200)
INSERT INTO Room VALUES (32, N'1',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (33, N'2',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (34, N'3',2,14,2500000,0,2,4)
INSERT INTO Room VALUES (35, N'4',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (36, N'5',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (37, N'6',2,14,2500000,0,2,4)
INSERT INTO Room VALUES (38, N'7',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (39, N'8',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (40, N'9',2,14,2500000,1,2,4)
INSERT INTO Room VALUES (41, N'10',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (42, N'11',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (43, N'12',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (44, N'13',3,14,2800000,0,1,4)
INSERT INTO Room VALUES (45, N'14',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (46, N'15',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (47, N'16',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (48, N'17',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (49, N'18',3,14,2800000,1,1,4)
INSERT INTO Room VALUES (50, N'19',3,14,2800000,0,1,4)
INSERT INTO Room VALUES (51, N'20',3,14,2500000,1,2,4)

INSERT INTO BoardingHouse VALUES (5, N'Ngọc Hồi', 9,'0934201338', N'321 Lý Thường Kiệt, P. 9, Tân Bình, TP HCM',2,2)
INSERT INTO Distance VALUES (24,5,1000)
INSERT INTO Distance VALUES (14,5,2630)
INSERT INTO Distance VALUES (25,5,780)
INSERT INTO Room VALUES (52, N'1',2,15,2200000,1,1,5)
INSERT INTO Room VALUES (53, N'2',3,15,2200000,1,1,5)
INSERT INTO Room VALUES (54, N'3',3,15,2200000,1,1,5)
INSERT INTO Room VALUES (55, N'4',3,15,2200000,1,1,5)
INSERT INTO Room VALUES (56, N'5',1,15,2000000,1,2,5)
INSERT INTO Room VALUES (57, N'6',3,15,2000000,1,2,5)
INSERT INTO Room VALUES (58, N'7',2,15,2200000,1,1,5)
INSERT INTO Room VALUES (59, N'8',3,15,2200000,0,1,5)
INSERT INTO Room VALUES (60, N'9',3,15,2200000,0,1,5)

--Hà nội
INSERT INTO Province VALUES (3, N'Hà Nội')
INSERT INTO NearBuiding VALUES (26, N'Đại học Kinh doanh và Công Nghệ Hà Nội',1)
INSERT INTO NearBuiding VALUES (27, N'Bệnh Viện Thanh Nhàn',3)
INSERT INTO NearBuiding VALUES (28, N'TTTM Vincom Smart',4)

INSERT INTO BoardingHouse VALUES (6, N'Kim Phát', 7,'0167123216', N'12 Võ Thi Sáu, P. 7, Đống Đa, Hà Nội',3,3)
INSERT INTO Distance VALUES (26,6,1430)
INSERT INTO Distance VALUES (27,6,930)
INSERT INTO Distance VALUES (28,6,6320)
INSERT INTO Room VALUES (61, N'Emerald',4,25,3600000,1,1,6)
INSERT INTO Room VALUES (62, N'Diamond',4,25,3400000,1,1,6)
INSERT INTO Room VALUES (63, N'Ruby',4,25,3200000,1,1,6)
INSERT INTO Room VALUES (64, N'Topaz',4,25,3000000,1,1,6)
INSERT INTO Room VALUES (65, N'Gold',4,25,2800000,0,1,6)
INSERT INTO Room VALUES (66, N'Silver',3,25,2600000,0,1,6)
INSERT INTO Room VALUES (67, N'Coper',3,25,2400000,0,1,6)

--Đà nẵng
INSERT INTO Province VALUES (4, N'Đà Nẵng')
INSERT INTO NearBuiding VALUES (29, N'Đại học Kinh tế',1)
INSERT INTO NearBuiding VALUES (30, N'Bệnh Viện 199',3)
INSERT INTO NearBuiding VALUES (31, N'Bệnh Viện đa khoa quốc tế Vinmec',3)

INSERT INTO BoardingHouse VALUES (7, N'Nhất Trung', 25,'0791241741', N'18, Thanh Xuân, Tp Đà Nẵng',2,4)
INSERT INTO Distance VALUES (29,7,900)
INSERT INTO Distance VALUES (30,7,2100)
INSERT INTO Distance VALUES (31,7,6200)
INSERT INTO Room VALUES (68, N'1',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (69, N'2',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (70, N'3',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (71, N'4',3,20,1800000,0,1,7)
INSERT INTO Room VALUES (72, N'5',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (73, N'6',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (74, N'7',3,20,1800000,0,1,7)
INSERT INTO Room VALUES (75, N'8',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (76, N'9',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (77, N'10',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (78, N'11',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (79, N'12',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (80, N'13',3,20,1800000,0,1,7)
INSERT INTO Room VALUES (81, N'14',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (82, N'15',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (83, N'16',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (84, N'17',3,20,1800000,0,1,7)
INSERT INTO Room VALUES (85, N'18',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (86, N'19',3,20,1800000,1,2,7)
INSERT INTO Room VALUES (87, N'20',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (88, N'21',3,20,1800000,0,1,7)
INSERT INTO Room VALUES (89, N'22',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (90, N'23',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (91, N'24',3,20,1800000,1,1,7)
INSERT INTO Room VALUES (92, N'25',3,20,1800000,1,1,7)

--Bạc Liêu
INSERT INTO Province VALUES (5, N'Bạc Liêu')
INSERT INTO NearBuiding VALUES (32, N'Đại học Bạc Liêu',1)
INSERT INTO NearBuiding VALUES (33, N'Bệnh Viện Thanh Vũ',3)
INSERT INTO NearBuiding VALUES (34, N'TTTM VinCom Plaza Bạc Liêu',4)

INSERT INTO BoardingHouse VALUES (8, N'Hoàng Kim', 19,'0742312131', N'31 Trần Huỳnh, P. 8, TP Bạc Liêu',2,5)
INSERT INTO Distance VALUES (32,8,700)
INSERT INTO Distance VALUES (33,8,1300)
INSERT INTO Distance VALUES (34,8,2200)
INSERT INTO Room VALUES (93, N'1',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (94, N'2',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (95, N'3',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (96, N'4',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (97, N'5',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (98, N'6',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (99, N'7',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (100, N'8',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (101, N'9',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (102, N'10',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (103, N'11',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (104, N'12',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (105, N'13',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (106, N'14',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (107, N'15',4,25,1500000,0,1,8)
INSERT INTO Room VALUES (108, N'16',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (109, N'17',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (110, N'18',4,25,1500000,1,1,8)
INSERT INTO Room VALUES (111, N'19',4,25,1500000,0,1,8)

--Sóc trăng
INSERT INTO Province VALUES (6, N'Sóc Trăng')
INSERT INTO NearBuiding VALUES (35, N'KCN An Nghiệp',5)
INSERT INTO NearBuiding VALUES (36, N'KCN Sông Hậu',5)
INSERT INTO NearBuiding VALUES (37, N'Trường Cao Đẳng Cộng Đồng Sóc Trăng',2)
INSERT INTO NearBuiding VALUES (38, N'TTTM Loteria',4)
INSERT INTO NearBuiding VALUES (39, N'TTTM Vincom Plaza',4)

INSERT INTO BoardingHouse VALUES (9, N'Thuận Phát', 12,'0999102323', N'295 Phú Lợi, P. 2, TP Sóc Trăng',2,6)
INSERT INTO Distance VALUES (35,9,1930)
INSERT INTO Distance VALUES (36,9,4010)
INSERT INTO Distance VALUES (37,9,780)
INSERT INTO Distance VALUES (38,9,2540)
INSERT INTO Distance VALUES (39,9,350)
INSERT INTO Room VALUES (112, N'1',3,20,900000,1,1,9)
INSERT INTO Room VALUES (113, N'2',3,20,900000,1,1,9)
INSERT INTO Room VALUES (114, N'3',3,20,900000,1,1,9)
INSERT INTO Room VALUES (115, N'4',3,20,900000,1,1,9)
INSERT INTO Room VALUES (116, N'5',3,20,900000,0,1,9)
INSERT INTO Room VALUES (117, N'6',3,20,900000,1,1,9)
INSERT INTO Room VALUES (118, N'7',3,20,900000,1,1,9)
INSERT INTO Room VALUES (119, N'8',3,20,800000,1,2,9)
INSERT INTO Room VALUES (120, N'9',3,20,800000,1,2,9)
INSERT INTO Room VALUES (121, N'10',3,20,800000,1,2,9)
INSERT INTO Room VALUES (122, N'11',3,20,800000,1,2,9)
INSERT INTO Room VALUES (123, N'12',3,20,900000,0,1,9)

--Cà mau
INSERT INTO Province VALUES (7, N'Cà mau')
INSERT INTO NearBuiding VALUES (40, N'Chợ nỗi Cà Mau',6)
INSERT INTO NearBuiding VALUES (41, N'BV Đa Khoa Cà Mau',4)
INSERT INTO NearBuiding VALUES (42, N'KCN Phường 8',5)
INSERT INTO NearBuiding VALUES (43, N'KCN Sông Đốc',5)
INSERT INTO NearBuiding VALUES (44, N'KCN Khánh An',5)
INSERT INTO NearBuiding VALUES (45, N'TTTM Vincom Plaza Cà Mau',4)

INSERT INTO BoardingHouse VALUES (10, N'Phú Lợi', 25,'0914875606', N'81 Đường Phan Ngọc Hiển, Phường 4, TP Cà Mau',2,7)

INSERT INTO Distance VALUES (40,10,1230)
INSERT INTO Distance VALUES (41,10,3200)
INSERT INTO Distance VALUES (42,10,4100)
INSERT INTO Distance VALUES (43,10,1700)
INSERT INTO Distance VALUES (44,10,3400)
INSERT INTO Distance VALUES (45,10,2890)
INSERT INTO Room VALUES (130, N'1',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (131, N'2',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (132, N'3',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (133, N'4',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (134, N'5',4,25,1200000,0,1,10)
INSERT INTO Room VALUES (135, N'6',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (136, N'7',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (137, N'8',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (138, N'9',4,25,1200000,1,1,10)
INSERT INTO Room VALUES (139, N'10',4,25,1200000,0,1,10)
INSERT INTO Room VALUES (140, N'11',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (141, N'12',2,25,1100000,0,2,10)
INSERT INTO Room VALUES (142, N'13',3,25,1100000,0,2,10)
INSERT INTO Room VALUES (143, N'14',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (144, N'15',3,25,1100000,0,2,10)
INSERT INTO Room VALUES (145, N'16',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (146, N'17',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (147, N'18',3,25,1100000,0,2,10)
INSERT INTO Room VALUES (148, N'19',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (149, N'20',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (150, N'21',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (151, N'22',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (152, N'23',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (153, N'24',3,25,1100000,1,2,10)
INSERT INTO Room VALUES (154, N'25',3,25,1100000,0,2,10)

INSERT INTO Province VALUES (8, N'An Giang')
INSERT INTO BoardingHouse VALUES (11, N'Hồi Kim', 5,'0309080123', N'39A Lý Thái Tổ nối dài, An Giang',2,8)
INSERT INTO NearBuiding VALUES (46, N'Trường CĐ nghề An Giang',2)
INSERT INTO NearBuiding VALUES (47, N'Bệnh Viện Đa Khoa An Giang',3)
INSERT INTO NearBuiding VALUES (48, N'KCN Hòa Bình',5)
INSERT INTO NearBuiding VALUES (49, N'KCN Vàm Cống',5)
INSERT INTO NearBuiding VALUES (50, N'KCN Xuân Tô',5)
INSERT INTO NearBuiding VALUES (51, N'TTTM Vincom Plaza Long Xuyên',4)
INSERT INTO Distance VALUES (46,11,2340)
INSERT INTO Distance VALUES (47,11,3240)
INSERT INTO Distance VALUES (48,11,2780)
INSERT INTO Distance VALUES (49,11,4350)
INSERT INTO Distance VALUES (50,11,1360)
INSERT INTO Distance VALUES (51,11,780)
INSERT INTO Room VALUES (155, N'1',3,16,1200000,1,1,11)
INSERT INTO Room VALUES (156, N'2',3,16,1200000,1,1,11)
INSERT INTO Room VALUES (157, N'3',3,16,1200000,1,1,11)
INSERT INTO Room VALUES (158, N'4',3,16,1200000,1,1,11)
INSERT INTO Room VALUES (159, N'5',3,16,1200000,0,1,11)

INSERT INTO Province VALUES (9, N'Tiền Giang')
INSERT INTO BoardingHouse VALUES (12, N'Ngọc Phát', 5,'0693112323', N'Số 115 đường 30/04, Khu phố 2, Cai Lậy, Tiền Giang',2,9)
-- Insert row for NearBuiding cong trinh gan cho cu chu(Buiding_ID, Buiding_Name, distance, Buiding_ID, BoardingHouse_ID)
INSERT INTO NearBuiding VALUES (52, N'Trường Cao đẳng Y tế Tiền Giang',2)
INSERT INTO NearBuiding VALUES (53, N'Trường Cao đẳng Tiền Giang (CS1)',2)
INSERT INTO NearBuiding VALUES (54, N'Đại học Tiền Giang',1)
INSERT INTO NearBuiding VALUES (55, N'Trường cao đẳng nông nghiệp Nam Bộ',2)
INSERT INTO NearBuiding VALUES (56, N'Bệnh viện Đa khoa Trung tâm Tiền Giang',3)
INSERT INTO NearBuiding VALUES (57, N'Bệnh viện đa khoa Tâm Minh Đức',3)
INSERT INTO NearBuiding VALUES (58, N'Trung tâm Y tế TP. Mỹ Tho',3)
INSERT INTO NearBuiding VALUES (59, N'Bệnh viện Quân Y 120',3)
INSERT INTO NearBuiding VALUES (60, N'TTTM GO! Mỹ Tho',4)
INSERT INTO NearBuiding VALUES (61, N'TTTM Co.opmart Mỹ Tho',4)
INSERT INTO Distance VALUES (52,12,800)
INSERT INTO Distance VALUES (53,12,1430)
INSERT INTO Distance VALUES (54,12,2450)
INSERT INTO Distance VALUES (55,12,4750)
INSERT INTO Distance VALUES (56,12,2670)
INSERT INTO Distance VALUES (57,12,1340)
INSERT INTO Distance VALUES (58,12,4650)
INSERT INTO Distance VALUES (59,12,2340)
INSERT INTO Distance VALUES (60,12,4540)
INSERT INTO Distance VALUES (61,12,3450)
INSERT INTO Room VALUES (160, N'1',3,20,1400000,1,2,12)
INSERT INTO Room VALUES (161, N'2',3,20,1400000,1,2,12)
INSERT INTO Room VALUES (162, N'3',3,25,1400000,1,1,12)
INSERT INTO Room VALUES (163, N'4',3,25,1400000,1,1,12)
INSERT INTO Room VALUES (164, N'5',3,25,1400000,1,1,12)

INSERT INTO Province VALUES (10, N'Vĩnh Long')
INSERT INTO BoardingHouse VALUES (13, N'Ba Giàu',10,'0832723713', N'Số 11 Khóm Tân Vĩnh Thuận, Tân Ngãi, Vĩnh Long',2,10)
INSERT INTO NearBuiding VALUES (62, N'Trường Đại học Kinh tế ',1)
INSERT INTO NearBuiding VALUES (63, N'Trường Đại học xây dựng Miền Tây',1)
INSERT INTO NearBuiding VALUES (64, N'Trường Đại học Sư phạm Kỹ thuật Vĩnh Long',1)
INSERT INTO NearBuiding VALUES (65, N'Trường Đại học Cửu Long',1)
INSERT INTO NearBuiding VALUES (66, N'Bệnh Viện Đa Khoa Khu Vực Hòa Phú',3)
INSERT INTO NearBuiding VALUES (67, N'Bệnh Viện Đa Khoa Bình Tân',3)
INSERT INTO NearBuiding VALUES (68, N'Bệnh viện Dã chiến',3)
INSERT INTO NearBuiding VALUES (69, N'Bệnh viện đa khoa Vĩnh Long',3)
INSERT INTO NearBuiding VALUES (70, N'TTTM Coopmart Vĩnh Long',4)
INSERT INTO Distance VALUES (62,13,1322)
INSERT INTO Distance VALUES (63,13,1455)
INSERT INTO Distance VALUES (64,13,2465)
INSERT INTO Distance VALUES (65,13,5323)
INSERT INTO Distance VALUES (66,13,2670)
INSERT INTO Distance VALUES (67,13,3424)
INSERT INTO Distance VALUES (68,13,3244)
INSERT INTO Distance VALUES (69,13,1342)
INSERT INTO Distance VALUES (70,13,1233)
INSERT INTO Room VALUES (165, N'1',2,20,1300000,1,2,13)
INSERT INTO Room VALUES (166, N'2',2,20,1300000,0,2,13)
INSERT INTO Room VALUES (167, N'3',3,25,1300000,0,2,13)
INSERT INTO Room VALUES (168, N'4',3,25,1300000,1,2,13)
INSERT INTO Room VALUES (169, N'5',3,25,1300000,0,2,13)
INSERT INTO Room VALUES (170, N'6',2,20,1400000,1,1,13)
INSERT INTO Room VALUES (171, N'7',2,20,1400000,0,1,13)
INSERT INTO Room VALUES (172, N'8',3,25,1400000,1,1,13)
INSERT INTO Room VALUES (173, N'9',3,25,1400000,0,1,13)
INSERT INTO Room VALUES (174,N'10',3,25,1400000,0,1,13)

INSERT INTO Province VALUES (11, N'Đồng Tháp')
INSERT INTO BoardingHouse VALUES (14, N'Tư Sang', 20,'0781219138', N'99 Đường Nguyễn Tất Thành, Phường 1, Sa Đéc, Đồng Tháp',2,11)

INSERT INTO NearBuiding VALUES (71, N'Trường Đại học Đồng Tháp',1)
INSERT INTO NearBuiding VALUES (72, N'Trường Đại Học Quốc Tế',1)
INSERT INTO NearBuiding VALUES (73, N'Trường Cao đẳng Cộng đồng Đồng Tháp',2)
INSERT INTO NearBuiding VALUES (74, N'Trường Cao đẳng Y tế Đồng Tháp',2)
INSERT INTO NearBuiding VALUES (75, N'Bệnh Viện Đa Khoa Đồng Tháp',3)
INSERT INTO NearBuiding VALUES (76, N'Bệnh Viện Quân Dân Y Đồng Tháp',3)
INSERT INTO NearBuiding VALUES (77, N'Bệnh viện Y học cổ truyền Đồng Tháp',3)
INSERT INTO NearBuiding VALUES (78, N'Bệnh Viện Đa khoa Tâm Trí Cao Lãnh',3)
INSERT INTO NearBuiding VALUES (79, N'TTTM Co.opmart Cao Lãnh',4)
INSERT INTO NearBuiding VALUES (80, N'TTTM Vincom Plaza Cao Lãnh',4)
INSERT INTO Distance VALUES (71,14,1555)
INSERT INTO Distance VALUES (72,14,3242)
INSERT INTO Distance VALUES (73,14,2333)
INSERT INTO Distance VALUES (74,14,4767)
INSERT INTO Distance VALUES (75,14,3244)
INSERT INTO Distance VALUES (76,14,2675)
INSERT INTO Distance VALUES (77,14,1243)
INSERT INTO Distance VALUES (78,14,886)
INSERT INTO Distance VALUES (79,14,1233)
INSERT INTO Distance VALUES (80,14,2324)
INSERT INTO Room VALUES (175, N'1',2,20,1150000,1,1,14)
INSERT INTO Room VALUES (176, N'2',2,20,1150000,0,1,14)
INSERT INTO Room VALUES (177, N'3',3,25,1200000,0,1,14)
INSERT INTO Room VALUES (178, N'4',3,25,1200000,1,1,14)
INSERT INTO Room VALUES (179, N'5',3,25,1200000,0,1,14)
INSERT INTO Room VALUES (180, N'6',2,20,1150000,1,1,14)
INSERT INTO Room VALUES (181, N'7',2,20,1150000,0,1,14)
INSERT INTO Room VALUES (182, N'8',3,25,1200000,1,1,14)
INSERT INTO Room VALUES (183, N'9',3,25,1200000,0,1,14)
INSERT INTO Room VALUES (184,N'10',3,25,1200000,0,1,14)
INSERT INTO Room VALUES (185, N'11',2,20,1150000,1,2,14)
INSERT INTO Room VALUES (186, N'12',2,20,1150000,0,2,14)
INSERT INTO Room VALUES (187, N'13',3,25,1200000,0,2,14)
INSERT INTO Room VALUES (188, N'14',3,25,1200000,1,2,14)
INSERT INTO Room VALUES (189, N'15',3,25,1200000,0,2,14)
INSERT INTO Room VALUES (190, N'16',2,20,1150000,1,2,14)
INSERT INTO Room VALUES (191, N'17',2,20,1150000,0,2,14)
INSERT INTO Room VALUES (192, N'18',3,25,1200000,1,2,14)
INSERT INTO Room VALUES (193, N'19',3,25,1200000,0,2,14)
INSERT INTO Room VALUES (194,N'20',3,25,1200000,0,2,14)

INSERT INTO Province VALUES (12, N'Hậu Giang')
INSERT INTO BoardingHouse VALUES (15, N'Ba Kiệt', 25,'0169684318', N'95 Trưng Nhị, Phường 1, Vị Thanh, Hậu Giang',2,12)
INSERT INTO NearBuiding VALUES (81, N'Trường Cao Đẳng Luật Miền Nam',2)
INSERT INTO NearBuiding VALUES (82, N'Trường Đại Học Võ Trường Toản',1)
INSERT INTO NearBuiding VALUES (83, N'Đại Học Cần Thơ Khu Hòa An',1)
INSERT INTO NearBuiding VALUES (84, N'Trường Cao Đẳng Cộng Đồng Hậu Giang',2)
INSERT INTO NearBuiding VALUES (85, N'Bệnh viện đa khoa Hậu Giang',3)
INSERT INTO NearBuiding VALUES (86, N'Bệnh viện Đa khoa Huyện Giồng Riềng',3)
INSERT INTO NearBuiding VALUES (87, N'Bệnh Viện Phổi tinh Hậu Giang',3)
INSERT INTO NearBuiding VALUES (88, N'TTTM Co.opmart Vị Thanh',4)
INSERT INTO NearBuiding VALUES (89, N'TTTM CGV Vincom Hậu Giang',4)
INSERT INTO Distance VALUES (81,14,967)
INSERT INTO Distance VALUES (82,14,1768)
INSERT INTO Distance VALUES (83,14,2132)
INSERT INTO Distance VALUES (84,14,3234)
INSERT INTO Distance VALUES (85,14,2432)
INSERT INTO Distance VALUES (86,14,3424)
INSERT INTO Distance VALUES (87,14,2345)
INSERT INTO Distance VALUES (88,14,3423)
INSERT INTO Distance VALUES (89,14,1233)
INSERT INTO Room VALUES (195, N'1',2,20,1300000,1,2,15)
INSERT INTO Room VALUES (196, N'2',2,20,1300000,0,2,15)
INSERT INTO Room VALUES (197, N'3',2,25,1300000,0,2,15)
INSERT INTO Room VALUES (198, N'4',2,25,1300000,1,2,15)
INSERT INTO Room VALUES (199, N'5',2,25,1300000,0,2,15)
INSERT INTO Room VALUES (200, N'6',2,20,1300000,1,2,15)
INSERT INTO Room VALUES (201, N'7',2,20,1300000,0,2,15)
INSERT INTO Room VALUES (202, N'8',2,25,1300000,1,2,15)
INSERT INTO Room VALUES (203, N'9',2,25,1300000,0,2,15)
INSERT INTO Room VALUES (204, N'10',3,25,1300000,0,2,15)
INSERT INTO Room VALUES (205, N'11',3,20,1300000,1,2,15)
INSERT INTO Room VALUES (206, N'12',3,20,1300000,0,2,15)
INSERT INTO Room VALUES (207, N'13',3,25,1300000,0,2,15)
INSERT INTO Room VALUES (208, N'14',3,25,1300000,1,2,15)
INSERT INTO Room VALUES (209, N'15',3,25,1300000,0,2,15)
INSERT INTO Room VALUES (210, N'16',3,20,1300000,1,2,15)
INSERT INTO Room VALUES (211, N'17',3,20,1300000,0,2,15)
INSERT INTO Room VALUES (212, N'18',4,25,1300000,1,2,15)
INSERT INTO Room VALUES (213, N'19',4,25,1300000,0,2,15)
INSERT INTO Room VALUES (214, N'20',4,25,1300000,0,2,15)
INSERT INTO Room VALUES (215, N'21',4,20,1300000,1,2,15)
INSERT INTO Room VALUES (216, N'22',4,20,1300000,0,2,15)
INSERT INTO Room VALUES (217, N'23',4,25,1300000,0,2,15)
INSERT INTO Room VALUES (218, N'24',4,25,1300000,1,2,15)
INSERT INTO Room VALUES (219, N'25',4,25,1300000,0,2,15)

GO
USE [master]
GO