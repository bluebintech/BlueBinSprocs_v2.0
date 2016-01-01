Use [BlueBinHardware]


/*

CREATE ROLE [appusers]
GO
drop table dbo.Customer
drop table dbo.Vendor
drop table dbo.Item
drop table dbo.ItemCustomerCost
drop table dbo.PO
drop table dbo.ClientInvoice
drop table dbo.VendorInvoice
drop table dbo.POLine
drop table dbo.ClientInvoiceLine
drop table dbo.VendorInvoiceLine

*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--*****************************************************
--**************************NEWTABLE**********************

/****** Object:  Table [dbo].[Vendor]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'Vendor')
BEGIN
CREATE TABLE [dbo].[Vendor](
	[VendorID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[VendorName] [varchar](55) NOT NULL,
	[Address] [varchar](500) NULL,
	[City] [varchar](25) NULL,
	[State] [char](2) NULL,
	[Zipcode] [char](5) NULL,
	[Notes] [varchar](500) NULL
)

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[Customer]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'Customer')
BEGIN
CREATE TABLE [Customer](
	[CustomerID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[CustomerName] [varchar](55) NOT NULL,
	[ShippingAddress] [varchar](500) NOT NULL,
	[City] [varchar](25) NOT NULL,
	[State] [char](2) NOT NULL,
	[Zipcode] [char](5) NOT NULL,
	[Notes] [varchar](500) NULL
)

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[Item]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'Item')
BEGIN
CREATE TABLE [dbo].[Item](
	[ItemID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[ItemNumber] [varchar](30) NOT NULL,
	[ItemDescription] [varchar](50) NOT NULL,
	[VendorID] [int] NOT NULL,
	[VendorItemNumber] [varchar](35) NOT NULL,
	[UOM] [char](2) NOT NULL,
	[OrderUOM] [char](2) NOT NULL,
	[OrderUOMqty] [int] NOT NULL,
	[BBunitCost] [money] NOT NULL
)

ALTER TABLE [dbo].[Item]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])
END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[ItemCustomerCost]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'ItemCustomerCost')
BEGIN
CREATE TABLE [dbo].[ItemCustomerCost](
	[ItemCustomerCostID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[ItemID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CustomUnitCost] [money] NOT NULL,
	[IsDefault] [int] NOT NULL
)


ALTER TABLE [dbo].[ItemCustomerCost]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])

ALTER TABLE [dbo].[ItemCustomerCost]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[PO]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'PO')
BEGIN
CREATE TABLE [dbo].[PO](
	[POID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[PO] [varchar](10) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[Total] [money] NOT NULL,
	[OrderDate] [date] NOT NULL

)

ALTER TABLE [dbo].[PO]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])

ALTER TABLE [dbo].[PO]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])

END
GO


--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[ClientInvoice]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'ClientInvoice')
BEGIN
CREATE TABLE [dbo].[ClientInvoice](
	[ClientInvoiceID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ClientInvoice] [varchar](10) NOT NULL,
	[POID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Subtotal] [money] NOT NULL,
	[Tax] [money] NOT NULL,
	[Shipping] [money] NOT NULL,
	[Total] [money] NOT NULL
)

ALTER TABLE [dbo].[ClientInvoice]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])

ALTER TABLE [dbo].[ClientInvoice]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[VendorInvoice]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'VendorInvoice')
BEGIN
CREATE TABLE [dbo].[VendorInvoice](
	[VendorInvoiceID] [INT] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[VendorInvoice] [varchar](20) NOT NULL,
	[POID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Subtotal] [money] not null,
	[Tax] [money] NOT NULL,
	[Shipping] [money] NOT NULL,
	[Total] [money] NOT NULL,
	[ShipDate] [date] NULL,
	[ReceiveDate] [date] NULL
 )


ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])


ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])


ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])

END
GO
--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[POLine]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'POLine')
BEGIN
CREATE TABLE [dbo].[POLine](
	[POID] [int] NOT NULL,
	[POLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal] [money] NOT NULL
 )


ALTER TABLE [dbo].[POLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])

ALTER TABLE [dbo].[POLine]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[ClientInvoiceLine]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'ClientInvoiceLine')
BEGIN
CREATE TABLE [dbo].[ClientInvoiceLine](
	[ClientInvoiceID] [int] NOT NULL,
	[ClientInvoiceLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal] [money] NOT NULL,

)

ALTER TABLE [dbo].[ClientInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ClientInvoiceID])
REFERENCES [dbo].[ClientInvoice] ([ClientInvoiceID])


ALTER TABLE [dbo].[ClientInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])

END
GO

--*****************************************************
--**************************NEWTABLE**********************
/****** Object:  Table [dbo].[VendorInvoiceLine]    Script Date: 12/29/2015/ ******/
if not exists (select * from sys.tables where name = 'VendorInvoiceLine')
BEGIN
CREATE TABLE [dbo].[VendorInvoiceLine](
	[VendorInvoiceID] [int] NOT NULL,
	[VendorInvoiceLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal] [money] NOT NULL
)


ALTER TABLE [dbo].[VendorInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])

ALTER TABLE [dbo].[VendorInvoiceLine]  WITH CHECK ADD FOREIGN KEY([VendorInvoiceID])
REFERENCES [dbo].[VendorInvoice] ([VendorInvoiceID])

END
GO


SET ANSI_PADDING OFF
GO

Print 'Tables Created'

--*****************************************************--*****************************************************--*****************************************************
--*****************************************************SPROCS--*****************************************************

--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectPO') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectPO
GO


CREATE PROCEDURE sp_SelectPO
@POID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 

		a.POID,
		b.PO,
		a.POLine,
		c.ItemDescription,
		a.Qty,
		a.Subtotal
 FROM [POLine] a
 inner join [PO] b on a.POID = b.POID
 inner join [Item] c on a.ItemID = c.ItemID
 WHERE a.POID = @POID

END

GO
grant exec on sp_SelectPO to appusers
GO

--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareOrders') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareOrders
GO

--exec sp_SelectHardwareOrders 'MHS'
CREATE PROCEDURE sp_SelectHardwareOrders
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
            a.POID,
            a.PO,
            c.CustomerName,
            v.VendorName,
            a.Total,
            a.OrderDate
             FROM [PO] a
            inner join Customer c on a.CustomerID = c.CustomerID
            inner join Vendor v on a.VendorID = v.VendorID
            where c.CustomerName = @HardwareCustomer
END

GO
grant exec on sp_SelectHardwareOrders to appusers
GO
--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectClientInvoiceLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectClientInvoiceLines
GO

--exec sp_SelectClientInvoiceLines 43

CREATE PROCEDURE sp_SelectClientInvoiceLines
@ClientInvoiceID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 

		a.ClientInvoiceID,
		b.ClientInvoice,
		a.ClientInvoiceLine,
		c.ItemDescription,
		a.Qty,
		a.UnitCost,
		a.Subtotal
 FROM [ClientInvoiceLine] a
 inner join [ClientInvoice] b on a.ClientInvoiceID = b.ClientInvoiceID
 inner join [Item] c on a.ItemID = c.ItemID
 WHERE a.ClientInvoiceID = @ClientInvoiceID

END

GO
grant exec on sp_SelectClientInvoiceLines to appusers
GO

--*****************************************************
--**************************NEWSPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectClientInvoice') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectClientInvoice
GO

--exec sp_SelectClientInvoice 'UTMC'
CREATE PROCEDURE sp_SelectClientInvoice
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
            a.POID,
            p.PO,
			a.ClientInvoiceID,
			a.ClientInvoice,
            c.CustomerName,
            v.VendorName,
            a.SubTotal,
			a.Tax,
			a.Shipping,
			a.Total,
            p.OrderDate
             FROM [ClientInvoice] a
			inner join PO p on a.POID = p.POID
            inner join Customer c on a.CustomerID = c.CustomerID
            inner join Vendor v on p.VendorID = v.VendorID
            where c.CustomerName = @HardwareCustomer
END

GO
grant exec on sp_SelectClientInvoice to appusers
GO

--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareItemSourceDetailed') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareItemSourceDetailed
GO

--exec sp_SelectHardwareItemSourceDetailed 'MHS'
CREATE PROCEDURE sp_SelectHardwareItemSourceDetailed
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
		i.[ItemID]
      ,i.[ItemNumber]
      ,i.[ItemDescription]
      ,v.[VendorName]
      ,i.[VendorItemNumber]
      ,i.[UOM]
      ,i.[OrderUOM]
      ,i.[OrderUOMqty]
	  ,icc.CustomUnitCost
  FROM [Item] i
  inner join Vendor v on i.VendorID = v.VendorID
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareItemSourceDetailed to appusers
GO
--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareItemSource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareItemSource
GO

--exec sp_SelectHardwareItemSource 'MHS'
CREATE PROCEDURE sp_SelectHardwareItemSource
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	        SELECT 
		i.[ItemID]
      ,i.[ItemNumber]
      ,i.[ItemDescription]
      
  FROM [Item] i
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareItemSource to appusers
GO
--*****************************************************
--**************************NEWSPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareUOMCostSource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareUOMCostSource
GO

--exec sp_SelectHardwareUOMCostSource 'MHS'
CREATE PROCEDURE sp_SelectHardwareUOMCostSource
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
		i.[ItemID]
      ,i.[UOM]
      ,i.[OrderUOM]
      ,i.[OrderUOMqty]
	  ,icc.CustomUnitCost
  FROM [Item] i
  inner join Vendor v on i.VendorID = v.VendorID
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareUOMCostSource to appusers
GO
--*****************************************************
--**************************NEWSPROC**********************

--*****************************************************
--**************************NEWSPROC**********************

--*****************************************************
--**************************NEWSPROC**********************

Print 'Sprocs Updated'


/*
select * from Customer
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('TJUH','Thomas Jefferson Hospital JHN 900 Walnut Street Attn: BlueBin Project','Philadelphia','PA','19107','Important: Call TJUH Receiving for Delivery Appt 215-955-7017')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('Caldwell','Caldwell UNC Healthcare 321 Mulberry St Sw Attn: BlueBin Project','Lenoir','NC','28645','Ship Via 3rd party carrier below: Cardinal Optifreight Fedex Acct#: 1480-5096-1 Contact Info: OptiFreightWebCustomerCare@cardinalhealth.com')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('CHOMP','Community Hospital of the Monterey Peninsula 2101 Del Monte Ave. Attn: BlueBin Project','Monterey','CA','93940','')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('MHS','Martin Health System 2127 SE Ocean Blvd Attn: BlueBin Project','Stuart','FL','34995','')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('UTMC','The University of Toledo Attn: Kyle/BlueBin 3000 Arlington Ave','Toledo','OH','43614','Important: Call UTMC dock manager for Delivery appt 419-383-5085')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('VCU','VCU Health System Attn: Don Adams 403 North 13th Street','Richmond','VA','23298','')
insert into Customer (CustomerName,ShippingAddress,City,State,Zipcode,Notes) VALUES ('Demo','3513 NE 45th Street','Seattle','WA','98105','Used for Demo Only')

select * from Vendor
insert into Vendor (VendorName,Address,City,State,Zipcode,Notes) VALUES ('Akro Mils','','','','','')
insert into Vendor (VendorName,Address,City,State,Zipcode,Notes) VALUES ('InterMetro','','','','','')

select * from Item
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN110B','110 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30110BLUE','EA','CA','24','0.68')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN224B','224 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30224BLUE','EA','CA','12','1.56')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN230B','230 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30230BLUE','EA','CA','12','2')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN235B','235 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30235BLUE','EA','CA','6','3.64')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN239B','239 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30239BLUE','EA','CA','6','3.88')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN255B','255 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30255BLUE','EA','CA','6','5.05')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN250B','250 Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30250BLUE','EA','CA','6','5.62')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN250C','250 Bin Clear',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30250C','EA','CA','6','5.78')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN305A3','Stage Bin Clear',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'305A3','EA','CA','16','2.64')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN124B','Long Bin Small Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30124BLUE','EA','CA','12','2.49')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN164B','Long Bin Medium Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30164BLUE','EA','CA','6','3.45')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN184B','Long Bin Large Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30184BLUE','EA','CA','6','4.41')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN210B','210 Short Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30210BLUE','EA','CA','24','0.53')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN220B','220 Short Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30220BLUE','EA','CA','24','1.12')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('BIN237B','237 Short Bin Blue',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'30237BLUE','EA','CA','12','2.61')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SLAT55','Slat Covers',(Select VendorID from Vendor where VendorName = 'InterMetro'),'9990CL5','EA','EA','1','6.34')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH6024CQ','60x24 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A2460NC','EA','CA','2','37.97')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH4824CQ','48x24 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A2448NC','EA','CA','4','32.33')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH3624CQ','36x24 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A2436NC','EA','CA','4','27.91')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH2424CQ','24x24 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A2424NC','EA','CA','4','26.84')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('POST63','Post 63 Inch',(Select VendorID from Vendor where VendorName = 'InterMetro'),'63UP','EA','CA','4','7.47')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('WH5BMP','Wheel w/o Brake',(Select VendorID from Vendor where VendorName = 'InterMetro'),'5MDA','EA','EA','1','9.91')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('WH5BR','Wheel w/Brake',(Select VendorID from Vendor where VendorName = 'InterMetro'),'5MDBA','EA','EA','1','12.05')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('LINER4824','Shelf Liner 48 Inch',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'AW2448LINER','EA','CA','4','7.31')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('LINER6024','Shelf Liner 60 Inch',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'AW2460LINER','EA','CA','4','9.12')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('DIV824','Shelf Divider 8x24 Inch',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'AWDIVIDER24','EA','CA','4','5.92')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('LDG24','Shelf Ledge',(Select VendorID from Vendor where VendorName = 'Akro Mils'),'AWLEDGE24','EA','CA','4','2.75')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('CAGE36','Security Cage 36x24',(Select VendorID from Vendor where VendorName = 'InterMetro'),'SEC53EC','EA','EA','1','432.8')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('CAGE48','Security Cage 48x24',(Select VendorID from Vendor where VendorName = 'InterMetro'),'SEC55EC','EA','EA','1','858.5')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('CAGE60','Security Cage 60x24',(Select VendorID from Vendor where VendorName = 'InterMetro'),'SEC56EC','EA','EA','1','918.5')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH4818CQ','48x18 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A1848NC','EA','EA','1','26.54')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH4218CQ','42x18 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A1842NC','EA','EA','1','26.54')
insert into Item (ItemNumber,ItemDescription,VendorID,VendorItemNumber,UOM,OrderUOM,OrderUOMqty,BBUnitCost) VALUES ('SH7224CQ','72x24 Shelf',(Select VendorID from Vendor where VendorName = 'InterMetro'),'A2472NC','EA','EA','1','44.99')


select * from ItemCustomerCost

insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1.12','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'2.86','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'4.4','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'4.74','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'6.58','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7.9','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7.9','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3.32','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'4.76','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'5.8','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'0.95','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1.4','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7.45','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'44.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'37.34','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'32.67','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'31.12','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7.95','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'11.34','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'14.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'8.11','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'9.84','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7.75','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'50.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'0.9','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1.56','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2.55','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3.88','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'4.36','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'6.29','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'6.6','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'6.7','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2.96','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2.85','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3.92','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'5.03','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1.4','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'7.28','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'44.82','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'38.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'32.1','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'9.06','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'12.15','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'14.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'8.19','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'9.84','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'7.62','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3.67','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'50.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'3.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'4.99','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'6.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'8.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'10.3','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'11.29','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'15.28','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'3.7','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'5.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'7.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'8.8','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'3.1','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'8.28','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'45.85','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'39.04','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'33.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'32.41','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'9.02','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'12.15','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'14.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'8.52','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'9.86','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'11.05','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'3.78','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'50.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'1.12','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'1.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'2.86','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4.4','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4.74','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'6.58','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'7.9','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'7.9','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'3.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'3.32','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4.76','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'5.8','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'1.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'1.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'3','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'7.45','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'44.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'37.34','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'32.67','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'31.12','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'9.02','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'11.34','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'14.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'8.11','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'9.84','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'7.75','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'3.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'50.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'VCU'),'0.93','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'VCU'),'1.98','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'VCU'),'2.51','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'3.83','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'4.04','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'6.05','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'6.32','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'7.02','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'VCU'),'3.44','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'VCU'),'2.58','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'3.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'VCU'),'6.32','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'VCU'),'0.87','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'VCU'),'1.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'VCU'),'2.87','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'6.34','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'VCU'),'38.97','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'33.55','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'28.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'27.53','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'7.6','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'10.02','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'12.23','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'7.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'9.12','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'7.05','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'VCU'),'4.75','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'VCU'),'44.99','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN110B' and ItemDescription = '110 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Demo'),'1.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN224B' and ItemDescription = '224 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Demo'),'3.13','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN230B' and ItemDescription = '230 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Demo'),'4.99','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN235B' and ItemDescription = '235 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'6.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN239B' and ItemDescription = '239 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'8.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN255B' and ItemDescription = '255 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'10.3','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250B' and ItemDescription = '250 Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'11.29','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN250C' and ItemDescription = '250 Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'15.28','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN305A3' and ItemDescription = 'Stage Bin Clear' and OrderUOM = 'CA' and OrderUOMqty = '16'),(Select CustomerID from Customer where CustomerName = 'Demo'),'3.7','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN124B' and ItemDescription = 'Long Bin Small Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Demo'),'5.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN164B' and ItemDescription = 'Long Bin Medium Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'7.31','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN184B' and ItemDescription = 'Long Bin Large Blue' and OrderUOM = 'CA' and OrderUOMqty = '6'),(Select CustomerID from Customer where CustomerName = 'Demo'),'8.8','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN210B' and ItemDescription = '210 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Demo'),'1.25','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN220B' and ItemDescription = '220 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '24'),(Select CustomerID from Customer where CustomerName = 'Demo'),'1.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'BIN237B' and ItemDescription = '237 Short Bin Blue' and OrderUOM = 'CA' and OrderUOMqty = '12'),(Select CustomerID from Customer where CustomerName = 'Demo'),'3.1','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SLAT55' and ItemDescription = 'Slat Covers' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'8.28','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH6024CQ' and ItemDescription = '60x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '2'),(Select CustomerID from Customer where CustomerName = 'Demo'),'45.85','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4824CQ' and ItemDescription = '48x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'39.04','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH3624CQ' and ItemDescription = '36x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'33.71','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH2424CQ' and ItemDescription = '24x24 Shelf' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'32.41','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST63' and ItemDescription = 'Post 63 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'9.02','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'POST74' and ItemDescription = 'Post 74 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'10','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BMP' and ItemDescription = 'Wheel w/o Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'12.15','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'WH5BR' and ItemDescription = 'Wheel w/Brake' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'14.5','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER4824' and ItemDescription = 'Shelf Liner 48 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'8.52','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LINER6024' and ItemDescription = 'Shelf Liner 60 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'9.86','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'DIV824' and ItemDescription = 'Shelf Divider 8x24 Inch' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'11.05','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'LDG24' and ItemDescription = 'Shelf Ledge' and OrderUOM = 'CA' and OrderUOMqty = '4'),(Select CustomerID from Customer where CustomerName = 'Demo'),'3.78','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE36' and ItemDescription = 'Security Cage 36x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'810.24','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE48' and ItemDescription = 'Security Cage 48x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'900.16','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'CAGE60' and ItemDescription = 'Security Cage 60x24' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'1047.72','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4818CQ' and ItemDescription = '48x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH4218CQ' and ItemDescription = '42x18 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'31.54','1')
insert into ItemCustomerCost (ItemID,CustomerID,CustomUnitCost,IsDefault) VALUES ((Select ItemID from Item where ItemNumber = 'SH7224CQ' and ItemDescription = '72x24 Shelf' and OrderUOM = 'EA' and OrderUOMqty = '1'),(Select CustomerID from Customer where CustomerName = 'Demo'),'50.25','1')


Select * from PO

insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1004',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42190,112)),101),'3686.64')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1005',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42191,112)),101),'961.92')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1006',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42191,112)),101),'6762.16')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1007',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42212,112)),101),'252.84')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1008',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42214,112)),101),'3250.64')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1009',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42214,112)),101),'1751.12')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1010',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42218,112)),101),'107.36')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1011',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42224,112)),101),'998')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1012',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42228,112)),101),'852.72')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1013',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42228,112)),101),'10718.92')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1014',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42231,112)),101),'2800.88')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1015',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42231,112)),101),'6543.2')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1016',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42259,112)),101),'1660.96')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1017',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42259,112)),101),'2263.6')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1018',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42260,112)),101),'2115.52')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1019',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42260,112)),101),'7869.2')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1020',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42266,112)),101),'750.72')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1021',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42275,112)),101),'2605.04')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1022',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42275,112)),101),'6920.76')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1023',(select CustomerID from Customer where CustomerName = 'TJUH'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42277,112)),101),'1195.2')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1024',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42277,112)),101),'189.92')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1025',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42277,112)),101),'9057.52')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1026',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42282,112)),101),'239.04')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1027',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42289,112)),101),'878.4')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1028',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42295,112)),101),'545.76')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1029',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42295,112)),101),'2141.4')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1030',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42304,112)),101),'322.68')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1031',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42304,112)),101),'432.8')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1032',(select CustomerID from Customer where CustomerName = 'UTMC'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42308,112)),101),'4631.64')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1033',(select CustomerID from Customer where CustomerName = 'UTMC'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42308,112)),101),'6886.9')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1034',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42312,112)),101),'408')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1035',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42315,112)),101),'932.16')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1036',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42319,112)),101),'299.52')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1037',(select CustomerID from Customer where CustomerName = 'VCU'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42319,112)),101),'1799.6')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1038',(select CustomerID from Customer where CustomerName = 'VCU'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42322,112)),101),'5201.08')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1039',(select CustomerID from Customer where CustomerName = 'VCU'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42322,112)),101),'9545.6')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1040',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42336,112)),101),'408')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1041',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42339,112)),101),'3186.8')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1042',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42339,112)),101),'6886.6')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1043',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42340,112)),101),'1443.44')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1044',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42340,112)),101),'1865.76')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1045',(select CustomerID from Customer where CustomerName = 'UTMC'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42346,112)),101),'2872.08')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1046',(select CustomerID from Customer where CustomerName = 'UTMC'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42346,112)),101),'4202.86')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1047',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42346,112)),101),'42.24')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1048',(select CustomerID from Customer where CustomerName = 'UTMC'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42347,112)),101),'346.8')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1049',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42350,112)),101),'1082.88')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1050',(select CustomerID from Customer where CustomerName = 'CHOMP'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42354,112)),101),'58.48')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO1051',(select CustomerID from Customer where CustomerName = 'Caldwell'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42364,112)),101),'1472.64')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO9905',(select CustomerID from Customer where CustomerName = 'Demo'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42191,112)),101),'961.92')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO9906',(select CustomerID from Customer where CustomerName = 'Demo'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42191,112)),101),'6762.16')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO9907',(select CustomerID from Customer where CustomerName = 'Demo'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42212,112)),101),'252.84')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO9908',(select CustomerID from Customer where CustomerName = 'Demo'),(select VendorID from Vendor where VendorName = 'Akro Mils'),convert(date,(convert(datetime,42260,112)),101),'2115.52')
insert into PO (PO,CustomerID,VendorID,OrderDate,Total) VALUES ('PO9909',(select CustomerID from Customer where CustomerName = 'Demo'),(select VendorID from Vendor where VendorName = 'Intermetro'),convert(date,(convert(datetime,42260,112)),101),'7869.2')


Select * from POLine
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'150','3.64','546')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'120','3.88','465.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'150','6.02','903')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'12','7.21','86.52')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'12','7.52','90.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'10',(select ItemID from Item where ItemNumber = 'BIN124B'),'24','2.49','59.76')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'11',(select ItemID from Item where ItemNumber = 'BIN164B'),'24','3.45','82.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1004'),'12',(select ItemID from Item where ItemNumber = 'BIN184B'),'24','4.41','105.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1005'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1008','0.68','685.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1005'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'96','1.56','149.76')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1005'),'3',(select ItemID from Item where ItemNumber = 'BIN305A3'),'48','2.64','126.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1006'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'300','6.34','1902')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1006'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'128','37.97','4860.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1007'),'1',(select ItemID from Item where ItemNumber = 'BIN255B'),'42','6.02','252.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.68','1305.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'480','2','960')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'60','6.02','361.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1008'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'44','4.96','218.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1009'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1009'),'2',(select ItemID from Item where ItemNumber = 'WH5BR'),'22','12.05','265.1')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1009'),'3',(select ItemID from Item where ItemNumber = 'WH5BMP'),'22','9.91','218.02')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1010'),'1',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'4','26.84','107.36')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'288','0.68','195.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'72','1.56','112.32')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'108','2','216')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'5',(select ItemID from Item where ItemNumber = 'DIV824'),'32','5.92','189.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1011'),'6',(select ItemID from Item where ItemNumber = 'LDG24'),'24','2.75','66')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1012'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'116','4.96','575.36')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1012'),'2',(select ItemID from Item where ItemNumber = 'LINER4824'),'8','7.31','58.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1012'),'3',(select ItemID from Item where ItemNumber = 'LINER6024'),'24','9.12','218.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'250','6.34','1585')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','37.97','4556.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','32.33','1551.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'32','27.91','893.12')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'32','26.84','858.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'6',(select ItemID from Item where ItemNumber = 'WH5BR'),'58','12.05','698.9')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1013'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'58','9.91','574.78')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'150','3.64','546')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'5',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'6',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'7',(select ItemID from Item where ItemNumber = 'POST63'),'72','4.96','357.12')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'8',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'9',(select ItemID from Item where ItemNumber = 'LINER6024'),'20','9.12','182.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'10',(select ItemID from Item where ItemNumber = 'DIV824'),'40','5.92','236.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1014'),'11',(select ItemID from Item where ItemNumber = 'LDG24'),'40','2.75','110')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'144','6.34','912.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'64','37.97','2430.08')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','32.33','1293.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'5',(select ItemID from Item where ItemNumber = 'WH5BR'),'36','12.05','433.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1015'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'36','9.91','356.76')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'288','0.68','195.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'120','2','240')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'5',(select ItemID from Item where ItemNumber = 'POST63'),'32','4.96','158.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1016'),'6',(select ItemID from Item where ItemNumber = 'DIV824'),'80','5.92','473.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'48','6.34','304.32')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'24','37.97','911.28')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'8','32.33','258.64')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'8','27.91','223.28')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','26.84','214.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'16','9.91','158.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1017'),'7',(select ItemID from Item where ItemNumber = 'WH5BR'),'16','12.05','192.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1018'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1008','0.68','685.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1018'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'408','1.56','636.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1018'),'3',(select ItemID from Item where ItemNumber = 'POST63'),'160','4.96','793.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1019'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'276','6.34','1749.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1019'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','37.97','4556.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1019'),'3',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'56','27.91','1562.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'240','0.68','163.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'3',(select ItemID from Item where ItemNumber = 'BIN239B'),'30','3.88','116.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'4',(select ItemID from Item where ItemNumber = 'BIN255B'),'36','5.05','181.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'5',(select ItemID from Item where ItemNumber = 'BIN250B'),'12','5.62','67.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1020'),'6',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'480','0.68','326.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'90','3.64','327.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'72','3.88','279.36')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'72','5.05','363.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'18','5.62','101.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'10',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'11',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'12',(select ItemID from Item where ItemNumber = 'DIV824'),'20','5.92','118.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1021'),'13',(select ItemID from Item where ItemNumber = 'LDG24'),'20','2.75','55')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'140','6.34','887.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'88','37.97','3341.36')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','32.33','775.92')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','26.84','214.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'68','7.47','507.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'34','9.91','336.94')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1022'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'34','12.05','409.7')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1023'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'160','7.47','1195.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1024'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'16','7.31','116.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1024'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'64','32.33','2069.12')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'64','27.91','1786.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'24','26.84','644.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'96','7.47','717.12')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'48','9.91','475.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1025'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'48','12.05','578.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1026'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'32','7.47','239.04')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1027'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1027'),'2',(select ItemID from Item where ItemNumber = 'BIN235B'),'90','3.64','327.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1027'),'3',(select ItemID from Item where ItemNumber = 'BIN255B'),'72','5.05','363.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'72','0.68','48.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'48','1.56','74.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'36','2','72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'30','3.64','109.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'12','3.88','46.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'24','5.05','121.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1028'),'7',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1029'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'40','6.34','253.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1029'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1029'),'3',(select ItemID from Item where ItemNumber = 'POST63'),'20','7.47','149.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1029'),'4',(select ItemID from Item where ItemNumber = 'WH5BMP'),'10','9.91','99.1')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1029'),'5',(select ItemID from Item where ItemNumber = 'WH5BR'),'10','12.05','120.5')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1030'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'36','1.56','56.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1030'),'2',(select ItemID from Item where ItemNumber = 'BIN230B'),'36','2','72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1030'),'3',(select ItemID from Item where ItemNumber = 'BIN235B'),'24','3.64','87.36')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1030'),'4',(select ItemID from Item where ItemNumber = 'BIN239B'),'12','3.88','46.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1030'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'12','5.05','60.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1031'),'1',(select ItemID from Item where ItemNumber = 'CAGE36'),'1','432.8','432.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'600','1.56','936')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'300','2','600')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'240','3.64','873.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'120','3.88','465.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'84','5.05','424.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'24','5.62','134.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'10',(select ItemID from Item where ItemNumber = 'BIN124B'),'12','2.49','29.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'11',(select ItemID from Item where ItemNumber = 'BIN164B'),'12','3.45','41.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'12',(select ItemID from Item where ItemNumber = 'BIN184B'),'12','4.41','52.92')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'13',(select ItemID from Item where ItemNumber = 'LINER4824'),'12','7.31','87.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'14',(select ItemID from Item where ItemNumber = 'LINER6024'),'12','9.12','109.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'15',(select ItemID from Item where ItemNumber = 'DIV824'),'12','5.92','71.04')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1032'),'16',(select ItemID from Item where ItemNumber = 'LDG24'),'12','2.75','33')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'150','6.34','951')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'72','37.97','2733.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'32','32.33','1034.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'70','7.47','522.9')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'35','9.91','346.85')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1033'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'35','12.05','421.75')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1034'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1035'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'16','7.47','119.52')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1035'),'2',(select ItemID from Item where ItemNumber = 'WH5BMP'),'8','9.91','79.28')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1035'),'3',(select ItemID from Item where ItemNumber = 'WH5BR'),'8','12.05','96.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1035'),'4',(select ItemID from Item where ItemNumber = 'SH4818CQ'),'12','26.54','318.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1035'),'5',(select ItemID from Item where ItemNumber = 'SH4218CQ'),'12','26.54','318.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1036'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'192','1.56','299.52')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1037'),'1',(select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.68','1305.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'480','1.56','748.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'600','2','1200')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'4',(select ItemID from Item where ItemNumber = 'BIN239B'),'240','3.88','931.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'5',(select ItemID from Item where ItemNumber = 'BIN250B'),'60','5.62','337.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'6',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'7',(select ItemID from Item where ItemNumber = 'BIN164B'),'24','3.45','82.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'8',(select ItemID from Item where ItemNumber = 'LINER4824'),'20','7.31','146.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1038'),'9',(select ItemID from Item where ItemNumber = 'LINER6024'),'40','9.12','364.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','32.33','1293.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'40','26.84','1073.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'80','7.47','597.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'40','9.91','396.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'40','12.05','482')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1039'),'9',(select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1040'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'120','2','240')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'300','3.64','1092')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'24','3.88','93.12')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'120','5.05','606')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'7',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1041'),'8',(select ItemID from Item where ItemNumber = 'LDG24'),'16','2.75','44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'180','6.34','1141.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'48','37.97','1822.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','32.33','1551.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'5',(select ItemID from Item where ItemNumber = 'POST63'),'68','7.47','507.96')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'34','9.91','336.94')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1042'),'7',(select ItemID from Item where ItemNumber = 'WH5BR'),'34','12.05','409.7')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'312','0.68','212.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'84','1.56','131.04')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'72','2','144')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'42','3.64','152.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'36','3.88','139.68')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'36','5.05','181.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'7',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'8',(select ItemID from Item where ItemNumber = 'LINER6024'),'4','9.12','36.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'9',(select ItemID from Item where ItemNumber = 'DIV824'),'48','5.92','284.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1043'),'10',(select ItemID from Item where ItemNumber = 'LDG24'),'48','2.75','132')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'50','6.34','317')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'8','37.97','303.76')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'3',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'4',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'5',(select ItemID from Item where ItemNumber = 'POST63'),'20','7.47','149.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'10','9.91','99.1')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1044'),'7',(select ItemID from Item where ItemNumber = 'WH5BR'),'10','12.05','120.5')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'360','1.56','561.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'120','3.64','436.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'120','5.05','606')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1045'),'6',(select ItemID from Item where ItemNumber = 'BIN250B'),'24','5.62','134.88')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'50','6.34','317')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'54','37.97','2050.38')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','32.33','775.92')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'12','27.91','334.92')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'16','7.47','119.52')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'8',(select ItemID from Item where ItemNumber = 'WH5BMP'),'8','9.91','79.28')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1046'),'9',(select ItemID from Item where ItemNumber = 'WH5BR'),'8','12.05','96.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1047'),'1',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1048'),'1',(select ItemID from Item where ItemNumber = 'DIV824'),'40','5.92','236.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1048'),'2',(select ItemID from Item where ItemNumber = 'LDG24'),'40','2.75','110')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1049'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1200','0.68','816')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1049'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'144','1.56','224.64')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1049'),'3',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1050'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'8','7.31','58.48')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1051'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'840','0.68','571.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1051'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'144','1.56','224.64')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1051'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'120','2','240')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO1051'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'120','3.64','436.8')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9905'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1008','0.68','685.44')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9905'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'96','1.56','149.76')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9905'),'3',(select ItemID from Item where ItemNumber = 'BIN305A3'),'48','2.64','126.72')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9906'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'300','6.34','1902')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9906'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'128','37.97','4860.16')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9907'),'1',(select ItemID from Item where ItemNumber = 'BIN255B'),'42','6.02','252.84')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.68','1305.6')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'480','2','960')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'60','6.02','361.2')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9908'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'44','4.96','218.24')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9909'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9909'),'2',(select ItemID from Item where ItemNumber = 'WH5BR'),'22','12.05','265.1')
insert into POLine (POID,POLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((select POID from PO where PO = 'PO9909'),'3',(select ItemID from Item where ItemNumber = 'WH5BMP'),'22','9.91','218.02')

select * delete from VendorInvoice
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1153243',(select POID from PO where PO = 'PO1004'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3686.64','0','907.96','4594.6',convert(date,(convert(datetime,42196,112)),101),convert(date,(convert(datetime,42198,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1152813',(select POID from PO where PO = 'PO1005'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'961.92','0','129.29','1091.21',convert(date,(convert(datetime,42196,112)),101),convert(date,(convert(datetime,42198,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11112483',(select POID from PO where PO = 'PO1006'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'6762.16','609.48','856.37','8228.01',convert(date,(convert(datetime,42196,112)),101),convert(date,(convert(datetime,42203,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1159041',(select POID from PO where PO = 'PO1007'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'252.84','0','73.03','325.87',convert(date,(convert(datetime,42217,112)),101),convert(date,(convert(datetime,42218,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1161283',(select POID from PO where PO = 'PO1008'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3032.4','0','722.47','3754.87',convert(date,(convert(datetime,42224,112)),101),convert(date,(convert(datetime,42234,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1159944',(select POID from PO where PO = 'PO1008'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'218.24','0','126.82','345.06',convert(date,(convert(datetime,42219,112)),101),convert(date,(convert(datetime,42226,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11129052',(select POID from PO where PO = 'PO1009'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1751.12','151.02','124.75','2026.89',convert(date,(convert(datetime,42234,112)),101),convert(date,(convert(datetime,42235,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11123536',(select POID from PO where PO = 'PO1010'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'107.36','9.26','39','155.62',convert(date,(convert(datetime,42220,112)),101),convert(date,(convert(datetime,42224,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1163215',(select POID from PO where PO = 'PO1011'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'524.16','0','103.31','627.47',convert(date,(convert(datetime,42231,112)),101),convert(date,(convert(datetime,42232,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1162087',(select POID from PO where PO = 'PO1011'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'255.44','0','137.36','392.8',convert(date,(convert(datetime,42227,112)),101),convert(date,(convert(datetime,42231,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1164002',(select POID from PO where PO = 'PO1011'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'218.4','0','86.13','304.53',convert(date,(convert(datetime,42233,112)),101),convert(date,(convert(datetime,42234,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1164180',(select POID from PO where PO = 'PO1012'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'852.72','0','341.16','1193.88',convert(date,(convert(datetime,42234,112)),101),convert(date,(convert(datetime,42245,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11131420',(select POID from PO where PO = 'PO1013'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'9761.58','841.96','852.8','11456.34',convert(date,(convert(datetime,42239,112)),101),convert(date,(convert(datetime,42240,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1165236',(select POID from PO where PO = 'PO1014'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1885.32','0','225.18','2110.5',convert(date,(convert(datetime,42238,112)),101),convert(date,(convert(datetime,42239,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1165754',(select POID from PO where PO = 'PO1014'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'805.56','0','131.94','937.5',convert(date,(convert(datetime,42240,112)),101),convert(date,(convert(datetime,42245,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11133449',(select POID from PO where PO = 'PO1015'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7621.48','482.93','610.94','8715.35',convert(date,(convert(datetime,42245,112)),101),convert(date,(convert(datetime,42246,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1172472',(select POID from PO where PO = 'PO1018'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1321.92','0','174.93','1496.85',convert(date,(convert(datetime,42263,112)),101),convert(date,(convert(datetime,42266,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1172692',(select POID from PO where PO = 'PO1018'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'793.6','0','141.09','934.69',convert(date,(convert(datetime,42266,112)),101),convert(date,(convert(datetime,42269,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1172831',(select POID from PO where PO = 'PO1016'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'788.64','0','242.55','1031.19',convert(date,(convert(datetime,42266,112)),101),convert(date,(convert(datetime,42273,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11142843',(select POID from PO where PO = 'PO1013'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'957.34','82.57','37.55','1077.46',convert(date,(convert(datetime,42267,112)),101),convert(date,(convert(datetime,42270,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1173580',(select POID from PO where PO = 'PO1016'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'240','0','161.5','401.5',convert(date,(convert(datetime,42268,112)),101),convert(date,(convert(datetime,42274,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11144717',(select POID from PO where PO = 'PO1019'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'7869.2','712.47','1036.64','9618.31',convert(date,(convert(datetime,42270,112)),101),convert(date,(convert(datetime,42275,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1174283',(select POID from PO where PO = 'PO1016'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'158.72','0','153.04','311.76',convert(date,(convert(datetime,42270,112)),101),convert(date,(convert(datetime,42275,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11145678',(select POID from PO where PO = 'PO1017'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2263.6','195.25','254.24','2713.09',convert(date,(convert(datetime,42273,112)),101),convert(date,(convert(datetime,42276,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1174469',(select POID from PO where PO = 'PO1020'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'750.72','0','128.11','878.83',convert(date,(convert(datetime,42270,112)),101),convert(date,(convert(datetime,42275,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1176151',(select POID from PO where PO = 'PO1014'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'110','0','100.4','210.4',convert(date,(convert(datetime,42276,112)),101),convert(date,(convert(datetime,42280,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11147591',(select POID from PO where PO = 'PO1023'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1195.2','0','209.65','1404.85',convert(date,(convert(datetime,42281,112)),101),convert(date,(convert(datetime,42283,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1177657',(select POID from PO where PO = 'PO1016'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'473.6','0','121.5','595.1',convert(date,(convert(datetime,42281,112)),101),convert(date,(convert(datetime,42288,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1177381',(select POID from PO where PO = 'PO1021'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'2329.44','0','260.2','2589.64',convert(date,(convert(datetime,42280,112)),101),convert(date,(convert(datetime,42282,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1177997',(select POID from PO where PO = 'PO1021'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'275.6','0','85.78','361.38',convert(date,(convert(datetime,42282,112)),101),convert(date,(convert(datetime,42284,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1177804',(select POID from PO where PO = 'PO1024'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'189.92','0','84.66','274.58',convert(date,(convert(datetime,42282,112)),101),convert(date,(convert(datetime,42288,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11151464',(select POID from PO where PO = 'PO1026'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'239.04','20.61','39','298.65',convert(date,(convert(datetime,42288,112)),101),convert(date,(convert(datetime,42290,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11150683',(select POID from PO where PO = 'PO1022'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'6920.76','0','657.47','7578.23',convert(date,(convert(datetime,42287,112)),101),convert(date,(convert(datetime,42290,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1180426',(select POID from PO where PO = 'PO1027'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'878.4','0','261.3','1139.7',convert(date,(convert(datetime,42290,112)),101),convert(date,(convert(datetime,42297,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11156193',(select POID from PO where PO = 'PO1025'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'9057.52','781.2','722.52','10561.24',convert(date,(convert(datetime,42297,112)),101),convert(date,(convert(datetime,42301,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11155995',(select POID from PO where PO = 'PO1029'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2141.4','184.7','267.8','2593.9',convert(date,(convert(datetime,42297,112)),101),convert(date,(convert(datetime,42301,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1183806',(select POID from PO where PO = 'PO1028'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'472.8','0','169.26','642.06',convert(date,(convert(datetime,42302,112)),101),convert(date,(convert(datetime,42308,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1184077',(select POID from PO where PO = 'PO1028'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'72.96','0','33.8','106.76',convert(date,(convert(datetime,42302,112)),101),convert(date,(convert(datetime,42308,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11161390',(select POID from PO where PO = 'PO1031'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'432.8','37.33','124.75','594.88',convert(date,(convert(datetime,42309,112)),101),convert(date,(convert(datetime,42315,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1186576',(select POID from PO where PO = 'PO1030'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'322.68','0','167.69','490.37',convert(date,(convert(datetime,42311,112)),101),convert(date,(convert(datetime,42315,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11163233',(select POID from PO where PO = 'PO1033'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'6886.9','550.1','700.9','8137.9',convert(date,(convert(datetime,42312,112)),101),convert(date,(convert(datetime,42317,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1187569',(select POID from PO where PO = 'PO1032'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4330.44','0','291','4621.44',convert(date,(convert(datetime,42315,112)),101),convert(date,(convert(datetime,42319,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1187816',(select POID from PO where PO = 'PO1032'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'301.2','0','72.14','373.34',convert(date,(convert(datetime,42316,112)),101),convert(date,(convert(datetime,42320,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11165624',(select POID from PO where PO = 'PO1035'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'932.16','80.42','133.74','1146.32',convert(date,(convert(datetime,42318,112)),101),convert(date,(convert(datetime,42323,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1190801',(select POID from PO where PO = 'PO1034'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'408','0','85.78','493.78',convert(date,(convert(datetime,42323,112)),101),convert(date,(convert(datetime,42329,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1192053',(select POID from PO where PO = 'PO1038'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'VCU'),'511','0','72.14','583.14',convert(date,(convert(datetime,42326,112)),101),convert(date,(convert(datetime,42331,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1192971',(select POID from PO where PO = 'PO1038'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'VCU'),'3941.28','0','370.99','4312.27',convert(date,(convert(datetime,42329,112)),101),convert(date,(convert(datetime,42336,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11171429',(select POID from PO where PO = 'PO1037'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'VCU'),'1799.6','0','351.44','2151.04',convert(date,(convert(datetime,42336,112)),101),convert(date,(convert(datetime,42341,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11171824',(select POID from PO where PO = 'PO1039'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'VCU'),'9545.6','0','1043.7','10589.3',convert(date,(convert(datetime,42336,112)),101),convert(date,(convert(datetime,42341,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1193795',(select POID from PO where PO = 'PO1038'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'VCU'),'748.8','0','105.37','854.17',convert(date,(convert(datetime,42336,112)),101),convert(date,(convert(datetime,42341,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1194260',(select POID from PO where PO = 'PO1036'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'299.52','0','85.78','385.3',convert(date,(convert(datetime,42336,112)),101),convert(date,(convert(datetime,42341,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1197253',(select POID from PO where PO = 'PO1041'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'44','0','49.68','93.68',convert(date,(convert(datetime,42345,112)),101),convert(date,(convert(datetime,42351,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1197887',(select POID from PO where PO = 'PO1040'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'408','0','85.43','493.43',convert(date,(convert(datetime,42346,112)),101),convert(date,(convert(datetime,42347,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1198007',(select POID from PO where PO = 'PO1043'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'360.88','0','116.16','477.04',convert(date,(convert(datetime,42347,112)),101),convert(date,(convert(datetime,42352,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1198727',(select POID from PO where PO = 'PO1043'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'961.56','0','268.44','1230',convert(date,(convert(datetime,42351,112)),101),convert(date,(convert(datetime,42357,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1198728',(select POID from PO where PO = 'PO1041'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3142.8','0','726.54','3869.34',convert(date,(convert(datetime,42350,112)),101),convert(date,(convert(datetime,42357,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11178214',(select POID from PO where PO = 'PO1046'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4202.86','344.46','548.23','5095.55',convert(date,(convert(datetime,42351,112)),101),convert(date,(convert(datetime,42357,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1199134',(select POID from PO where PO = 'PO1047'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'42.24','0','10.53','52.77',convert(date,(convert(datetime,42351,112)),101),convert(date,(convert(datetime,42348,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1199416',(select POID from PO where PO = 'PO1048'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'236.8','0','89.2','326',convert(date,(convert(datetime,42352,112)),101),convert(date,(convert(datetime,42354,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1200632',(select POID from PO where PO = 'PO1045'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'2872.08','0','192.32','3064.4',convert(date,(convert(datetime,42354,112)),101),convert(date,(convert(datetime,42358,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('1200629',(select POID from PO where PO = 'PO1045'),(Select VendorID from Vendor where VendorName = 'Akro Mils'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'436.8','0','71.84','508.64',convert(date,(convert(datetime,42354,112)),101),convert(date,(convert(datetime,42358,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11175414',(select POID from PO where PO = 'PO1044'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1865.76','160.93','189.66','2216.35',convert(date,(convert(datetime,42345,112)),101),convert(date,(convert(datetime,42356,112)),101))
insert into VendorInvoice (VendorInvoice,POID,VendorID,CustomerID,Subtotal,Tax,Shipping,Total,ShipDate,ReceiveDate) VALUES ('11180536',(select POID from PO where PO = 'PO1042'),(Select VendorID from Vendor where VendorName = 'Intermetro'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'6886.6','593.96','268.55','7749.11',convert(date,(convert(datetime,42357,112)),101),convert(date,(convert(datetime,42359,112)),101))


select * delete from VendorInvoiceLine
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'150','3.64','546')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'120','3.88','465.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'150','6.02','903')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'12','7.21','86.52')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'12','7.52','90.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'10',(select ItemID from Item where ItemNumber = 'BIN124B'),'24','2.49','59.76')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'11',(select ItemID from Item where ItemNumber = 'BIN164B'),'24','3.45','82.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1153243'),'12',(select ItemID from Item where ItemNumber = 'BIN184B'),'24','4.41','105.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1152813'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1008','0.68','685.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1152813'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'96','1.56','149.76')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1152813'),'3',(select ItemID from Item where ItemNumber = 'BIN305A3'),'48','2.64','126.72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11112483'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'300','6.34','1902')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11112483'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'128','37.97','4860.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1159041'),'1',(select ItemID from Item where ItemNumber = 'BIN255B'),'42','6.02','252.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1161283'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.68','1305.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1161283'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1161283'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'480','2','960')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1161283'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1161283'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'60','6.02','361.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1159944'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'44','4.96','218.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11129052'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11129052'),'2',(select ItemID from Item where ItemNumber = 'WH5BR'),'22','12.05','265.1')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11129052'),'3',(select ItemID from Item where ItemNumber = 'WH5BMP'),'22','9.91','218.02')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11123536'),'1',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'4','26.84','107.36')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1163215'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'288','0.68','195.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1163215'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'72','1.56','112.32')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1163215'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'108','2','216')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1162087'),'1',(select ItemID from Item where ItemNumber = 'DIV824'),'32','5.92','189.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1162087'),'2',(select ItemID from Item where ItemNumber = 'LDG24'),'24','2.75','66')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1164002'),'1',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1164180'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'116','4.96','575.36')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1164180'),'2',(select ItemID from Item where ItemNumber = 'LINER4824'),'8','7.31','58.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1164180'),'3',(select ItemID from Item where ItemNumber = 'LINER6024'),'24','9.12','218.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'150','3.64','546')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'5',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165236'),'6',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'99','6.34','627.66')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','37.97','4556.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','32.33','1551.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'32','27.91','893.12')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'32','26.84','858.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'6',(select ItemID from Item where ItemNumber = 'WH5BR'),'58','12.05','698.9')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11131420'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'58','9.91','574.78')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165754'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'72','4.96','357.12')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165754'),'2',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165754'),'3',(select ItemID from Item where ItemNumber = 'LINER6024'),'20','9.12','182.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1165754'),'4',(select ItemID from Item where ItemNumber = 'DIV824'),'40','5.92','236.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'144','6.34','912.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'64','37.97','2430.08')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','32.33','1293.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'5',(select ItemID from Item where ItemNumber = 'WH5BR'),'36','12.05','433.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11133449'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'36','9.91','356.76')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172472'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1008','0.68','685.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172472'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'408','1.56','636.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172692'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'160','4.96','793.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172831'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'288','0.68','195.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172831'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1172831'),'3',(select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.64','218.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11142843'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'151','6.34','957.34')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1173580'),'1',(select ItemID from Item where ItemNumber = 'BIN230B'),'120','2','240')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11144717'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'276','6.34','1749.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11144717'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','37.97','4556.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11144717'),'3',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'56','27.91','1562.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174283'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'32','4.96','158.72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'48','6.34','304.32')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'24','37.97','911.28')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'8','32.33','258.64')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'8','27.91','223.28')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','26.84','214.72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'16','9.91','158.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11145678'),'7',(select ItemID from Item where ItemNumber = 'WH5BR'),'16','12.05','192.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'240','0.68','163.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'3',(select ItemID from Item where ItemNumber = 'BIN239B'),'30','3.88','116.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'4',(select ItemID from Item where ItemNumber = 'BIN255B'),'36','5.05','181.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'5',(select ItemID from Item where ItemNumber = 'BIN250B'),'12','5.62','67.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1174469'),'6',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1176151'),'1',(select ItemID from Item where ItemNumber = 'LDG24'),'40','2.75','110')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11147591'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'160','7.47','1195.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177657'),'1',(select ItemID from Item where ItemNumber = 'DIV824'),'80','5.92','473.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'480','0.68','326.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'90','3.64','327.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'72','3.88','279.36')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'72','5.05','363.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'18','5.62','101.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177381'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177997'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177997'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177997'),'3',(select ItemID from Item where ItemNumber = 'DIV824'),'20','5.92','118.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177997'),'4',(select ItemID from Item where ItemNumber = 'LDG24'),'20','2.75','55')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177804'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'16','7.31','116.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1177804'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11151464'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'32','7.47','239.04')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'140','6.34','887.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'88','37.97','3341.36')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','32.33','775.92')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','26.84','214.72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'68','7.47','507.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'34','9.91','336.94')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11150683'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'34','12.05','409.7')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1180426'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1180426'),'2',(select ItemID from Item where ItemNumber = 'BIN235B'),'90','3.64','327.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1180426'),'3',(select ItemID from Item where ItemNumber = 'BIN255B'),'72','5.05','363.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'64','32.33','2069.12')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'64','27.91','1786.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'24','26.84','644.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'96','7.47','717.12')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'48','9.91','475.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11156193'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'48','12.05','578.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11155995'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'40','6.34','253.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11155995'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11155995'),'3',(select ItemID from Item where ItemNumber = 'POST63'),'20','7.47','149.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11155995'),'4',(select ItemID from Item where ItemNumber = 'WH5BMP'),'10','9.91','99.1')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11155995'),'5',(select ItemID from Item where ItemNumber = 'WH5BR'),'10','12.05','120.5')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'72','0.68','48.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'48','1.56','74.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'36','2','72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'30','3.64','109.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'12','3.88','46.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1183806'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'24','5.05','121.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1184077'),'1',(select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.12','72.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11161390'),'1',(select ItemID from Item where ItemNumber = 'CAGE36'),'1','432.8','432.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1186576'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'36','1.56','56.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1186576'),'2',(select ItemID from Item where ItemNumber = 'BIN230B'),'36','2','72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1186576'),'3',(select ItemID from Item where ItemNumber = 'BIN235B'),'24','3.64','87.36')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1186576'),'4',(select ItemID from Item where ItemNumber = 'BIN239B'),'12','3.88','46.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1186576'),'5',(select ItemID from Item where ItemNumber = 'BIN255B'),'12','5.05','60.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'150','6.34','951')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'72','37.97','2733.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'32','32.33','1034.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'70','7.47','522.9')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'35','9.91','346.85')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11163233'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'35','12.05','421.75')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'600','1.56','936')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'300','2','600')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'240','3.64','873.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'120','3.88','465.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'84','5.05','424.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'7',(select ItemID from Item where ItemNumber = 'BIN250B'),'24','5.62','134.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'8',(select ItemID from Item where ItemNumber = 'BIN250C'),'6','5.78','34.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'9',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'10',(select ItemID from Item where ItemNumber = 'BIN124B'),'12','2.49','29.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'11',(select ItemID from Item where ItemNumber = 'BIN164B'),'12','3.45','41.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187569'),'12',(select ItemID from Item where ItemNumber = 'BIN184B'),'12','4.41','52.92')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187816'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'12','7.31','87.72')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187816'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'12','9.12','109.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187816'),'3',(select ItemID from Item where ItemNumber = 'DIV824'),'12','5.92','71.04')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1187816'),'4',(select ItemID from Item where ItemNumber = 'LDG24'),'12','2.75','33')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11165624'),'1',(select ItemID from Item where ItemNumber = 'POST63'),'16','7.47','119.52')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11165624'),'2',(select ItemID from Item where ItemNumber = 'WH5BMP'),'8','9.91','79.28')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11165624'),'3',(select ItemID from Item where ItemNumber = 'WH5BR'),'8','12.05','96.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11165624'),'4',(select ItemID from Item where ItemNumber = 'SH4818CQ'),'12','26.54','318.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11165624'),'5',(select ItemID from Item where ItemNumber = 'SH4218CQ'),'12','26.54','318.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1190801'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192053'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'20','7.31','146.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192053'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'40','9.12','364.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.68','1305.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'2',(select ItemID from Item where ItemNumber = 'BIN230B'),'600','2','1200')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'3',(select ItemID from Item where ItemNumber = 'BIN239B'),'240','3.88','931.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'4',(select ItemID from Item where ItemNumber = 'BIN250B'),'60','5.62','337.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'5',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1192971'),'6',(select ItemID from Item where ItemNumber = 'BIN164B'),'24','3.45','82.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171429'),'1',(select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','37.97','1518.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','32.33','1293.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'40','26.84','1073.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'80','7.47','597.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'40','9.91','396.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'40','12.05','482')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11171824'),'9',(select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1193795'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'480','1.56','748.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1194260'),'1',(select ItemID from Item where ItemNumber = 'BIN224B'),'192','1.56','299.52')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1197253'),'1',(select ItemID from Item where ItemNumber = 'LDG24'),'16','2.75','44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1197887'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'600','0.68','408')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198007'),'1',(select ItemID from Item where ItemNumber = 'LINER4824'),'4','7.31','29.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198007'),'2',(select ItemID from Item where ItemNumber = 'LINER6024'),'4','9.12','36.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198007'),'3',(select ItemID from Item where ItemNumber = 'DIV824'),'48','5.92','284.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198007'),'4',(select ItemID from Item where ItemNumber = 'LDG24'),'4','2.75','11')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'312','0.68','212.16')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'84','1.56','131.04')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'72','2','144')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'42','3.64','152.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'36','3.88','139.68')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198727'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'36','5.05','181.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'120','2','240')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'4',(select ItemID from Item where ItemNumber = 'BIN235B'),'300','3.64','1092')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'5',(select ItemID from Item where ItemNumber = 'BIN239B'),'24','3.88','93.12')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'6',(select ItemID from Item where ItemNumber = 'BIN255B'),'120','5.05','606')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1198728'),'7',(select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.64','84.48')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'50','6.34','317')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'54','37.97','2050.38')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','32.33','775.92')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'12','27.91','334.92')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'5',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'6',(select ItemID from Item where ItemNumber = 'POST63'),'16','7.47','119.52')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'7',(select ItemID from Item where ItemNumber = 'WH5BMP'),'8','9.91','79.28')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11178214'),'8',(select ItemID from Item where ItemNumber = 'WH5BR'),'8','12.05','96.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1199134'),'1',(select ItemID from Item where ItemNumber = 'BIN305A3'),'16','2.64','42.24')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1199416'),'1',(select ItemID from Item where ItemNumber = 'DIV824'),'40','5.92','236.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200632'),'1',(select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.68','652.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200632'),'2',(select ItemID from Item where ItemNumber = 'BIN224B'),'360','1.56','561.6')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200632'),'3',(select ItemID from Item where ItemNumber = 'BIN230B'),'240','2','480')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200632'),'4',(select ItemID from Item where ItemNumber = 'BIN255B'),'120','5.05','606')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200632'),'5',(select ItemID from Item where ItemNumber = 'BIN250B'),'24','5.62','134.88')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '1200629'),'1',(select ItemID from Item where ItemNumber = 'BIN235B'),'120','3.64','436.8')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'50','6.34','317')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'8','37.97','303.76')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'3',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','27.91','446.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'4',(select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','26.84','429.44')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'5',(select ItemID from Item where ItemNumber = 'POST63'),'20','7.47','149.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'10','9.91','99.1')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11175414'),'7',(select ItemID from Item where ItemNumber = 'WH5BR'),'10','12.05','120.5')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'1',(select ItemID from Item where ItemNumber = 'SLAT55'),'180','6.34','1141.2')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'2',(select ItemID from Item where ItemNumber = 'SH6024CQ'),'48','37.97','1822.56')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'3',(select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','32.33','1551.84')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'4',(select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','27.91','1116.4')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'5',(select ItemID from Item where ItemNumber = 'POST63'),'68','7.47','507.96')
insert into VendorInvoiceLine (VendorInvoiceID,VendorInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select VendorInvoiceID from VendorInvoice where VendorInvoice = '11180536'),'6',(select ItemID from Item where ItemNumber = 'WH5BMP'),'34','9.91','336.94')

select * from ClientInvoice
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1004',(Select POID from PO where PO = 'PO1004'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'4607.48','0','907.96','5515.44')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1005',(Select POID from PO where PO = 'PO1005'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'2211.84','0','129.29','2341.13')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1006',(Select POID from PO where PO = 'PO1006'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'8352.8','609.48','856.37','9818.65')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1007',(Select POID from PO where PO = 'PO1007'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'432.6','0','73.03','505.63')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1008',(Select POID from PO where PO = 'PO1008'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'4148.04','0','849.29','4997.33')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1009',(Select POID from PO where PO = 'PO1009'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2042.3','151.02','124.75','2318.07')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1010',(Select POID from PO where PO = 'PO1010'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'124','9.26','39','172.26')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1011',(Select POID from PO where PO = 'PO1011'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1350.56','0','326.8','1677.36')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1012',(Select POID from PO where PO = 'PO1012'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1352.64','0','341.16','1693.8')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1013',(Select POID from PO where PO = 'PO1013'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'12611.3','924.53','890.35','14426.18')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1014',(Select POID from PO where PO = 'PO1014'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3777.92','0','457.52','4235.44')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1015',(Select POID from PO where PO = 'PO1015'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'7621.48','482.93','610.94','8715.35')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1016',(Select POID from PO where PO = 'PO1016'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2071.92','0','678.59','2750.51')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1017',(Select POID from PO where PO = 'PO1017'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2664.32','195.25','254.24','3113.81')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1018',(Select POID from PO where PO = 'PO1018'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'4454','0','316.02','4770.02')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1019',(Select POID from PO where PO = 'PO1019'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'9675.04','712.47','1036.64','11424.15')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1020',(Select POID from PO where PO = 'PO1020'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'995.28','0','128.11','1123.39')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1021',(Select POID from PO where PO = 'PO1021'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'3421.28','0','345.98','3767.26')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1022',(Select POID from PO where PO = 'PO1022'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'8010.54','0','657.47','8668.01')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1023',(Select POID from PO where PO = 'PO1023'),(Select CustomerID from Customer where CustomerName = 'TJUH'),'1443.2','0','209.65','1652.85')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1024',(Select POID from PO where PO = 'PO1024'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'209.76','0','84.66','294.42')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1025',(Select POID from PO where PO = 'PO1025'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'10660.16','781.2','722.52','12163.88')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1026',(Select POID from PO where PO = 'PO1026'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'289.92','20.61','39','349.53')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1027',(Select POID from PO where PO = 'PO1027'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'989.28','0','261.3','1250.58')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1028',(Select POID from PO where PO = 'PO1028'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'629.88','0','203.06','832.94')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1029',(Select POID from PO where PO = 'PO1029'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2531.7','184.7','267.8','2984.2')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1030',(Select POID from PO where PO = 'PO1030'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'405.96','0','167.69','573.65')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1031',(Select POID from PO where PO = 'PO1031'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'810.24','37.33','124.75','972.32')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1032',(Select POID from PO where PO = 'PO1032'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'5990.84','0','363.14','6353.98')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1033',(Select POID from PO where PO = 'PO1033'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'8041.15','550.1','700.9','9292.15')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1034',(Select POID from PO where PO = 'PO1034'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'672','0','85.78','757.78')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1035',(Select POID from PO where PO = 'PO1035'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1115.12','80.42','133.74','1329.28')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1036',(Select POID from PO where PO = 'PO1036'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'328.32','0','85.78','414.1')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1037',(Select POID from PO where PO = 'PO1037'),(Select CustomerID from Customer where CustomerName = 'VCU'),'1799.6','0','351.44','2151.04')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1038',(Select POID from PO where PO = 'PO1038'),(Select CustomerID from Customer where CustomerName = 'VCU'),'6295.88','0','548.5','6844.38')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1039',(Select POID from PO where PO = 'PO1039'),(Select CustomerID from Customer where CustomerName = 'VCU'),'9692.8','0','1043.7','10736.5')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1040',(Select POID from PO where PO = 'PO1040'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'672','0','85.43','757.43')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1041',(Select POID from PO where PO = 'PO1041'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'3721.28','0','776.22','4497.5')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1042',(Select POID from PO where PO = 'PO1042'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'8115.94','593.96','268.55','8978.45')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1043',(Select POID from PO where PO = 'PO1043'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'1755.84','0','0','1755.84')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1044',(Select POID from PO where PO = 'PO1044'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'2179.86','160.93','189.66','2530.45')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1045',(Select POID from PO where PO = 'PO1045'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'3884.4','0','264.16','4148.56')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1046',(Select POID from PO where PO = 'PO1046'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'4895.66','0','548.23','5443.89')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1047',(Select POID from PO where PO = 'PO1047'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'50.08','0','10.53','60.61')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1048',(Select POID from PO where PO = 'PO1048'),(Select CustomerID from Customer where CustomerName = 'UTMC'),'450','0','0','450')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1049',(Select POID from PO where PO = 'PO1049'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'1640.32','0','0','1640.32')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1050',(Select POID from PO where PO = 'PO1050'),(Select CustomerID from Customer where CustomerName = 'CHOMP'),'65.52','0','0','65.52')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('1051',(Select POID from PO where PO = 'PO1051'),(Select CustomerID from Customer where CustomerName = 'Caldwell'),'2058.24','0','0','2058.24')

insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('9905',(Select POID from PO where PO = 'PO9905'),(Select CustomerID from Customer where CustomerName = 'Demo'),'2211.84','0','129.29','2341.13')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('9906',(Select POID from PO where PO = 'PO9906'),(Select CustomerID from Customer where CustomerName = 'Demo'),'8352.8','609.48','856.37','9818.65')
insert into ClientInvoice (ClientInvoice,POID,CustomerID,Subtotal,Tax,Shipping,Total) VALUES ('9907',(Select POID from PO where PO = 'PO9907'),(Select CustomerID from Customer where CustomerName = 'Demo'),'432.6','0','73.03','505.63')


insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'600','1.12','672')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.71','410.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'240','2.86','686.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'150','4.4','660')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'120','4.74','568.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'150','6.58','987')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'7',(Select ItemID from Item where ItemNumber = 'BIN250B'),'12','7.9','94.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'8',(Select ItemID from Item where ItemNumber = 'BIN250C'),'12','7.9','94.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'9',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'32','3.13','100.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'10',(Select ItemID from Item where ItemNumber = 'BIN124B'),'24','3.32','79.68')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'11',(Select ItemID from Item where ItemNumber = 'BIN164B'),'24','4.76','114.24')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1004'),'12',(Select ItemID from Item where ItemNumber = 'BIN184B'),'24','5.8','139.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1005'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1008','1.72','1733.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1005'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'96','3.13','300.48')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1005'),'3',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'48','3.7','177.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1006'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'300','8.28','2484')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1006'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'128','45.85','5868.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1007'),'1',(Select ItemID from Item where ItemNumber = 'BIN255B'),'42','10.3','432.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.9','1728')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'480','2.55','1224')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.88','232.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'5',(Select ItemID from Item where ItemNumber = 'BIN255B'),'60','6.29','377.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1008'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'44','9.06','398.64')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1009'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'200','7.28','1456')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1009'),'2',(Select ItemID from Item where ItemNumber = 'WH5BR'),'22','14.5','319')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1009'),'3',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'22','12.15','267.3')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1010'),'1',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'4','31','124')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'288','1.12','322.56')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'72','1.71','123.12')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'108','2.86','308.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'60','4.4','264')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'5',(Select ItemID from Item where ItemNumber = 'DIV824'),'32','7.75','248')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1011'),'6',(Select ItemID from Item where ItemNumber = 'LDG24'),'24','3.5','84')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1012'),'1',(Select ItemID from Item where ItemNumber = 'POST63'),'116','9.06','1050.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1012'),'2',(Select ItemID from Item where ItemNumber = 'LINER4824'),'8','8.19','65.52')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1012'),'3',(Select ItemID from Item where ItemNumber = 'LINER6024'),'24','9.84','236.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'250','7.28','1820')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','44.82','5378.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','38.5','1848')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'32','32.1','1027.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'32','31','992')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'6',(Select ItemID from Item where ItemNumber = 'WH5BR'),'58','14.5','841')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1013'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'58','12.15','704.7')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'600','1.12','672')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.71','410.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'240','2.86','686.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'150','4.4','660')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'5',(Select ItemID from Item where ItemNumber = 'BIN250C'),'6','7.9','47.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'6',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'16','3.13','50.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'7',(Select ItemID from Item where ItemNumber = 'POST63'),'72','7.95','572.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'8',(Select ItemID from Item where ItemNumber = 'LINER4824'),'4','8.11','32.44')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'9',(Select ItemID from Item where ItemNumber = 'LINER6024'),'20','9.84','196.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'10',(Select ItemID from Item where ItemNumber = 'DIV824'),'40','7.75','310')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1014'),'11',(Select ItemID from Item where ItemNumber = 'LDG24'),'40','3.5','140')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'144','7.45','1072.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'64','44.24','2831.36')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','37.34','1493.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','32.67','1306.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'5',(Select ItemID from Item where ItemNumber = 'WH5BR'),'36','14.13','508.68')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1015'),'6',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'36','11.34','408.24')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'288','0.9','259.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'120','2.55','306')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'60','3.88','232.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'5',(Select ItemID from Item where ItemNumber = 'POST63'),'32','9.06','289.92')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1016'),'6',(Select ItemID from Item where ItemNumber = 'DIV824'),'80','7.62','609.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'48','7.28','349.44')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'24','44.82','1075.68')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'8','38.5','308')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'8','32.1','256.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','31','248')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'6',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'16','12.15','194.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1017'),'7',(Select ItemID from Item where ItemNumber = 'WH5BR'),'16','14.5','232')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1018'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1008','1.72','1733.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1018'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'408','3.13','1277.04')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1018'),'3',(Select ItemID from Item where ItemNumber = 'POST63'),'160','9.02','1443.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1019'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'276','8.28','2285.28')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1019'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'120','45.85','5502')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1019'),'3',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'56','33.71','1887.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'240','1.12','268.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.71','205.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'3',(Select ItemID from Item where ItemNumber = 'BIN239B'),'30','4.74','142.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'4',(Select ItemID from Item where ItemNumber = 'BIN255B'),'36','6.58','236.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'5',(Select ItemID from Item where ItemNumber = 'BIN250B'),'12','7.9','94.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1020'),'6',(Select ItemID from Item where ItemNumber = 'BIN250C'),'6','7.9','47.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'480','1.12','537.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.71','410.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'240','2.86','686.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'90','4.4','396')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'72','4.74','341.28')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'72','6.58','473.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'7',(Select ItemID from Item where ItemNumber = 'BIN250B'),'18','7.9','142.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'8',(Select ItemID from Item where ItemNumber = 'BIN250C'),'6','7.9','47.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'9',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'16','3.13','50.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'10',(Select ItemID from Item where ItemNumber = 'LINER4824'),'4','8.11','32.44')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'11',(Select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.84','78.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'12',(Select ItemID from Item where ItemNumber = 'DIV824'),'20','7.75','155')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1021'),'13',(Select ItemID from Item where ItemNumber = 'LDG24'),'20','3.5','70')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'140','7.45','1043')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'88','44.24','3893.12')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','37.34','896.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','32.67','522.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'8','31.12','248.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'68','7.95','540.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'34','11.34','385.56')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1022'),'8',(Select ItemID from Item where ItemNumber = 'WH5BR'),'34','14.13','480.42')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1023'),'1',(Select ItemID from Item where ItemNumber = 'POST63'),'160','9.02','1443.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1024'),'1',(Select ItemID from Item where ItemNumber = 'LINER4824'),'16','8.19','131.04')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1024'),'2',(Select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.84','78.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'200','7.28','1456')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','44.82','1792.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'64','38.5','2464')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'64','32.1','2054.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'24','31','744')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'96','9.06','869.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'48','12.15','583.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1025'),'8',(Select ItemID from Item where ItemNumber = 'WH5BR'),'48','14.5','696')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1026'),'1',(Select ItemID from Item where ItemNumber = 'POST63'),'32','9.06','289.92')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1027'),'1',(Select ItemID from Item where ItemNumber = 'BIN224B'),'120','1.56','187.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1027'),'2',(Select ItemID from Item where ItemNumber = 'BIN235B'),'90','3.88','349.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1027'),'3',(Select ItemID from Item where ItemNumber = 'BIN255B'),'72','6.29','452.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'72','0.9','64.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'48','1.56','74.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'36','2.55','91.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'30','3.88','116.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'12','4.36','52.32')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'24','6.29','150.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1028'),'7',(Select ItemID from Item where ItemNumber = 'LINER6024'),'8','9.84','78.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1029'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'40','7.28','291.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1029'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','44.82','1792.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1029'),'3',(Select ItemID from Item where ItemNumber = 'POST63'),'20','9.06','181.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1029'),'4',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'10','12.15','121.5')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1029'),'5',(Select ItemID from Item where ItemNumber = 'WH5BR'),'10','14.5','145')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1030'),'1',(Select ItemID from Item where ItemNumber = 'BIN224B'),'36','1.71','61.56')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1030'),'2',(Select ItemID from Item where ItemNumber = 'BIN230B'),'36','2.86','102.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1030'),'3',(Select ItemID from Item where ItemNumber = 'BIN235B'),'24','4.4','105.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1030'),'4',(Select ItemID from Item where ItemNumber = 'BIN239B'),'12','4.74','56.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1030'),'5',(Select ItemID from Item where ItemNumber = 'BIN255B'),'12','6.58','78.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1031'),'1',(Select ItemID from Item where ItemNumber = 'CAGE36'),'1','810.24','810.24')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'960','1.12','1075.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'600','1.71','1026')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'300','2.86','858')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'240','4.4','1056')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'120','4.74','568.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'84','6.58','552.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'7',(Select ItemID from Item where ItemNumber = 'BIN250B'),'24','7.9','189.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'8',(Select ItemID from Item where ItemNumber = 'BIN250C'),'6','7.9','47.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'9',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'32','3.13','100.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'10',(Select ItemID from Item where ItemNumber = 'BIN124B'),'12','3.32','39.84')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'11',(Select ItemID from Item where ItemNumber = 'BIN164B'),'12','4.76','57.12')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'12',(Select ItemID from Item where ItemNumber = 'BIN184B'),'12','5.8','69.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'13',(Select ItemID from Item where ItemNumber = 'LINER4824'),'12','8.11','97.32')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'14',(Select ItemID from Item where ItemNumber = 'LINER6024'),'12','9.84','118.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'15',(Select ItemID from Item where ItemNumber = 'DIV824'),'12','7.75','93')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1032'),'16',(Select ItemID from Item where ItemNumber = 'LDG24'),'12','3.5','42')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'150','7.45','1117.5')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'72','44.24','3185.28')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'32','37.34','1194.88')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','32.67','522.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','31.12','497.92')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'70','9.02','631.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'35','11.34','396.9')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1033'),'8',(Select ItemID from Item where ItemNumber = 'WH5BR'),'35','14.13','494.55')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1034'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'600','1.12','672')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1035'),'1',(Select ItemID from Item where ItemNumber = 'POST63'),'16','9.06','144.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1035'),'2',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'8','12.15','97.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1035'),'3',(Select ItemID from Item where ItemNumber = 'WH5BR'),'8','14.5','116')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1035'),'4',(Select ItemID from Item where ItemNumber = 'SH4818CQ'),'12','31.54','378.48')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1035'),'5',(Select ItemID from Item where ItemNumber = 'SH4218CQ'),'12','31.54','378.48')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1036'),'1',(Select ItemID from Item where ItemNumber = 'BIN224B'),'192','1.71','328.32')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1037'),'1',(Select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1920','0.93','1785.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'480','1.98','950.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'600','2.51','1506')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'4',(Select ItemID from Item where ItemNumber = 'BIN239B'),'240','4.04','969.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'5',(Select ItemID from Item where ItemNumber = 'BIN250B'),'60','6.32','379.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'6',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'32','3.44','110.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'7',(Select ItemID from Item where ItemNumber = 'BIN164B'),'24','3.5','84')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'8',(Select ItemID from Item where ItemNumber = 'LINER4824'),'20','7.31','146.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1038'),'9',(Select ItemID from Item where ItemNumber = 'LINER6024'),'40','9.12','364.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'200','6.34','1268')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'40','38.97','1558.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'40','33.55','1342')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','28.13','1125.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'40','27.53','1101.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'80','7.6','608')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'40','10.02','400.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'8',(Select ItemID from Item where ItemNumber = 'WH5BR'),'40','12.23','489.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1039'),'9',(Select ItemID from Item where ItemNumber = 'SH7224CQ'),'40','44.99','1799.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1040'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'600','1.12','672')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'960','0.9','864')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'240','1.56','374.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'120','2.55','306')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'300','3.88','1164')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'24','4.36','104.64')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'120','6.29','754.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'7',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'32','2.96','94.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1041'),'8',(Select ItemID from Item where ItemNumber = 'LDG24'),'16','3.67','58.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'180','7.28','1310.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'48','44.82','2151.36')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'48','38.5','1848')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'40','32.1','1284')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'5',(Select ItemID from Item where ItemNumber = 'POST63'),'68','9.06','616.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'6',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'34','12.15','413.1')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1042'),'7',(Select ItemID from Item where ItemNumber = 'WH5BR'),'34','14.5','493')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'312','0.9','280.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'84','1.56','131.04')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'72','2.55','183.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'42','3.88','162.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'5',(Select ItemID from Item where ItemNumber = 'BIN239B'),'36','4.36','156.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'6',(Select ItemID from Item where ItemNumber = 'BIN255B'),'36','6.29','226.44')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'7',(Select ItemID from Item where ItemNumber = 'LINER4824'),'4','8.19','32.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'8',(Select ItemID from Item where ItemNumber = 'LINER6024'),'4','9.84','39.36')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'9',(Select ItemID from Item where ItemNumber = 'DIV824'),'48','7.62','365.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1043'),'10',(Select ItemID from Item where ItemNumber = 'LDG24'),'48','3.67','176.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'50','7.28','364')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'8','44.82','358.56')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'3',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'16','32.1','513.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'4',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','31','496')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'5',(Select ItemID from Item where ItemNumber = 'POST63'),'20','9.06','181.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'6',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'10','12.15','121.5')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1044'),'7',(Select ItemID from Item where ItemNumber = 'WH5BR'),'10','14.5','145')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'960','1.12','1075.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'360','1.71','615.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'240','2.86','686.4')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'120','4.4','528')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'5',(Select ItemID from Item where ItemNumber = 'BIN255B'),'120','6.58','789.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1045'),'6',(Select ItemID from Item where ItemNumber = 'BIN250B'),'24','7.9','189.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'50','7.45','372.5')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'54','44.24','2388.96')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'3',(Select ItemID from Item where ItemNumber = 'SH4824CQ'),'24','37.34','896.16')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'4',(Select ItemID from Item where ItemNumber = 'SH3624CQ'),'12','32.67','392.04')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'5',(Select ItemID from Item where ItemNumber = 'SH2424CQ'),'16','31.12','497.92')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'6',(Select ItemID from Item where ItemNumber = 'POST63'),'16','9.02','144.32')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'7',(Select ItemID from Item where ItemNumber = 'WH5BMP'),'8','11.34','90.72')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1046'),'8',(Select ItemID from Item where ItemNumber = 'WH5BR'),'8','14.13','113.04')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1047'),'1',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'16','3.13','50.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1048'),'1',(Select ItemID from Item where ItemNumber = 'DIV824'),'40','7.75','310')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1048'),'2',(Select ItemID from Item where ItemNumber = 'LDG24'),'40','3.5','140')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1049'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1200','1.12','1344')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1049'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'144','1.71','246.24')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1049'),'3',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'16','3.13','50.08')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1050'),'1',(Select ItemID from Item where ItemNumber = 'LINER4824'),'8','8.19','65.52')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1051'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'840','1.12','940.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1051'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'144','1.71','246.24')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1051'),'3',(Select ItemID from Item where ItemNumber = 'BIN230B'),'120','2.86','343.2')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '1051'),'4',(Select ItemID from Item where ItemNumber = 'BIN235B'),'120','4.4','528')

insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9905'),'1',(Select ItemID from Item where ItemNumber = 'BIN110B'),'1008','1.72','1733.76')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9905'),'2',(Select ItemID from Item where ItemNumber = 'BIN224B'),'96','3.13','300.48')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9905'),'3',(Select ItemID from Item where ItemNumber = 'BIN305A3'),'48','3.7','177.6')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9906'),'1',(Select ItemID from Item where ItemNumber = 'SLAT55'),'300','8.28','2484')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9906'),'2',(Select ItemID from Item where ItemNumber = 'SH6024CQ'),'128','45.85','5868.8')
insert into ClientInvoiceLine (ClientInvoiceID,ClientInvoiceLine,ItemID,Qty,UnitCost,SubTotal) VALUES ((Select ClientInvoiceID from ClientInvoice where ClientInvoice = '9907'),'1',(Select ItemID from Item where ItemNumber = 'BIN255B'),'42','10.3','432.6')



*/