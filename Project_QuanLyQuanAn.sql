Create Database QuanLyQuanAn
Go

Use QuanLyQuanAn
Go

Create Table ACCOUNT
(
	username nvarchar(100) primary key,
	displayname nvarchar (100) Not Null,
	password nvarchar(1000) Not Null,
	type int Not Null Default 0 --1: Admin && 0: Staff
)
Go


Create Table FOODTABLE
(
	Code char(10) primary key,
	tablename nvarchar(100) Not Null Default N'Unknown',
	table_status int Not Null Default 0 --1: being used && 0: Empty
)
Go


Create Table FOODCategory
(
	Code char(10) primary key,
	foodname nvarchar(100) Not Null Default N'Unknown'
)
Go


Create Table FOOD
(
	Code char(10) primary key,
	foodname nvarchar(100) Not Null Default N'Unknown',
	codeCategory char(10) Not Null,
	price float Not Null Default 0

	Foreign Key(codeCategory) References FOODCategory(Code) 
)
Go

Create Table INVOICE
(
	codeTable char(10) references FOODTABLE(Code) NOT NULL,
	codeFood char(10) references FOOD(Code) NOT NULL,
	foodname nvarchar(50) not null,
	unitPrice float not null,
	quantity int NOT NULL,
	total float
)
Go

Insert ACCOUNT Values
(
	N'admin', N'ADMIN', 'admin', 1
),
(
	N'loc', N'Nguyễn Nhật Lộc', 'loclodo', 0
),
(
	N'khanh', N'Lê Văn Vương Khánh', 'khanhlaptop', 0
),
(
	N'duong', N'Đinh Hải Dương', 'giaosuduong', 0
),
(
	N'phi', N'Phi', 'phiphai', 0
)
Go

Insert FOODCategory Values
(
	'HaiSan',N'Hải sản'
),
(
	'MienNui',N'Miền núi'
),
(
	'Xao',N'Xào'
),
(
	'Canh',N'Canh'
),
(
	'Chien',N'Chiên'
),
(
	'Kho',N'Kho'
),
(
	'Nuong',N'Nướng'
),
(
	'Lau',N'Lẩu'
),
(
	'Nuoc',N'Nước giải khát'
),
(
	'Bia',N'Bia'
),
(
	'TraiCay',N'Trái cây'
),
(
	'Kem',N'Kem'
)
Go


Insert FOOD Values
(
	'MA01',N'Cá rô kho tộ', CAST((Select Code from FOODCategory where foodname = N'Kho') as char), 45000
),
(
	'MA02',N'Cá lóc nướng chui', CAST((Select Code from FOODCategory where foodname = N'Nướng') as char), 60000 
),
(
	'MA03',N'Canh khổ qua', CAST((Select Code from FOODCategory where foodname = N'Canh') as char), 35000
),
(
	'MA04',N'Lẩu cua đồng', CAST((Select Code from FOODCategory where foodname = N'Lẩu') as char), 120000
),
(
	'MA05',N'Đùi gà chiên nước mắm', CAST((Select Code from FOODCategory where foodname = N'Chiên') as char), 30000
),
(
	'MA06',N'Mì ống xào', CAST((Select Code from FOODCategory where foodname = N'Xào') as char), 32000
),
(
	'MA07',N'Tôm hấp bia', CAST((Select Code from FOODCategory where foodname = N'Hải sản') as char), 90000
),
(
	'MA08',N'Mực', CAST((Select Code from FOODCategory where foodname = N'Hải sản') as char), 180000
),
(
	'MA09',N'Hoa quả dầm', CAST((Select Code from FOODCategory where foodname = N'Trái cây') as char), 40000
),
(
	'MA10',N'Tiger', CAST((Select Code from FOODCategory where foodname = N'Bia') as char), 350000
)
Go

Insert FOODTABLE(Code, tablename) Values
(
	'BA01', 'Bàn 01'
),
(
	'BA02', 'Bàn 02'
),
(
	'BA03', 'Bàn 03'
),
(
	'BA04', 'Bàn 04'
),
(
	'BA05', 'Bàn 05'
),
(
	'BA06', 'Bàn 06'
),
(
	'BA07', 'Bàn 07'
),
(
	'BA08', 'Bàn 08'
),
(
	'BA09', 'Bàn 09'
),
(
	'BA10', 'Bàn 10'
)
GO

--Tao bang doanh thu
Create Table REVENUEBYMONTH
(
	ID int identity (1,1) primary key,
	ByDate Date DEFAULT GETDATE(),
	Gain decimal(18,3)
)
GO

--Tao bang nhap hang
Create Table IMPORT
(
	ID int identity(1,1),
	ImportCode char(10) primary key NOT NULL,
	ByDate Date DEFAULT GETDATE(),
	Name nvarchar(50) NOT NULL,
	Quantity int NOT NULL,
	CalculationUnit char(2) DEFAULT 'KG',
	PriceUnit decimal(18,3) NOT NULL,
	SubTotal decimal(18,3) NOT NULL
)
Go

--Tao bang loi nhuan
Create Table STATISTIC
(
	ID int identity(1,1),
	StatisticCode char(10) primary key NOT NULL,
	ByDate char(10) DEFAULT CONCAT(YEAR(GETDATE()),'-',RIGHT('0' + RTRIM(MONTH(GETDATE())), 2)),
	Revenue Decimal(18,3),
	SubTotal_IMPORT Decimal(18,3),
	Profit Decimal(18,3),
	Growth float
)
GO

--select LEFT(CONVERT(VARCHAR(10),ByMonth,112),6) + '-' + RIGHT(REPLICATE('0',4) + CONVERT(VARCHAR(5),ROW_NUMBER() OVER(PARTITION BY ByMonth ORDER BY ID)),5)  from REVENUEBYMONTH


Create PROC sp_Login(
					 @userName nvarchar(100), 
					 @passWord nvarchar(1000))
AS
Begin
	Select *
	From ACCOUNT
	Where username = @userName and password = @passWord
End
GO

--Insert, Delete, UPdate 

--Insert
Create PROC sp_insertFOOD(@code char(10), @foodName nvarchar(100), @catagoryName nvarchar(100), @price float)
AS
Begin
	Set nocount on;
	Insert FOOD (Code, foodname, codeCategory, price) Values
	(@code ,@foodName, CAST((Select Code From FOODCategory Where foodname = @catagoryName) as char(10)), @price)
End
Go

--EXECUTE sp_insertFOOD @code = 'MA11' ,@foodName = N'Kem Chuối', @catagoryName = N'Kem', @price = 10000

--Delete cho mọi loại bảng
Create PROC sp_deleteFOOD(@table nvarchar (100), @whereClause nvarchar(1000))
AS
Begin
	Set nocount on
	Declare @deleteAll nvarchar(1000)
	Begin
		Select @deleteAll = 'Delete From ' + @table + ' ' + @whereClause
		EXEC(@deleteAll)
	End
End
Go

--Exec sp_deleteFOOD 'ACCOUNT', 'Where username = ''ggeewrwrule'''

--Update cho mọi bảng
Create PROC sp_updateFOOD(@table nvarchar (100), @setClause nvarchar(1000), @whereClause nvarchar(1000))
AS
Begin
	Set nocount on
	Declare @updateAll nvarchar(1000)
	Begin
		Select @updateAll = 'Update '+ @table + ' Set ' + @setClause + ' Where ' + @whereClause
		EXEC(@updateAll)
	End
End
Go

--Drop PROC sp_updateFOOD

--EXEC sp_updateFOOD 'FOOD', 'foodname = N''Kem Chuối''', ' Code = ''MA11'''
--Select * from FOOD

--Tìm kiếm

Create PROC sp_Search(@table nvarchar(1000), @columnName nvarchar(100), @value nvarchar(100))
AS
Declare @temp nvarchar(100)
Set @temp = QUOTENAME('%' + @value + '%',N'''')
Begin
	Set nocount on
	Declare @searchAll nvarchar(1000)
	Begin
		Select @searchAll = 'Select * From ' + @table + ' Where 1=1 And ' + @columnName + ' LIKE N' + @temp
		EXEC (@searchAll)
	End
End
Go

--				[bang]  [cot]	  [ki tu can tim]
--EXEC sp_Search 'FOOD', 'foodname' , N'nướng'

--Bill

--Them gia tri vao bang de tinh tung mon an

Create PROC sp_insertInvoice (@tablecode char(10), @foodcode char(10), @quantity int)
AS
Begin
	Set nocount on
	if(exists (Select codeTable, codeFood From INVOICE Where @tablecode = codeTable and @foodcode = codeFood))
	Begin
		Update INVOICE
		Set quantity = quantity + @quantity
		Where @foodcode = codeFood and codeTable = @tablecode
		Update INVOICE
		Set	total = quantity * unitPrice
		Where @foodcode = codeFood and codeTable = @tablecode
	END
	Else
	Begin
		Insert INVOICE(codeTable, codeFood, foodname, unitPrice, quantity, total)
		Values (@tablecode  , @foodcode, CAST((Select foodname as N'Tên món' From FOOD Where @foodcode = Code) as nvarchar(50)), Cast((Select price From FOOD Where @foodcode = Code) as float), @quantity, (@quantity * (Cast((Select price From FOOD Where @foodcode = Code) as float))))
		Update FOODTABLE
		Set table_status = 1
		Where @tablecode = Code
	End
End
Go


--Drop PROC sp_insertInvoice
--EXEC sp_insertInvoice 'BA02', 'MA01', 2
--Exec sp_deleteFOOD 'INVOICE', 'Where codeTable = ''BA02'''


if(OBJECT_ID(N'fn_Invoice') IS NOT NULL)
	Drop function fn_Invoice
Go

Create FUNCTION fn_Invoice (@table char(10))
Returns @rtnTable table (
							totalALL float
						)
AS
Begin
	Declare @totalALL float
	Declare @TempTable table (tablecode char(10), foodcode char(10),foodname nvarchar(100), unitprice float, quantity int, total float)
	--Truyen bang muon thanh toan vao gia tri bang tam
	Insert into @TempTable
	Select * from INVOICE Where @table = codeTable
	--Lay tong total trong @temptable de tinh totalALL
	Insert into @rtnTable
	Select SUM(quantity * unitprice) From @TempTable as TT where @table = tablecode
	Return
End
Go

--Show các món ăn mà bàn ăn đó gọi và số tiền phải trả
Create PROC sp_Invoice(@table char(10))
AS
Begin
	
	if(@table in (Select codeTable From INVOICE Where @table = codeTable))
	Begin
		Select * From INVOICE Where @table = codeTable
		Select * From dbo.fn_Invoice(@table)
	End
End
Go

--EXEC sp_Invoice 'BA01'

Create PROC sp_updateStatus(@table char(10), @status nvarchar(20))
AS
Begin
	if(@status = N'Đã thanh toán' AND 1 = (Select table_status From FOODTABLE Where @table = Code))
	Begin	
	--Xoa cac mon an ve ban da than toan
		Delete From INVOICE Where @table = codeTable 
	--Cap nhat lai trang thai ban ve 0 khi da thanh toan
		if(@table not in (Select codeTable From INVOICE Where codeTable = @table))
		Begin
			Update FOODTABLE
			Set table_status = 0
			Where Code = @table
		End
	End
End
Go

--Drop PROC sp_updateStatus
--EXEC sp_updateStatus 'BA02',N'Đã thanh toán'

Create TRIGGER trg_InsertREV on INVOICE
After Delete
AS
Begin
	insert REVENUEBYMONTH (Gain) Values
	(
		CAST((Select SUM(quantity * unitPrice) From deleted) as decimal(18,3))
	)
End
Go

--Drop Trigger trg_InsertREV

Create PROC sp_ViewREV(@thang char(2), @nam char(4))
AS
Begin
	Select SUBSTRING(CONVERT(char(8),ByDate,112),5,2) as N'Tháng', SUBSTRING(CONVERT(char(8),ByDate,112),1,4) as N'Năm', SUM(Gain) as N'Doanh Thu'
	From REVENUEBYMONTH
	Where @thang = CAST(MONTH(ByDate) as char(2)) and @nam = Cast(YEAR(ByDate) as char(4))
	Group by SUBSTRING(CONVERT(char(8),ByDate,112),5,2), SUBSTRING(CONVERT(char(8),ByDate,112),1,4)
End
GO

--drop PROC sp_ViewREV
--EXEC sp_ViewREV '4','2021'

--Tao khoa chinh bang SEQUENCE cho IMPORT
CREATE SEQUENCE IMPORT_Seq
AS INTEGER
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 1000
	NO CYCLE;
GO
--Select Concat(FORMAT(DATEADD(year, 0 ,GETDATE()),'yy'), RIGHT('0' + RTRIM(MONTH(GETDATE())), 2),  RIGHT('00000' + CAST(NEXT VALUE FOR IMPORT_Seq AS VARCHAR(6)),5))
--Alter sequence BILL_Seq Restart with 1

--Them cac gia tri vao bang IMPORT

Create PROC sp_insertImport(@name nvarchar(100), @quantity int, @unitprice decimal(18,3))
AS
Begin
	Set nocount on
	--Neu khac so thang hoac nam trong bang be hon nam hien tai thi vao cau lenh if
	if(Select Cast(SUBSTRING((Select Top 1 ImportCode From IMPORT Order by ID desc),3,4) as int)) != Cast(YEAR(GetDate()) as int) or Cast(SUBSTRING(CONVERT(char(8),(Select TOP 1 ImportCode From IMPORT Order by ID desc),112),7,2) as int) < Cast(MONTH(GETDATE()) as int)
	Begin
		--Reset ID trong bang ve lai 1 neu sang thang moi
		Alter sequence IMPORT_Seq Restart with 1
		Insert IMPORT(ImportCode, Name, Quantity, PriceUnit, SubTotal)
		--Chuoi khoa chinh: IM + So Nam(4 so)+ So thang(2 so)+ So don vi tang dan theo so lan them(4 so)
		Values(Concat('IM', LEFT(CONVERT(Char(6),GETDATE(),112),6), RIGHT('00' + CAST(NEXT VALUE FOR IMPORT_Seq AS VARCHAR(3)),2)), @name, @quantity, @unitprice, (@quantity * @unitprice))
	End
	else
	Begin
		Insert IMPORT(ImportCode, Name, Quantity, PriceUnit, SubTotal)
		Values(Concat('IM', LEFT(CONVERT(Char(6),GETDATE(),112),6), RIGHT('00' + CAST(NEXT VALUE FOR IMPORT_Seq AS VARCHAR(3)),2)), @name, @quantity, @unitprice, (@quantity * @unitprice))
	End
End
Go

/*Delete from STATISTIC
DBCC CHECKIDENT ('STATISTIC',Reseed,0)*/

/*drop PROC sp_insertImport
EXEC sp_insertImport N'Mực', 20, 25000*/

/*Delete From IMPORT
DBCC CHECKIDENT ('IMPORT',RESEED,0)*/

Create PROC sp_UpdateStat
AS
Begin
	set nocount on
	if(exists (Select StatisticCode From STATISTIC))
	Begin
	--An 2 lan de cap nhat so lieu neu chua co ma do trong Statistic
		Update STATISTIC
		Set Revenue = (Select SUM(Gain) From REVENUEBYMONTH)
		Where (Select Top 1 Cast(SUBSTRING(ByDate,1,4) as int) From STATISTIC Order by ID desc) = (Select Top 1 CAST(YEAR(ByDate) as int) From REVENUEBYMONTH Order by ID desc) 
				AND (Select Top 1 Cast(SUBSTRING(ByDate,6,2) as int) From STATISTIC Order by ID desc) = (Select Top 1 CAST(MONTH(ByDate) as int) From REVENUEBYMONTH Order by ID desc)
		Update STATISTIC
		Set SubTotal_IMPORT = (Select Sum(SubTotal) From IMPORT)
		Where (Select Top 1 Cast(SUBSTRING(StatisticCode,1,4) as int) From STATISTIC Order by ID desc) = (Select Top 1 CAST(YEAR(ByDate) as int) From IMPORT Order by ID desc) 
				AND (Select Top 1 Cast(SUBSTRING(StatisticCode,5,2) as int) From STATISTIC Order by ID desc) = (Select Top 1 CAST(MONTH(ByDate) as int) From IMPORT Order by ID desc)
		--Tao bien de lay ID cuoi cung
		Declare @lastID int
		Select @lastID = Max(ID) From STATISTIC
		Update STATISTIC
		Set Profit = (Select Top 1 (Revenue - SubTotal_IMPORT) From STATISTIC Order by ID desc)
		Where ID = @lastID
		--Cap nhat tran thai tang truong theo thang so voi thang dau tien trong bang Statistic
		Update STATISTIC
		Set Growth = CAST((((Select Top 1 Profit From STATISTIC Order by ID desc)-(Select Top 1 Profit From STATISTIC Order by ID asc))/(Select Top 1 Profit From STATISTIC Order by ID asc)) * 100 as decimal(18,1))
		Where ID = @lastID
	End
	Else
	Begin
	--Tao trc ma cua bang Statistic
		Insert STATISTIC (StatisticCode) Values ((LEFT(CONVERT(Char(10),GETDATE(),112),6)))
	End
End
Go
