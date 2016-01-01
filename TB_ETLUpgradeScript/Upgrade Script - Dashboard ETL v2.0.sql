/*
Upgrade Script to copy in the etl_ and tb_ sprocs used in both the daily etl and to populate data sources in the Tableau WOrkbooks
20151211 - Created By John Ratte

*/




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET NOCOUNT ON
GO

/*********************************************************************
--etl schema
*********************************************************************/
if not exists (select * from sys.schemas where name = 'etl')
BEGIN
EXEC sp_executesql N'Create SCHEMA etl AUTHORIZATION  dbo'
Print 'Schema etl created'
END
GO


/*********************************************************************
--Dim and Fact Tables
*********************************************************************/
if not exists (select * from sys.tables where name = 'DimItem')
BEGIN
CREATE TABLE [bluebin].[DimItem](
	[ItemKey] [bigint] NULL,
	[ItemID] [char](32) NOT NULL,
	[ItemDescription] [char](30) NOT NULL,
	[ItemDescription2] [char](30) NOT NULL,
	[ItemClinicalDescription] [char](30) NULL,
	[ActiveStatus] [char](1) NOT NULL,
	[ItemManufacturer] [char](30) NULL,
	[ItemManufacturerNumber] [char](35) NOT NULL,
	[ItemVendor] [char](30) NULL,
	[ItemVendorNumber] [char](9) NULL,
	[LastPODate] [datetime] NULL,
	[StockLocation] [char](7) NULL,
	[VendorItemNumber] [char](32) NULL,
	[StockUOM] [char](4) NOT NULL,
	[BuyUOM] [char](4) NULL,
	[PackageString] [varchar](38) NULL
) ON [PRIMARY]
END


if not exists(select * from sys.columns where name = 'StockUOM' and object_id = (select object_id from sys.tables where name = 'DimItem'))
BEGIN
ALTER TABLE [bluebin].[DimItem] ADD [StockUOM] char(4);
END
GO

/*********************************************************************
--etl tables
*********************************************************************/


/****** Object:  Table [etl].[JobHeader]    Script Date: 12/11/2015 2:43:36 PM ******/
if not exists (select * from sys.tables where name = 'JobHeader')
BEGIN
CREATE TABLE [etl].[JobHeader](
	[ProcessID] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Duration]  AS ((((right('0'+CONVERT([varchar],datediff(hour,[StartTime],[EndTime]),(0)),(2))+':')+right('0'+CONVERT([varchar],datediff(minute,[StartTime],[EndTime]),(0)),(2)))+':')+right('0'+CONVERT([varchar],datediff(second,[StartTime],[EndTime])%(60),(0)),(2))),
	[Result] [varchar](50) NULL
) ON [PRIMARY]
END



/****** Object:  Table [etl].[JobDetails]    Script Date: 12/11/2015 2:43:36 PM ******/
if not exists (select * from sys.tables where name = 'JobDetails')
BEGIN
CREATE TABLE [etl].[JobDetails](
	[ProcessID] [int] NULL,
	[StepName] [varchar](50) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Duration]  AS ((((right('0'+CONVERT([varchar],datediff(hour,[StartTime],isnull([EndTime],getdate())),(0)),(2))+':')+right('0'+CONVERT([varchar],round(datediff(second,[StartTime],isnull([EndTime],getdate()))/(60),(0)),(0)),(2)))+':')+right('0'+CONVERT([varchar],datediff(second,[StartTime],isnull([EndTime],getdate()))%(60),(0)),(2))),
	[RowCount] [int] NULL,
	[Result] [varchar](50) NULL,
	[Message] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

if not exists(select * from sys.columns where name = 'Message' and object_id = (select object_id from sys.tables where name = 'JobDetails'))
BEGIN
ALTER TABLE [etl].[JobDetails] ADD [Message] varchar(max);
END
GO



/****** Object:  Table [etl].[JobSteps]    Script Date: 12/11/2015 2:43:36 PM ******/
if not exists (select * from sys.tables where name = 'JobSteps')
BEGIN

CREATE TABLE [etl].[JobSteps](
	[StepNumber] [int] NOT NULL,
	[StepName] [varchar](255) NOT NULL,
	[StepProcedure] [varchar](255) NOT NULL,
	[StepTable] [varchar](255) NULL,
	[ActiveFlag] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY]
;  select * from etl.JobSteps 
insert into etl.JobSteps (StepNumber,StepName,StepProcedure,StepTable,ActiveFlag,LastModifiedDate) VALUES
('1','DimItem','etl_DimItem','bluebin.DimItem',0,getdate()),
('2','DimLocation','etl_DimLocation','bluebin.DimLocation',0,getdate()),
('3','DimDate','etl_DimDate','bluebin.DimDate',0,getdate()),
('4','DimBinStatus','etl_DimBinStatus','bluebin.DimBinStatus',0,getdate()),
('5','DimBin','etl_DimBin','bluebin.DimBin',0,getdate()),
('6','FactScan','etl_FactScan','bluebin.FactScan',0,getdate()),
('7','FactBinSnapshot','etl_FactBinSnapshot','bluebin.FactBinSnapshot',0,getdate()),
('9','FactIssue','etl_FactIssue','bluebin.FactIssue',0,getdate()),
('10','FactWarehouseSnapshot','etl_FactWarehouseSnapshot','bluebin.FactWarehouseSnapshot',0,getdate()),
('11','Kanban','tb_Kanban','tableau.Kanban',0,getdate()),
('12','Sourcing','tb_Sourcing','tableau.Sourcing',0,getdate()),
('13','Contracts','tb_Contracts','tableau.Contracts',0,getdate()),
('8','Update Bin Status','etl_UpdateBinStatus','bluebin.DimBin',0,getdate()),
('14','Warehouse Item','etl_DimWarehouseItem','bluebin.DimWarehouseItem',0,getdate())
END
GO

/****** Object:  Table [bluebin].[DimWarehouseItem]    Script Date: 12/11/2015 2:43:36 PM ******/
if not exists (select * from sys.tables where name = 'DimWarehouseItem')
BEGIN
CREATE TABLE [bluebin].[DimWarehouseItem](
	[LocationID] [char](5) NULL,
	[LocationName] [char](30) NULL,
	[ItemKey] [bigint] NULL,
	[ItemID] [char](32) NOT NULL,
	[ItemDescription] [char](30) NOT NULL,
	[ItemClinicalDescription] [char](30) NULL,
	[ItemManufacturer] [char](30) NULL,
	[ItemManufacturerNumber] [char](35) NOT NULL,
	[ItemVendor] [char](30) NULL,
	[ItemVendorNumber] [char](9) NULL,
	[StockLocation] [char](7) NOT NULL,
	[SOHQty] [decimal](13, 4) NOT NULL,
	[ReorderQty] [decimal](13, 4) NOT NULL,
	[ReorderPoint] [decimal](13, 4) NOT NULL,
	[UnitCost] [decimal](18, 5) NOT NULL,
	[StockUOM] [char](4) NOT NULL,
	[BuyUOM] [char](4) NULL,
	[PackageString] [varchar](38) NULL
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO


Print 'Tables Updated'
GO

/*********************************************************************
--etl sprocs
*********************************************************************/

/******************************************

			DimItem

******************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimItem')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimItem
GO


CREATE PROCEDURE etl_DimItem

AS

/**************		SET BUSINESS RULES		***************/
DECLARE @PrimaryLocation varchar(50) 
select @PrimaryLocation = ConfigValue from bluebin.Config where ConfigName = 'LOCATION'



/**************		DROP DimItem			***************/

BEGIN Try
    DROP TABLE bluebin.DimItem
END Try

BEGIN Catch
END Catch


/**************		CREATE Temp Tables			*******************/


SELECT ITEM,
       USER_FIELD3 AS ClinicalDescription
INTO   #ClinicalDescriptions
FROM   ITEMLOC
WHERE  LOCATION = @PrimaryLocation
       AND Len(Ltrim(USER_FIELD3)) > 0

SELECT ITEM,
       Max(PO_DATE) AS LAST_PO_DATE
INTO   #LastPO
FROM   POLINE a
       INNER JOIN PURCHORDER b
               ON a.PO_NUMBER = b.PO_NUMBER
                  AND a.COMPANY = b.COMPANY
                  AND a.PO_CODE = b.PO_CODE
GROUP  BY ITEM

SELECT ITEM,
       PREFER_BIN
INTO   #StockLocations
FROM   ITEMLOC
WHERE  LOCATION = @PrimaryLocation

SELECT a.ITEM,
       a.VENDOR,
       a.VEN_ITEM,
       a.UOM,
       a.UOM_MULT
INTO #ItemContract
FROM   POVAGRMTLN a
       INNER JOIN (SELECT ITEM,
						  MAX(LINE_NBR)		AS LINE_NBR,
                          Max(EFFECTIVE_DT) AS EFFECTIVE_DT,
                          Max(EXPIRE_DT)    AS EXPIRE_DT
                   FROM   POVAGRMTLN
                   WHERE  HOLD_FLAG = 'N'
                   GROUP  BY ITEM) b
               ON a.ITEM = b.ITEM
                  AND a.EFFECTIVE_DT = b.EFFECTIVE_DT
                  AND a.EXPIRE_DT = b.EXPIRE_DT
				  AND a.LINE_NBR = b.LINE_NBR
WHERE  a.HOLD_FLAG = 'N'




/*********************		CREATE DimItem		**************************************/


SELECT Row_number()
         OVER(
           ORDER BY a.ITEM)                AS ItemKey,
       a.ITEM                              AS ItemID,
       a.DESCRIPTION                       AS ItemDescription,
	   a.DESCRIPTION2					AS ItemDescription2,
       e.ClinicalDescription               AS ItemClinicalDescription,
       a.ACTIVE_STATUS                     AS ActiveStatus,
       b.DESCRIPTION                        AS ItemManufacturer,
       a.MANUF_NBR                         AS ItemManufacturerNumber,
       d.VENDOR_VNAME                      AS ItemVendor,
       c.VENDOR                            AS ItemVendorNumber,
       f.LAST_PO_DATE                      AS LastPODate,
       g.PREFER_BIN                        AS StockLocation,
       h.VEN_ITEM                          AS VendorItemNumber,
	   a.STOCK_UOM							AS StockUOM,
       h.UOM                               AS BuyUOM,
       CONVERT(VARCHAR, Cast(h.UOM_MULT AS INT))
       + ' EA' + '/'+Ltrim(Rtrim(h.UOM)) AS PackageString
INTO   bluebin.DimItem
FROM   ITEMMAST a
       LEFT JOIN ICMANFCODE b
              ON a.MANUF_CODE = b.MANUF_CODE
       LEFT JOIN ITEMSRC c
              ON a.ITEM = c.ITEM
                 AND c.REPLENISH_PRI = 1
                 AND c.LOCATION = @PrimaryLocation
       LEFT JOIN APVENMAST d
              ON c.VENDOR = d.VENDOR
       LEFT JOIN #ClinicalDescriptions e
              ON a.ITEM = e.ITEM
       LEFT JOIN #LastPO f
              ON a.ITEM = f.ITEM
       LEFT JOIN #StockLocations g
              ON a.ITEM = g.ITEM
       LEFT JOIN #ItemContract h
              ON a.ITEM = h.ITEM
                 AND c.VENDOR = h.VENDOR



/*********************		DROP Temp Tables	*********************************/


DROP TABLE #ClinicalDescriptions

DROP TABLE #LastPO

DROP TABLE #StockLocations

DROP TABLE #ItemContract

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimItem'
GO


/********************************************************************

					DimLocation

********************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimLocation')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimLocation
GO


CREATE PROCEDURE etl_DimLocation
AS

/********************		DROP DimLocation	***************************/
  BEGIN TRY
      DROP TABLE bluebin.DimLocation
  END TRY

  BEGIN CATCH
  END CATCH

/*********************		CREATE DimLocation	****************************/
    SELECT Row_number()
             OVER(
               ORDER BY REQ_LOCATION) AS LocationKey,
           REQ_LOCATION               AS LocationID,
           NAME                       AS LocationName,
           COMPANY                    AS LocationFacility,
           CASE
             WHEN LEFT(REQ_LOCATION, 2) IN (SELECT [ConfigValue]
                                            FROM   [bluebin].[Config]
                                            WHERE  [ConfigName] = 'REQ_LOCATION'
                                                   AND Active = 1) THEN 1
             ELSE 0
           END                        AS BlueBinFlag
    INTO   bluebin.DimLocation
    FROM   RQLOC 
GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimLocation'
GO

/********************************************************

		DimDate

********************************************************/


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimDate')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimDate
GO

CREATE PROCEDURE etl_DimDate
AS
  BEGIN TRY
      DROP TABLE bluebin.DimDate
  END TRY

  BEGIN CATCH
  /*No Action*/
  END CATCH

  BEGIN TRY
      DROP TABLE bluebin.DimSnapshotDate
  END TRY

  BEGIN CATCH
  /*No Action*/
  END CATCH

    /********************		CREATE DimDate Table		*****************************/
    CREATE TABLE bluebin.DimDate
      (
         [DateKey] INT PRIMARY KEY,
         [Date]    DATETIME
      )

    /***************************	SET Date Range for DimDate (2 years back, 1 year forward)		*****************************/
    DECLARE @StartDate DATETIME = Dateadd(yy, -2, Dateadd(yy, Datediff(yy, 0, Getdate()), 0)) --Starting value of Date Range
    DECLARE @EndDate DATETIME = Dateadd(yy, 1, Dateadd(yy, Datediff(yy, 0, Getdate()) + 1, -1)) --End Value of Date Range
    --Extract and assign various parts of Values from Current Date to Variable
    DECLARE @CurrentDate AS DATETIME = @StartDate

    --Proceed only if Start Date(Current date ) is less than End date you specified above
    WHILE @CurrentDate < @EndDate
      BEGIN
          --Populate Your Dimension Table with values
          INSERT INTO bluebin.DimDate
          SELECT CONVERT (CHAR(8), @CurrentDate, 112) AS DateKey,
                 @CurrentDate                         AS Date

          SET @CurrentDate = Dateadd(DD, 1, @CurrentDate)
      END

    /********************************		CREATE DimDateSnapshot		***************************************/
    CREATE TABLE bluebin.DimSnapshotDate
      (
         [DateKey] INT PRIMARY KEY,
         [Date]    DATETIME
      )

    /*************************************		SET Date Range values (90 day window)					***********************/
    SET @StartDate = Dateadd(dd, -90, Dateadd(dd, Datediff(dd, 0, Getdate()), 0)) --Starting value of Date Range
    SET @EndDate = Dateadd(dd, Datediff(dd, 0, Getdate()), 0) --End Value of Date Range
    --Extract and assign various parts of Values from Current Date to Variable
    SET @CurrentDate = @StartDate

    --Proceed only if Start Date(Current date ) is less than End date you specified above
    WHILE @CurrentDate < @EndDate
      BEGIN
          /* Populate Your Dimension Table with values*/
          INSERT INTO bluebin.DimSnapshotDate
          SELECT CONVERT (CHAR(8), @CurrentDate, 112) AS DateKey,
                 @CurrentDate                         AS Date

          SET @CurrentDate = Dateadd(DD, 1, @CurrentDate)
      END 
GO


UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimDate'
GO


/***********************************************************

			DimBinStatus

***********************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimBinStatus')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimBinStatus
GO

CREATE PROCEDURE etl_DimBinStatus

AS

BEGIN TRY
DROP TABLE bluebin.DimBinStatus
END TRY

BEGIN CATCH
END CATCH


CREATE TABLE [bluebin].[DimBinStatus](
	[BinStatusKey] [int] NULL,
	[BinStatus] [varchar](50) NULL
) ON [PRIMARY]



INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 1, 'Critical')
INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 2, 'Hot')
INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 3, 'Healthy' )
INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 4, 'Slow' )
INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 5, 'Stale' )
INSERT INTO bluebin.DimBinStatus (	BinStatusKey,	BinStatus	) VALUES( 6, 'Never Scanned')

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimBinStatus'
GO




/************************************************************

				DimBin

************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimBin')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimBin
GO

CREATE PROCEDURE etl_DimBin

AS


/***************************		DROP DimBin		********************************/
BEGIN TRY
    DROP TABLE bluebin.DimBin
END TRY

BEGIN CATCH
END CATCH


/***************************		CREATE Temp Tables		*************************/

SELECT REQ_LOCATION,
       Min(CREATION_DATE) AS BinAddedDate
INTO   #BinAddDates
FROM   REQLINE a INNER JOIN bluebin.DimLocation b ON a.REQ_LOCATION = b.LocationID
WHERE  b.BlueBinFlag = 1
GROUP  BY REQ_LOCATION

SELECT Row_number()
         OVER(
           Partition BY ITEM, ENTERED_UOM
           ORDER BY CREATION_DATE DESC) AS Itemreqseq,
       ITEM,
       ENTERED_UOM,
       UNIT_COST
INTO   #ItemReqs
FROM   REQLINE a INNER JOIN bluebin.DimLocation b ON a.REQ_LOCATION = b.LocationID
WHERE  b.BlueBinFlag = 1

SELECT Row_number()
         OVER(
           Partition BY ITEM, ENT_BUY_UOM
           ORDER BY PO_NUMBER DESC) AS ItemOrderSeq,
       ITEM,
       ENT_BUY_UOM,
       ENT_UNIT_CST
INTO   #ItemOrders
FROM   POLINE
WHERE  ITEM_TYPE IN ( 'I', 'N' )
       AND ITEM IN (SELECT DISTINCT ITEM
                    FROM   ITEMLOC a INNER JOIN bluebin.DimLocation b ON a.LOCATION = b.LocationID
WHERE  b.BlueBinFlag = 1)

SELECT ITEMLOC.ITEM,
       ITEMLOC.GL_CATEGORY,
       ICCATEGORY.ISS_ACCOUNT
INTO   #ItemAccounts
FROM   ITEMLOC
       LEFT JOIN ICCATEGORY
              ON ITEMLOC.GL_CATEGORY = ICCATEGORY.GL_CATEGORY
                 AND ITEMLOC.LOCATION = ICCATEGORY.LOCATION
WHERE  ITEMLOC.LOCATION in (select ConfigValue from bluebin.Config where ConfigName = 'LOCATION')

SELECT ITEM,
       LAST_ISS_COST
INTO   #ItemStore
FROM   ITEMLOC
WHERE  LOCATION in (select ConfigValue from bluebin.Config where ConfigName = 'LOCATION')


/***********************************		CREATE	DimBin		***********************************/

SELECT Row_number()
             OVER(
               ORDER BY ITEMLOC.LOCATION, ITEMLOC.ITEM)                                               AS BinKey,
			   ITEMLOC.COMPANY																			AS BinFacility,
           ITEMLOC.ITEM                                                                               AS ItemID,
           ITEMLOC.LOCATION                                                                           AS LocationID,
           PREFER_BIN                                                                                 AS BinSequence,
		   	CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN LEFT(PREFER_BIN, 2) ELSE LEFT(PREFER_BIN, 1) END as BinCart,
			CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING(PREFER_BIN, 3, 1) ELSE SUBSTRING(PREFER_BIN, 2,1) END as BinRow,
			CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING (PREFER_BIN,4,2) ELSE SUBSTRING(PREFER_BIN, 3,2) END as BinPosition,
           CASE
             WHEN PREFER_BIN LIKE 'CARD%' THEN 'WALL'
             ELSE RIGHT(PREFER_BIN, 3)
           END                                                                                        AS BinSize,
           UOM                                                                                        AS BinUOM,
           REORDER_POINT                                                                              AS BinQty,
           CASE
             WHEN LEADTIME_DAYS = 0 THEN 3
             ELSE LEADTIME_DAYS
           END                                                                                        AS BinLeadTime,
           #BinAddDates.BinAddedDate                                                                  AS BinGoLiveDate,
           COALESCE(COALESCE(#ItemReqs.UNIT_COST, #ItemOrders.ENT_UNIT_CST), #ItemStore.LAST_ISS_COST) AS BinCurrentCost,
           CASE
             WHEN ITEMLOC.USER_FIELD1 = 'Consignment                   ' THEN 'Y'
             ELSE 'N'
           END                                                                                        AS BinConsignmentFlag,
           #ItemAccounts.ISS_ACCOUNT                                                                  AS BinGLAccount,
		   'Awaiting Updated Status'																							AS BinCurrentStatus
    INTO   bluebin.DimBin
    FROM   ITEMLOC
           INNER JOIN bluebin.DimLocation
                   ON ITEMLOC.LOCATION = DimLocation.LocationID
				   AND ITEMLOC.COMPANY = DimLocation.LocationFacility			   
           INNER JOIN #BinAddDates
                   ON ITEMLOC.LOCATION = #BinAddDates.REQ_LOCATION
           LEFT JOIN #ItemReqs
                  ON ITEMLOC.ITEM = #ItemReqs.ITEM
                     AND ITEMLOC.UOM = #ItemReqs.ENTERED_UOM
                     AND #ItemReqs.Itemreqseq = 1
           LEFT JOIN #ItemOrders
                  ON ITEMLOC.ITEM = #ItemOrders.ITEM
                     AND ITEMLOC.UOM = #ItemOrders.ENT_BUY_UOM
                     AND #ItemOrders.ItemOrderSeq = 1
           LEFT JOIN #ItemAccounts
                  ON ITEMLOC.ITEM = #ItemAccounts.ITEM
           LEFT JOIN #ItemStore
                  ON ITEMLOC.ITEM = #ItemStore.ITEM
	WHERE DimLocation.BlueBinFlag = 1


/*****************************************		DROP Temp Tables	**************************************/

DROP TABLE #BinAddDates
DROP TABLE #ItemReqs
DROP TABLE #ItemOrders
DROP TABLE #ItemAccounts
DROP TABLE #ItemStore

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimBin'


/*******************************************

		FactScan

********************************************/



IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_FactScan')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_FactScan
GO

CREATE PROCEDURE etl_FactScan

AS

/*****************************		DROP FactScan		*******************************/

BEGIN Try
    DROP TABLE bluebin.FactScan
END Try

BEGIN Catch
END Catch

/********************************		CREATE Temp Tables			******************************/

SELECT COMPANY,
       CASE 
			WHEN LEN(DOCUMENT) = 10 and LEFT(DOCUMENT,6) = '000000' THEN RIGHT(DOCUMENT,4)
			WHEN LEN(DOCUMENT) = 10 and LEFT(DOCUMENT,5) = '00000' THEN RIGHT(DOCUMENT,5)
			WHEN LEN(DOCUMENT) = 10 and LEFT(DOCUMENT,4) = '0000' THEN RIGHT(DOCUMENT,6)
			WHEN LEN(DOCUMENT) = 10 and LEFT(DOCUMENT,3) = '000' THEN RIGHT(DOCUMENT,7)
		ELSE DOCUMENT 
		END AS DOCUMENT,
       LINE_NBR,
       Cast(CONVERT(VARCHAR, TRANS_DATE, 101) + ' '
            + LEFT(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 3, 2) AS DATETIME) AS TRANS_DATE
INTO #ICTRANS
FROM   ICTRANS a
       INNER JOIN bluebin.DimLocation b
               ON a.FROM_TO_LOC = b.LocationID
WHERE b.BlueBinFlag = 1

SELECT COMPANY,
	   CASE 
			WHEN LEN(REQ_NUMBER) = 10 and LEFT(REQ_NUMBER,6) = '000000' THEN RIGHT(REQ_NUMBER,4)
			WHEN LEN(REQ_NUMBER) = 10 and LEFT(REQ_NUMBER,5) = '00000' THEN RIGHT(REQ_NUMBER,5)
			WHEN LEN(REQ_NUMBER) = 10 and LEFT(REQ_NUMBER,4) = '0000' THEN RIGHT(REQ_NUMBER,6)
			WHEN LEN(REQ_NUMBER) = 10 and LEFT(REQ_NUMBER,3) = '000' THEN RIGHT(REQ_NUMBER,7)
		ELSE REQ_NUMBER 
		END AS REQ_NUMBER,
       LINE_NBR,
       ITEM,
       REQ_LOCATION,
       ENTERED_UOM,
       QUANTITY,
       ITEM_TYPE,
       CREATION_TIME,
       Cast(CONVERT(VARCHAR, CREATION_DATE, 101) + ' '
            + LEFT(RIGHT('00000' + CONVERT(VARCHAR, CREATION_TIME), 8), 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, CREATION_TIME), 8), 3, 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, CREATION_TIME), 8), 5, 2) AS DATETIME) AS CREATION_DATE
INTO #REQLINE
FROM   REQLINE
WHERE  STATUS = 9
       AND KILL_QUANTITY = 0

SELECT 
		CASE
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,6) = '000000' THEN RIGHT(a.SOURCE_DOC_N,4)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,5) = '00000' THEN RIGHT(a.SOURCE_DOC_N,5)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,4) = '0000' THEN RIGHT(a.SOURCE_DOC_N,6)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,3) = '000' THEN RIGHT(a.SOURCE_DOC_N,7)	
		ELSE a.SOURCE_DOC_N 
		END AS REQ_NUMBER,
       a.SRC_LINE_NBR                                                                         AS LINE_NBR,
       MIN(Cast(CONVERT(VARCHAR, b.REC_DATE, 101) + ' '
            + LEFT(RIGHT('00000' + CONVERT(VARCHAR, UPDATE_TIME), 8), 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, UPDATE_TIME), 8), 3, 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, UPDATE_TIME), 8), 5, 2) AS DATETIME)) AS REC_DATE
INTO #POLINE
FROM   POLINESRC a
       INNER JOIN PORECLINE b
               ON a.PO_NUMBER = b.PO_NUMBER
                  AND a.LINE_NBR = b.PO_LINE_NBR 
GROUP BY
	a.SOURCE_DOC_N,
	a.SRC_LINE_NBR

SELECT Row_number()
         OVER(
           Partition BY b.BinKey
           ORDER BY a.CREATION_DATE DESC) AS Scanseq,
       Row_number()
         OVER(
           Partition BY b.BinKey
           ORDER BY a.CREATION_DATE ASC) AS ScanHistseq,
       a.COMPANY					AS OrderFacility,
	   b.BinKey,
       b.LocationID,
       b.ItemID,
       b.BinGoLiveDate,
       a.ITEM_TYPE                   AS ItemType,
       a.REQ_NUMBER                  AS OrderNum,
       a.LINE_NBR                    AS LineNum,
       a.ENTERED_UOM                 AS OrderUOM,
       a.QUANTITY                    AS OrderQty,
       a.CREATION_DATE               AS OrderDate,
       CASE
         WHEN a.ITEM_TYPE = 'I' THEN e.TRANS_DATE
         WHEN a.ITEM_TYPE = 'N' THEN c.REC_DATE
         ELSE NULL
       END                           AS OrderCloseDate
INTO   #tmpScan
FROM   #REQLINE a
       INNER JOIN bluebin.DimBin b
               ON a.ITEM = b.ItemID
                  AND a.REQ_LOCATION = b.LocationID
				  AND a.COMPANY = b.BinFacility
       LEFT JOIN #POLINE c 
			ON a.REQ_NUMBER = c.REQ_NUMBER 
			AND a.LINE_NBR = c.LINE_NBR
       LEFT JOIN #ICTRANS e
              ON
                 a.REQ_NUMBER = e.DOCUMENT
                 AND a.LINE_NBR = e.LINE_NBR 
				 --AND a.COMPANY = e.COMPANY  --Only need this if three are multiple companies coming into ICTRANS


/***********************************		CREATE FactScan		****************************************/


SELECT a.Scanseq,
       a.ScanHistseq,
       a.BinKey,
       c.LocationKey,
       d.ItemKey,
       a.BinGoLiveDate,
       a.OrderNum,
       a.LineNum,
       a.ItemType,
       a.OrderUOM,
       Cast(a.OrderQty AS INT) AS OrderQty,
       a.OrderDate,
       a.OrderCloseDate,
       b.OrderDate             AS PrevOrderDate,
       b.OrderCloseDate        AS PrevOrderCloseDate,
       1                       AS Scan,
       CASE
         WHEN Datediff(Day, b.OrderDate, a.OrderDate) < 3 THEN 1
         ELSE 0
       END                     AS HotScan,
       CASE
         WHEN a.OrderDate < COALESCE(b.OrderCloseDate, Getdate())
              AND a.ScanHistseq > 2 THEN 1
         ELSE 0
       END                     AS StockOut
INTO   bluebin.FactScan
FROM   #tmpScan a
       LEFT JOIN #tmpScan b
              ON a.BinKey = b.BinKey
                 AND a.Scanseq = b.Scanseq - 1
       LEFT JOIN bluebin.DimLocation c
              ON a.LocationID = c.LocationID	
			  AND a.OrderFacility = c.LocationFacility		
       LEFT JOIN bluebin.DimItem d
              ON a.ItemID = d.ItemID 


/*****************************************		DROP Temp Tables		*******************************/

DROP TABLE #REQLINE
DROP TABLE #ICTRANS
DROP TABLE #POLINE
DROP TABLE #tmpScan

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'FactScan'
GO




/*************************************************

			FactBinSnapshot

*************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_FactBinSnapshot')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_FactBinSnapshot
GO


CREATE PROCEDURE  etl_FactBinSnapshot

AS


/********************************		DROP FactBinSnapshot	****************************/

BEGIN Try
    DROP TABLE bluebin.FactBinSnapshot
END Try

BEGIN Catch
END Catch


/*******************************		CREATE Temp Tables		******************************/

SELECT 
       BinKey,
       MAX(OrderDate) AS LastScannedDate,
       DimSnapshotDate.Date,
	   DATEDIFF(DAY, MAX(OrderDate), Date) as DaysSinceLastScan
INTO   #LastScans
FROM   bluebin.FactScan
       INNER JOIN bluebin.DimSnapshotDate
              ON CAST(CONVERT(varchar,OrderDate,101) as datetime) <= DimSnapshotDate.Date
GROUP BY
		BinKey, Date

		
SELECT DimBin.BinKey,
       DimBin.BinLeadTime,
       DimSnapshotDate.Date,
       Sum(COALESCE(Scan, 0))                                                                          AS ScansInThreshold,
       Sum(COALESCE(HotScan, 0))                                                                       AS HotScansInThreshold,
       Sum(COALESCE(StockOut, 0))                                                                      AS StockOutsInThreshold,
       Sum(CASE
             WHEN Cast(OrderDate AS DATE) = Cast(Dateadd(Day, -1, DimSnapshotDate.Date) AS DATE) THEN StockOut
             ELSE 0
           END)                                                                                        AS StockOutsDaily,
		   AVG(DATEDIFF(HOUR, OrderDate, COALESCE(OrderCloseDate,GETDATE())))						AS TimeToFill,
       ( ( Cast(30 AS FLOAT) / Cast(CASE
                                      WHEN COALESCE(Sum(COALESCE(Scan, 0)), 1) = 0 THEN 1
                                      ELSE COALESCE(Sum(COALESCE(Scan, 0)), 1)
                                    END AS FLOAT) ) / Cast(COALESCE(DimBin.BinLeadTime, 3) AS FLOAT) ) AS BinVelocity
INTO   #ThresholdScans
FROM   bluebin.DimBin
       CROSS JOIN bluebin.DimSnapshotDate
       LEFT JOIN bluebin.FactScan
              ON Cast(DimSnapshotDate.Date AS DATE) >= Cast(OrderDate AS DATE)
                 AND Dateadd(DAY, -30, DimSnapshotDate.Date) <= Cast(OrderDate AS DATE)
                 AND DimBin.BinKey = FactScan.BinKey
WHERE  DimSnapshotDate.Date >= DimBin.BinGoLiveDate
GROUP  BY DimBin.BinKey,
          DimSnapshotDate.Date,
          DimBin.BinLeadTime 

SELECT Date,
       BinKey,
	   BinFacility,
       LocationID,
       ItemID,
       BinGoLiveDate
INTO   #tmpBinDates
FROM   bluebin.DimBin
       CROSS JOIN bluebin.DimSnapshotDate
WHERE  BinGoLiveDate <= Date 

SELECT DISTINCT BinKey
INTO #tmpScannedBins
FROM   bluebin.FactScan


/***********************************		CREATE FactBinSnapshot		*******************************************/

SELECT #tmpBinDates.BinKey,
       DimLocation.LocationKey,
       DimItem.ItemKey,
       #tmpBinDates.Date                                                                 AS BinSnapshotDate,
       COALESCE(LastScannedDate, #tmpBinDates.BinGoLiveDate)                              AS LastScannedDate,
       COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) AS DaysSinceLastScan,
       COALESCE(ScansInThreshold, 0)                                                AS ScanSinThreshold,
       COALESCE(HotScansInThreshold, 0)                                             AS HotScanSinThreshold,
       COALESCE(StockOutsInThreshold, 0)                                            AS StockOutSinThreshold,
       COALESCE(StockOutsDaily, 0)                                                  AS StockOutsDaily,
	   TimeToFill,
	   BinVelocity,
       CASE 
	    WHEN #tmpScannedBins.BinKey IS NULL AND COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) < 90  THEN 6
		WHEN COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) >= 180 THEN 5
		WHEN COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) BETWEEN 90 AND 180 THEN 4
		WHEN COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) < 90 AND BinVelocity >= 1.25 THEN 3
		WHEN COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) < 90 AND BinVelocity BETWEEN .75 AND 1.25 THEN 2
		WHEN COALESCE(DaysSinceLastScan, Datediff(Day, #tmpBinDates.BinGoLiveDate, #tmpBinDates.Date)) < 90 AND BinVelocity < .75 THEN 1
		ELSE 0 END																	AS BinStatusKey		
		
INTO   bluebin.FactBinSnapshot

FROM   #tmpBinDates
       LEFT JOIN #LastScans
              ON #tmpBinDates.BinKey = #LastScans.BinKey
                 AND #tmpBinDates.Date = #LastScans.Date
       LEFT JOIN #ThresholdScans
              ON #tmpBinDates.BinKey = #ThresholdScans.BinKey
                 AND #tmpBinDates.Date = #ThresholdScans.Date
       LEFT JOIN bluebin.DimLocation
              ON #tmpBinDates.LocationID = DimLocation.LocationID
			  AND #tmpBinDates.BinFacility = DimLocation.LocationFacility
       LEFT JOIN bluebin.DimItem
              ON #tmpBinDates.ItemID = DimItem.ItemID
		LEFT JOIN #tmpScannedBins
			ON #tmpBinDates.BinKey = #tmpScannedBins.BinKey


/**************************************		DROP Temp Tables		********************************************/

DROP TABLE #LastScans
DROP TABLE #ThresholdScans 
DROP TABLE #tmpBinDates
DROP TABLE #tmpScannedBins

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'FactBinSnapshot'
GO

/*********************************************************************

		FactIssue

*********************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_FactIssue')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_FactIssue
GO

CREATE PROCEDURE etl_FactIssue

AS

/****************************		DROP FactIssue ***********************************/
 BEGIN TRY
 DROP TABLE bluebin.FactIssue
 END TRY
 BEGIN CATCH
 END CATCH

 /*******************************	CREATE FactIssue	*********************************/

 SELECT COMPANY                                                                                AS FacilityKey,
       b.LocationKey,
       c.LocationKey                                                                          AS ShipLocationKey,
       c.LocationFacility                                                                     AS ShipFacilityKey,
       d.ItemKey,
       SYSTEM_CD as SourceSystem,
       CASE
         WHEN SYSTEM_CD = 'RQ' THEN DOCUMENT
         ELSE ''
       END                                                                                    AS ReqNumber,
       CASE
         WHEN SYSTEM_CD = 'RQ' THEN LINE_NBR
         ELSE ''
       END                                                                                    AS ReqLineNumber,
       Cast(CONVERT(VARCHAR, TRANS_DATE, 101) + ' '
            + LEFT(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 3, 2) AS DATETIME) AS IssueDate,
       TRAN_UOM as UOM,
       TRAN_UOM_MULT as UOMMult,
       -QUANTITY                                                                              AS IssueQty,
       CASE
         WHEN SYSTEM_CD = 'IC' THEN 1
         ELSE 0
       END                                                                                    AS StatCall,
       1                                                                                      AS IssueCount
INTO bluebin.FactIssue
FROM   ICTRANS a
       LEFT JOIN bluebin.DimLocation b
               ON a.LOCATION = b.LocationID
                  AND a.COMPANY = b.LocationFacility
       LEFT JOIN bluebin.DimLocation c
               ON a.FROM_TO_LOC = c.LocationID
                  AND a.FROM_TO_CMPY = c.LocationFacility
       LEFT JOIN bluebin.DimItem d
               ON a.ITEM = d.ItemID
WHERE  DOC_TYPE = 'IS' 

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'FactIssue'
GO


/****************************************************************

			FactWarehouseSnapshot

****************************************************************/


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_FactWarehouseSnapshot')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_FactWarehouseSnapshot
GO

CREATE PROCEDURE etl_FactWarehouseSnapshot
AS

/*********************		DROP FactWarehouseSnapshot		***************************/

  BEGIN TRY
      DROP TABLE bluebin.FactWarehouseSnapshot
  END TRY

  BEGIN CATCH
  END CATCH

/******************		CREATE Temp Tables				****************************/
    SELECT Row_number()
             OVER(
               PARTITION BY LOCATION, ITEM, Eomonth(TRANS_DATE)
               ORDER BY Cast(CONVERT(VARCHAR, TRANS_DATE, 101) + ' ' + LEFT(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 2) + ':' + Substring(RIGHT('00000' + CONVERT(VARCHAR, ACTUAL_TIME), 4), 3, 2) AS DATETIME) DESC ) AS WarehouseSnapshotSeq,
           *
    INTO   #MonthEndIssues
    FROM   ICTRANS

    SELECT DISTINCT Eomonth(Date) AS MonthEnd
    INTO   #MonthEndDates
    FROM   bluebin.DimDate


/******************		CREATE FactWarehouseSnapshot	***********************************/

    SELECT COMPANY                  AS FacilityKey,
           c.LocationKey,
           d.ItemKey,
           Cast(a.MonthEnd AS DATE) AS SnapshotDate,
           TRAN_UOM                 AS UOM,
           TRAN_UOM_MULT            AS UOMMult,
           SOH_QTY                  AS SOH,
           UNIT_COST                AS UnitCost
    INTO   bluebin.FactWarehouseSnapshot
    FROM   #MonthEndDates a
           LEFT JOIN #MonthEndIssues b
                  ON a.MonthEnd >= b.TRANS_DATE
           INNER JOIN bluebin.DimLocation c
                   ON b.LOCATION = c.LocationID
           INNER JOIN bluebin.DimItem d
                   ON b.ITEM = d.ItemID
    WHERE  b.WarehouseSnapshotSeq = 1
           AND a.MonthEnd <= Getdate()

/*********************	DROP Temp Tables		******************************/
    DROP TABLE #MonthEndDates
    DROP TABLE #MonthEndIssues 


GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'FactWarehouseSnapshot'
GO


/***************************************************************************

			Kanban

***************************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Kanban')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Kanban
GO

CREATE PROCEDURE tb_Kanban

AS

BEGIN TRY
    DROP TABLE tableau.Kanban
END TRY

BEGIN CATCH
END CATCH


SELECT DimBin.BinKey,
       DimBin.LocationID,
       DimBin.ItemID,
       DimBin.BinSequence,
       DimBin.BinUOM,
       DimBin.BinQty,
	   DimBin.BinCurrentCost,
	   DimBin.BinGLAccount,
	   DimBin.BinConsignmentFlag,
       DimBin.BinLeadTime,
       DimBin.BinGoLiveDate,
	   DimBin.BinCurrentStatus,
       DimSnapshotDate.Date,       
	   FactScan.ScanHistseq,
       FactScan.ItemType,       
       FactScan.OrderNum,
       FactScan.LineNum,
       FactScan.OrderUOM,
       FactScan.OrderQty,
       FactScan.OrderDate,
       FactScan.OrderCloseDate,
       FactScan.PrevOrderDate,
       FactScan.PrevOrderCloseDate,
       FactScan.Scan,
       FactScan.HotScan,
       FactScan.StockOut,
       FactBinSnapshot.BinSnapshotDate,
       FactBinSnapshot.LastScannedDate,
       FactBinSnapshot.DaysSinceLastScan,
       FactBinSnapshot.ScanSinThreshold,
       FactBinSnapshot.HotScanSinThreshold,
       FactBinSnapshot.StockOutSinThreshold,
       FactBinSnapshot.StockOutsDaily,
	   FactBinSnapshot.TimeToFill,
	   FactBinSnapshot.BinVelocity,
       DimBinStatus.BinStatus,
       DimItem.ItemDescription,
	   DimItem.ItemClinicalDescription,
       DimItem.ItemManufacturer,
       DimItem.ItemManufacturerNumber,
       DimItem.ItemVendor,
       DimItem.ItemVendorNumber,
       DimLocation.LocationName,
       1 AS TotalBins
INTO   tableau.Kanban
FROM   bluebin.DimBin
       CROSS JOIN bluebin.DimSnapshotDate
       LEFT JOIN bluebin.FactScan
              ON Cast(OrderDate AS DATE) = Cast(Date AS DATE)
                 AND DimBin.BinKey = FactScan.BinKey
       LEFT JOIN bluebin.FactBinSnapshot
              ON Date = BinSnapshotDate
                 AND DimBin.BinKey = FactBinSnapshot.BinKey
       LEFT JOIN bluebin.DimItem
              ON DimBin.ItemID = DimItem.ItemID
       LEFT JOIN bluebin.DimLocation
              ON DimBin.LocationID = DimLocation.LocationID
			  AND DimBin.BinFacility = DimLocation.LocationFacility
       LEFT JOIN bluebin.DimBinStatus
              ON FactBinSnapshot.BinStatusKey = DimBinStatus.BinStatusKey
WHERE  Date >= DimBin.BinGoLiveDate 

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Kanban'
GO


/*****************************************************************************

			Sourcing

*****************************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Sourcing')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Sourcing
GO

CREATE PROCEDURE	tb_Sourcing

AS

/********************************		DROP Sourcing		**********************************/

BEGIN TRY
    DROP TABLE tableau.Sourcing
END TRY

BEGIN CATCH
END CATCH

/**********************************		CREATE Temp Tables		***************************/

-- #tmpPOLines

SELECT a.COMPANY,
       a.PO_NUMBER,
       a.PO_RELEASE,
       a.PO_CODE,
       a.LINE_NBR,
       a.ITEM,
       a.ITEM_TYPE,
       a.DESCRIPTION AS PO_DESCRIPTION,
       a.QUANTITY,
       a.REC_QTY,
       a.AGREEMENT_REF,
       a.ENT_UNIT_CST,
       a.ENT_BUY_UOM,
       a.EBUY_UOM_MULT,
       b.PO_DATE,
       a.EARLY_DL_DATE,
       a.LATE_DL_DATE,
       a.REC_ACT_DATE,
       a.CLOSE_DATE,
       a.LOCATION,
       a.BUYER_CODE,
       a.VENDOR,
       d.REQ_LOCATION,
       a.VEN_ITEM,
       a.CLOSED_FL,
       a.CXL_QTY,
       c.INVOICE_AMT
INTO   #tmpPOLines
FROM   POLINE a
       LEFT JOIN PURCHORDER b
              ON a.PO_NUMBER = b.PO_NUMBER
                 AND a.COMPANY = b.COMPANY
                 AND a.PO_CODE = b.PO_CODE
       LEFT JOIN (SELECT PO_NUMBER,
                         LINE_NBR,
                         Sum(TOT_DIST_AMT) AS INVOICE_AMT
                  FROM   MAINVDTL
                  GROUP  BY PO_NUMBER,
                            LINE_NBR) c
              ON a.PO_NUMBER = c.PO_NUMBER
                 AND a.LINE_NBR = c.LINE_NBR
       LEFT JOIN POLINESRC d
              ON a.COMPANY = d.COMPANY
                 AND a.PO_NUMBER = d.PO_NUMBER
                 AND a.LINE_NBR = d.LINE_NBR
                 AND a.PO_CODE = d.PO_CODE
WHERE  b.PO_DATE >= '1/1/2014'
       AND a.CXL_QTY = 0; 

--#tmpMMDIST
SELECT DOC_NUMBER    AS PO_NUMBER,
       LINE_NBR,
       a.ACCT_UNIT,
       b.DESCRIPTION AS ACCT_UNIT_NAME
INTO #tmpMMDIST
FROM   MMDIST a
       LEFT JOIN GLNAMES b
              ON a.COMPANY = b.COMPANY
                 AND a.ACCT_UNIT = b.ACCT_UNIT
WHERE  SYSTEM_CD = 'PO'
       AND DOC_TYPE = 'PT'
       AND DOC_NUMBER IN (SELECT PO_NUMBER
                          FROM   PURCHORDER
                          WHERE  PO_DATE >= '1/1/2014'); 

--#tmpPOStatus
SELECT Row_number()
         OVER(
           ORDER BY a.PO_NUMBER, a.LINE_NBR) AS POKey,
       COMPANY                           AS Company,
       a.PO_NUMBER                         AS PONumber,
       a.LINE_NBR                          AS POLineNumber,
       PO_RELEASE                        AS PORelease,
       PO_CODE                           AS POCode,
       ITEM                              AS ItemNumber,
       a.VENDOR                            AS VendorCode,
	   d.VENDOR_VNAME					AS VendorName,
       a.BUYER_CODE                        AS Buyer,
	   c.NAME							AS BuyerName,
       LOCATION                          AS ShipLocation,
       ACCT_UNIT                         AS AcctUnit,
       ACCT_UNIT_NAME                    AS AcctUnitName,
       PO_DESCRIPTION                    AS PODescr,
       QUANTITY                          AS QtyOrdered,
       REC_QTY                           AS QtyReceived,
       AGREEMENT_REF                     AS AgrmtRef,
       ENT_UNIT_CST                      AS UnitCost,
       ENT_BUY_UOM                       AS BuyUOM,
       EBUY_UOM_MULT                     AS BuyUOMMult,
       PO_DATE                           AS PODate,
       EARLY_DL_DATE                     AS ExpectedDeliveryDate,
       LATE_DL_DATE                      AS LateDeliveryDate,
       REC_ACT_DATE                      AS ReceivedDate,
       CLOSE_DATE                        AS CloseDate,
       REQ_LOCATION                      AS PurchaseLocation,
       VEN_ITEM                          AS VendorItemNbr,
       CLOSED_FL                         AS ClosedFlag,
       CXL_QTY                           AS QtyCancelled,
       QUANTITY * ENT_UNIT_CST           AS POAmt,
       INVOICE_AMT                       AS InvoiceAmt,
       ITEM_TYPE                         AS POItemType,
       CASE
         WHEN ITEM_TYPE = 'S' THEN 0
         ELSE
           CASE
             WHEN REC_QTY = 0 THEN 0
             ELSE INVOICE_AMT - ( REC_QTY * ENT_UNIT_CST )
           END
       END                               AS PPV,
       1                                 AS POLine
INTO #tmpPOStatus
FROM   #tmpPOLines a
       LEFT JOIN #tmpMMDist b
              ON a.PO_NUMBER = b.PO_NUMBER
                 AND a.LINE_NBR = b.LINE_NBR 
		LEFT JOIN BUYER c
		ON a.BUYER_CODE = c.BUYER_CODE
		LEFT JOIN APVENMAST d ON a.VENDOR = d.VENDOR

--#tmpPOs

SELECT *,
CASE WHEN ClosedFlag = 'Y' THEN 'Closed' ELSE
	CASE WHEN QtyReceived + QtyCancelled = QtyOrdered THEN 'Closed' ELSE 'Open' END
	END 																as POStatus,
CASE WHEN POItemType = 'S' THEN 'N/A' ELSE
	CASE WHEN Dateadd(day, 3, ExpectedDeliveryDate) <= GETDATE() AND (QtyReceived+QtyCancelled < QtyOrdered) THEN 'Late' ELSE
		CASE WHEN Dateadd(day, 3, ExpectedDeliveryDate) > GETDATE() THEN 'In-Progress' ELSE
			CASE WHEN ReceivedDate <= Dateadd(day, 3, ExpectedDeliveryDate) AND (QtyReceived + QtyCancelled) = QtyOrdered THEN 'On-Time' ELSE 'Late' END
		END	
	
	END

END as PODeliveryStatus
INTO #tmpPOs
FROM #tmpPOStatus


/*************************		CREATE Sourcing		****************************/

SELECT *,
       CASE
         WHEN PODeliveryStatus = 'In-Progress' THEN 1
         ELSE 0
       END AS InProgress,
       CASE
         WHEN PODeliveryStatus = 'On-Time' THEN 1
         ELSE 0
       END AS OnTime,
       CASE
         WHEN PODeliveryStatus = 'Late' THEN 1
         ELSE 0
       END AS Late
INTO   tableau.Sourcing
FROM   #tmpPOs

/***********************		DROP Temp Tables	**************************/

DROP TABLE #tmpPOLines
DROP TABLE #tmpMMDIST
DROP TABLE #tmpPOStatus
DROP TABLE #tmpPOs

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Sourcing'
GO



/*******************************************************************************


			Contracts


*******************************************************************************/


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Contracts')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Contracts
GO

CREATE PROCEDURE tb_Contracts

AS

BEGIN TRY
    DROP TABLE tableau.Contracts
END TRY

BEGIN CATCH
END CATCH

SELECT Date,
       VEN_AGRMT_REF AS ContractID,
       AGMT_TYPE     AS ContractType,
       a.VENDOR        AS VendorNumber,
	   b.VENDOR_VNAME	AS VendorName,
       a.ITEM          AS ItemNumber,
	   c.DESCRIPTION	AS ItemDescription,
       VEN_ITEM      AS VendorItemNumber,
       CURR_NET_CST  AS CurrentCost,
       UOM,
       UOM_MULT      AS UOMMult,
       PRIORITY      AS Priority,
       HOLD_FLAG     AS HoldFlag,
       EFFECTIVE_DT  AS EffectiveDate,
       EXPIRE_DT     AS ExpireDate
INTO   tableau.Contracts
FROM   bluebin.DimDate
       LEFT JOIN POVAGRMTLN a
              ON EXPIRE_DT = Date 
		LEFT JOIN APVENMAST b ON a.VENDOR = b.VENDOR
		LEFT JOIN ITEMMAST c ON a.ITEM = c.ITEM

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Contracts'
GO



/***********************************************************************

		Update Bin Status

***********************************************************************/


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_UpdateBinStatus')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_UpdateBinStatus
GO

CREATE PROCEDURE	etl_UpdateBinStatus

AS

UPDATE bluebin.DimBin
SET    DimBin.BinCurrentStatus = DimBinStatus.BinStatus
FROM   bluebin.DimBin
       INNER JOIN bluebin.FactBinSnapshot
               ON DimBin.BinKey = FactBinSnapshot.BinKey
       INNER JOIN bluebin.DimBinStatus
               ON FactBinSnapshot.BinStatusKey = DimBinStatus.BinStatusKey
WHERE  FactBinSnapshot.BinSnapshotDate = Cast(CONVERT(VARCHAR, Dateadd(DAY, -1, Getdate()), 101) AS DATETIME)

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Update Bin Status'
GO

/******************************************************************************

			Refresh Dashboard Data

******************************************************************************/

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_RefreshDashboardData')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_RefreshDashboardData
GO

CREATE PROCEDURE	etl_RefreshDashboardData

AS

DECLARE 
	@ProcessID int,
	@RowCount int,
	@StepName varchar(50),
	@StepMin	int,
	@StepMax	int,
	@Step	int,
	@StepProc varchar(255),
	@StepTable nvarchar(255),
	@SQL nvarchar(max)


-- Initialize etl.JobHeader and insert row for current run

SET @ProcessID = (SELECT MAX(CASE WHEN ProcessID IS NULL THEN 0 ELSE ProcessID END) + 1 FROM etl.JobHeader);

INSERT INTO [etl].[JobHeader]
           ([ProcessID]
           ,[StartTime])
     VALUES
           (@ProcessID, GETDATE())

-- Loop through Job Steps table and execute accordingly

SET @StepMin = (SELECT MIN(StepNumber) FROM etl.JobSteps)
SET @StepMax = (SELECT MAX(StepNumber) FROM etl.JobSteps)
SET @Step = @StepMin

WHILE @Step <= @StepMax

BEGIN

SET @StepName = (SELECT StepName FROM etl.JobSteps WHERE StepNumber = @Step)
SET @StepProc = (SELECT StepProcedure FROM etl.JobSteps WHERE StepNumber = @Step)
SET @StepTable = (SELECT StepTable FROM etl.JobSteps WHERE StepNumber = @Step)


INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

BEGIN TRY

EXEC ('EXEC ' + @StepProc)

SET @SQL = 'SELECT @RowCount=COUNT(*) FROM ' + @StepTable
EXECUTE sp_executesql @SQL, N'@RowCount int OUTPUT', @RowCount = @RowCount OUTPUT


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
	  ,[Message] = ERROR_MESSAGE()
 WHERE ProcessID = @ProcessID AND StepName = @StepName
 
  UPDATE [etl].[JobHeader]
   SET [EndTime] = GETDATE()
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID


END TRY

BEGIN CATCH

UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
	  ,[Message] = ERROR_MESSAGE()
 WHERE ProcessID = @ProcessID AND StepName = @StepName
 
UPDATE [etl].[JobHeader]
   SET [EndTime] = GETDATE()
      ,[Result] = 'Failure (' + @StepName + ')'
 WHERE ProcessID = @ProcessID


END CATCH

SET @Step = @Step + 1

END

GO

/************************************************************

			DimWarehouseItem

************************************************************/


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'etl_DimWarehouseItem')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  etl_DimWarehouseItem
GO

CREATE PROCEDURE	etl_DimWarehouseItem

AS

/********************************		DROP DimWarehouseItem		**********************************/

BEGIN TRY
    DROP TABLE bluebin.DimWarehouseItem
END TRY

BEGIN CATCH
END CATCH

SELECT 
		d.LocationID,
		d.LocationName,
		b.ItemKey,
       b.ItemID,
       b.ItemDescription,
       b.ItemClinicalDescription,
       b.ItemManufacturer,
       b.ItemManufacturerNumber,
       b.ItemVendor,
       b.ItemVendorNumber,
       a.PREFER_BIN    AS StockLocation,
       a.SOH_QTY       AS SOHQty,
       a.MAX_ORDER     AS ReorderQty,
       a.REORDER_POINT AS ReorderPoint,
	   a.LAST_ISS_COST	AS UnitCost,
       b.StockUOM,
       b.BuyUOM,
       b.PackageString
INTO   bluebin.DimWarehouseItem
FROM   ITEMLOC a
       INNER JOIN bluebin.DimItem b
               ON a.ITEM = b.ItemID
       INNER JOIN ICCATEGORY c
               ON a.COMPANY = c.COMPANY
                  AND a.LOCATION = c.LOCATION
                  AND a.GL_CATEGORY = c.GL_CATEGORY
		INNER JOIN bluebin.DimLocation d
		ON a.LOCATION = d.LocationID
		INNER JOIN ICLOCATION e
		ON a.COMPANY = e.COMPANY
		AND a.LOCATION = e.LOCATION
WHERE e.LOCATION_TYPE <> 'P'
 
GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Warehouse Item'

Print 'ETL Sprocs updated'
GO
--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Contracts')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Contracts
GO

CREATE PROCEDURE tb_Contracts

AS

BEGIN TRY
    DROP TABLE tableau.Contracts
END TRY

BEGIN CATCH
END CATCH

SELECT Date,
       VEN_AGRMT_REF AS ContractID,
       AGMT_TYPE     AS ContractType,
       a.VENDOR        AS VendorNumber,
	   b.VENDOR_VNAME	AS VendorName,
       a.ITEM          AS ItemNumber,
	   c.DESCRIPTION	AS ItemDescription,
       VEN_ITEM      AS VendorItemNumber,
       CURR_NET_CST  AS CurrentCost,
       UOM,
       UOM_MULT      AS UOMMult,
       PRIORITY      AS Priority,
       HOLD_FLAG     AS HoldFlag,
       EFFECTIVE_DT  AS EffectiveDate,
       EXPIRE_DT     AS ExpireDate
INTO   tableau.Contracts
FROM   bluebin.DimDate
       LEFT JOIN POVAGRMTLN a
              ON EXPIRE_DT = Date 
		LEFT JOIN APVENMAST b ON a.VENDOR = b.VENDOR
		LEFT JOIN ITEMMAST c ON a.ITEM = c.ITEM

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Contracts'

GO

grant exec on tb_Contracts to public
GO

--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_CostVariance') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_CostVariance
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_CostVariance

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON



SELECT f.ITEM,
       f.DESCRIPTION,
       Min(e.PO_DATE)   AS EFF_DATE,
       Max(e.PO_DATE)   AS EXP_DATE,
       Sum(c.QUANTITY)  AS QUANTITY,
       c.ENT_BUY_UOM    AS UOM,
       (d.MATCH_UNIT_CST/c.EBUY_UOM_MULT) AS UNIT_COST,
       h.ISS_ACCOUNT
INTO   #PriceHist
FROM   POLINE c
       INNER JOIN MAINVDTL d
               ON c.COMPANY = d.COMPANY
                  AND c.PO_NUMBER = d.PO_NUMBER
                  AND c.LINE_NBR = d.LINE_NBR
                  AND c.PO_CODE = d.PO_CODE
       INNER JOIN PURCHORDER e
               ON c.PO_NUMBER = e.PO_NUMBER
       INNER JOIN ITEMMAST f
               ON c.ITEM = f.ITEM
       LEFT JOIN (SELECT *
                  FROM   ITEMLOC
                  WHERE  LOCATION in (Select ConfigValue from bluebin.Config where ConfigName = 'LOCATION')) g
              ON c.ITEM = g.ITEM
       LEFT JOIN ICCATEGORY h
              ON g.COMPANY = h.COMPANY
                 AND g.LOCATION = h.LOCATION
                 AND g.GL_CATEGORY = h.GL_CATEGORY
WHERE  c.ITEM_TYPE IN ( 'I', 'N' )
       AND CXL_QTY = 0
       AND Year(PO_DATE) >= Year(Getdate()) - 1
GROUP  BY f.ITEM,
          f.DESCRIPTION,
          c.ENT_BUY_UOM,
		  c.EBUY_UOM_MULT,
          d.MATCH_UNIT_CST,
          h.ISS_ACCOUNT

SELECT Row_number()
         OVER(
           PARTITION BY ITEM, UOM
           ORDER BY QUANTITY DESC) AS PriceSeq,
       ITEM,
       DESCRIPTION,
       EFF_DATE,
	   EXP_DATE,
       QUANTITY,
       UOM,
       UNIT_COST,
	   ISS_ACCOUNT
INTO   #PriceSeq
FROM   #PriceHist

SELECT *
INTO   #ModePrice
FROM   #PriceSeq
WHERE  PriceSeq = 1

SELECT c.PO_NUMBER,
       c.LINE_NBR,
       c.ITEM,
       c.DESCRIPTION,
       c.ITEM_TYPE,
       e.PO_DATE,
       c.QUANTITY,
       c.ENT_BUY_UOM,
       (c.ENT_UNIT_CST/c.EBUY_UOM_MULT)	as ENT_UNIT_CST,
       (d.MATCH_UNIT_CST/c.EBUY_UOM_MULT) as MATCH_UNIT_CST
INTO   #POHistory
FROM   POLINE c
       INNER JOIN MAINVDTL d
               ON c.COMPANY = d.COMPANY
                  AND c.PO_NUMBER = d.PO_NUMBER
                  AND c.LINE_NBR = d.LINE_NBR
                  AND c.PO_CODE = d.PO_CODE
       INNER JOIN PURCHORDER e
               ON c.PO_NUMBER = e.PO_NUMBER
       INNER JOIN ITEMMAST f
               ON c.ITEM = f.ITEM
WHERE  c.ITEM_TYPE IN ( 'I', 'N' )
       AND CXL_QTY = 0
       AND Year(PO_DATE) >= Year(Getdate()) - 1

SELECT a.*,
       b.UNIT_COST                                AS ModePrice,
       a.QUANTITY * ( a.UNIT_COST - b.UNIT_COST ) AS Variance
FROM   #PriceSeq a
       INNER JOIN #ModePrice b
               ON a.ITEM = b.ITEM
                  AND a.UOM = b.UOM
       LEFT JOIN #POHistory c
              ON a.ITEM = c.ITEM
                 AND a.UOM = c.ENT_BUY_UOM
                 AND a.UNIT_COST = c.MATCH_UNIT_CST
                 AND a.EFF_DATE <= c.PO_DATE
                 AND a.EXP_DATE >= c.PO_DATE 
ORDER by 2, 1
END
GO
grant exec on tb_CostVariance to public
GO
--DROP TABLE #PriceHist
--DROP TABLE #PriceSeq
--DROP TABLE #ModePrice
--DROP TABLE #POHistory


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************
if exists (select * from dbo.sysobjects where id = object_id(N'tb_GLSpend') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_GLSpend
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_GLSpend

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT FISCAL_YEAR                                                                                                                                                                                                  AS FiscalYear,
       ACCT_PERIOD                                                                                                                                                                                                  AS AcctPeriod,
       a.ACCOUNT                                                                                                                                                                                                    AS Account,
       b.ACCOUNT_DESC                                                                                                                                                                                               AS AccountDesc,
       a.ACCT_UNIT                                                                                                                                                                                                  AS AcctUnit,
       c.DESCRIPTION                                                                                                                                                                                                AS AcctUnitName,
       Cast(CONVERT(VARCHAR, CASE WHEN ACCT_PERIOD <= 3 THEN ACCT_PERIOD + 9 ELSE ACCT_PERIOD - 3 END) + '/1/' + CONVERT(VARCHAR, CASE WHEN ACCT_PERIOD <=3 THEN FISCAL_YEAR - 1 ELSE FISCAL_YEAR END) AS DATETIME) AS Date,
       Sum(TRAN_AMOUNT)                                                                                                                                                                                             AS Amount
FROM   GLTRANS a
       INNER JOIN GLCHARTDTL b
               ON a.ACCOUNT = b.ACCOUNT
       INNER JOIN GLNAMES c
               ON a.ACCT_UNIT = c.ACCT_UNIT
                  AND a.COMPANY = c.COMPANY
WHERE  SUMRY_ACCT_ID = 70
GROUP  BY FISCAL_YEAR,
          ACCT_PERIOD,
          a.ACCOUNT,
          b.ACCOUNT_DESC,
          a.ACCT_UNIT,
          c.DESCRIPTION 
END
GO
grant exec on tb_GLSpend to public
GO





--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_ItemLocator') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_ItemLocator
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_ItemLocator

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT 
	a.ITEM as LawsonItemNumber,
	ISNULL(c.MANUF_NBR,'N/A') as ItemManufacturerNumber,
	ISNULL(b.ClinicalDescription,'*NEEDS*') as ClinicalDescription,
	a.LOCATION as LocationCode,
	a.NAME as LocationName,
	a.Cart,
	a.Row,
	a.Position
FROM 
(SELECT 
	ITEM,
	LOCATION,
	b.NAME,
	CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN LEFT(PREFER_BIN, 2) ELSE LEFT(PREFER_BIN, 1) END as Cart,
	CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING(PREFER_BIN, 3, 1) ELSE SUBSTRING(PREFER_BIN, 2,1) END as Row,
	CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING (PREFER_BIN,4,2) ELSE SUBSTRING(PREFER_BIN, 3,2) END as Position	
FROM ITEMLOC a INNER JOIN RQLOC b ON a.LOCATION = b.REQ_LOCATION 
WHERE LEFT(REQ_LOCATION, 2) IN (SELECT [ConfigValue] FROM   [bluebin].[Config] WHERE  [ConfigName] = 'REQ_LOCATION' AND Active = 1)) a
LEFT JOIN 
(SELECT 
	ITEM, 
	USER_FIELD3 as ClinicalDescription
FROM ITEMLOC 
WHERE LOCATION IN (SELECT [ConfigValue] FROM [bluebin].[Config] WHERE  [ConfigName] = 'LOCATION' AND Active = 1) AND LEN(LTRIM(USER_FIELD3)) > 0) b
ON a.ITEM = b.ITEM
left join ITEMMAST c on a.ITEM = c.ITEM



END
GO
grant exec on tb_ItemLocator to public
GO





--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Kanban')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Kanban
GO

CREATE PROCEDURE tb_Kanban

AS

BEGIN TRY
    DROP TABLE tableau.Kanban
END TRY

BEGIN CATCH
END CATCH


SELECT DimBin.BinKey,
       DimBin.LocationID,
       DimBin.ItemID,
       DimBin.BinSequence,
       DimBin.BinUOM,
       DimBin.BinQty,
	   DimBin.BinCurrentCost,
	   DimBin.BinGLAccount,
	   DimBin.BinConsignmentFlag,
       DimBin.BinLeadTime,
       DimBin.BinGoLiveDate,
	   DimBin.BinCurrentStatus,
       DimSnapshotDate.Date,       
	   FactScan.ScanHistseq,
       FactScan.ItemType,       
       FactScan.OrderNum,
       FactScan.LineNum,
       FactScan.OrderUOM,
       FactScan.OrderQty,
       FactScan.OrderDate,
       FactScan.OrderCloseDate,
       FactScan.PrevOrderDate,
       FactScan.PrevOrderCloseDate,
       FactScan.Scan,
       FactScan.HotScan,
       FactScan.StockOut,
       FactBinSnapshot.BinSnapshotDate,
       FactBinSnapshot.LastScannedDate,
       FactBinSnapshot.DaysSinceLastScan,
       FactBinSnapshot.ScanSinThreshold,
       FactBinSnapshot.HotScanSinThreshold,
       FactBinSnapshot.StockOutSinThreshold,
       FactBinSnapshot.StockOutsDaily,
	   FactBinSnapshot.TimeToFill,
	   FactBinSnapshot.BinVelocity,
       DimBinStatus.BinStatus,
       DimItem.ItemDescription,
	   DimItem.ItemClinicalDescription,
       DimItem.ItemManufacturer,
       DimItem.ItemManufacturerNumber,
       DimItem.ItemVendor,
       DimItem.ItemVendorNumber,
       DimLocation.LocationName,
       1 AS TotalBins
INTO   tableau.Kanban
FROM   bluebin.DimBin
       CROSS JOIN bluebin.DimSnapshotDate
       LEFT JOIN bluebin.FactScan
              ON Cast(OrderDate AS DATE) = Cast(Date AS DATE)
                 AND DimBin.BinKey = FactScan.BinKey
       LEFT JOIN bluebin.FactBinSnapshot
              ON Date = BinSnapshotDate
                 AND DimBin.BinKey = FactBinSnapshot.BinKey
       LEFT JOIN bluebin.DimItem
              ON DimBin.ItemID = DimItem.ItemID
       LEFT JOIN bluebin.DimLocation
              ON DimBin.LocationID = DimLocation.LocationID
			  AND DimBin.BinFacility = DimLocation.LocationFacility
       LEFT JOIN bluebin.DimBinStatus
              ON FactBinSnapshot.BinStatusKey = DimBinStatus.BinStatusKey
WHERE  Date >= DimBin.BinGoLiveDate 

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Kanban'

GO
grant exec on tb_Kanban to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_LineVolume') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_LineVolume
GO



CREATE PROCEDURE tb_LineVolume


AS
BEGIN
SET NOCOUNT ON


SELECT CREATION_DATE   AS Date,
       CASE
         WHEN LEFT(a.REQ_LOCATION, 2) IN (SELECT ConfigValue
                                          FROM   [bluebin].[Config]
                                          WHERE  ConfigName = 'REQ_LOCATION') THEN 'BlueBin'
         ELSE 'Non BlueBin'
       END             AS LineType,
       b.ISS_ACCT_UNIT AS AcctUnit,
       c.DESCRIPTION   AS AcctUnitName,
       a.REQ_LOCATION  AS Location,
       b.NAME          AS LocationName,
       1               AS LineCount
FROM   REQLINE a
       INNER JOIN RQLOC b
               ON a.COMPANY = b.COMPANY
                  AND a.REQ_LOCATION = b.REQ_LOCATION
       INNER JOIN GLNAMES c
               ON b.COMPANY = c.COMPANY
                  AND b.ISS_ACCT_UNIT = c.ACCT_UNIT 
END
GO
grant exec on tb_LineVolume to public
GO



--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_PickLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_PickLines
GO

CREATE PROCEDURE tb_PickLines
AS
BEGIN
SET NOCOUNT ON


SELECT Cast(IssueDate AS DATE) AS Date,
       Count(*)                AS PickLine
FROM   bluebin.FactIssue
GROUP  BY Cast(IssueDate AS DATE)


END
GO
grant exec on tb_PickLines to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_QCNDashboard') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_QCNDashboard
GO

--exec tb_QCNDashboard 
CREATE PROCEDURE tb_QCNDashboard

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
	q.[QCNID],
	q.[LocationID],
        dl.[LocationName],
		db.BinSequence,
	u.LastName + ', ' + u.FirstName  as RequesterUserName,
        u.[Login] as RequesterLogin,
    u.[Title] as RequesterTitleName,
    case when v.Login = 'None' then '' else v.LastName + ', ' + v.FirstName end as AssignedUserName,
        v.[Login] as AssignedLogin,
    v.[Title] as AssignedTitleName,
	qt.Name as QCNType,
q.[ItemID],
di.[ItemClinicalDescription],
db.[BinQty] as Par,
db.[BinUOM] as UOM,
di.[ItemManufacturer],
di.[ItemManufacturerNumber],
	q.[Details] as [DetailsText],
            case when q.[Details] ='' then 'No' else 'Yes' end Details,
	q.[Updates] as [UpdatesText],
            case when q.[Updates] ='' then 'No' else 'Yes' end Updates,
	case when qs.Status = 'Completed' then convert(int,(q.[DateCompleted] - q.[DateEntered]))
		else convert(int,(getdate() - q.[DateEntered])) end as DaysOpen,
            q.[DateEntered],
	q.[DateCompleted],
	qs.Status,
    case when db.BinCurrentStatus is null then 'N/A' else db.BinCurrentStatus end as BinStatus,
    q.[LastUpdated]
from [qcn].[QCN] q
left join [bluebin].[DimBin] db on q.LocationID = db.LocationID and rtrim(q.ItemID) = rtrim(db.ItemID)
left join [bluebin].[DimItem] di on rtrim(q.ItemID) = rtrim(di.ItemID)
        inner join [bluebin].[DimLocation] dl on q.LocationID = dl.LocationID and dl.BlueBinFlag = 1
inner join [bluebin].[BlueBinResource] u on q.RequesterUserID = u.BlueBinResourceID
left join [bluebin].[BlueBinResource] v on q.AssignedUserID = v.BlueBinResourceID
inner join [qcn].[QCNType] qt on q.QCNTypeID = qt.QCNTypeID
inner join [qcn].[QCNStatus] qs on q.QCNStatusID = qs.QCNStatusID

WHERE q.Active = 1 
            order by q.[DateEntered] asc--,convert(int,(getdate() - q.[DateEntered])) desc

END
GO
grant exec on tb_QCNDashboard to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Sourcing')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Sourcing
GO

CREATE PROCEDURE	tb_Sourcing

AS

/********************************		DROP Sourcing		**********************************/

BEGIN TRY
    DROP TABLE tableau.Sourcing
END TRY

BEGIN CATCH
END CATCH

/**********************************		CREATE Temp Tables		***************************/

-- #tmpPOLines

SELECT a.COMPANY,
       a.PO_NUMBER,
       a.PO_RELEASE,
       a.PO_CODE,
       a.LINE_NBR,
       a.ITEM,
       a.ITEM_TYPE,
       a.DESCRIPTION AS PO_DESCRIPTION,
       a.QUANTITY,
       a.REC_QTY,
       a.AGREEMENT_REF,
       a.ENT_UNIT_CST,
       a.ENT_BUY_UOM,
       a.EBUY_UOM_MULT,
       b.PO_DATE,
       a.EARLY_DL_DATE,
       a.LATE_DL_DATE,
       a.REC_ACT_DATE,
       a.CLOSE_DATE,
       a.LOCATION,
       a.BUYER_CODE,
       a.VENDOR,
       d.REQ_LOCATION,
       a.VEN_ITEM,
       a.CLOSED_FL,
       a.CXL_QTY,
       c.INVOICE_AMT
INTO   #tmpPOLines
FROM   POLINE a
       LEFT JOIN PURCHORDER b
              ON a.PO_NUMBER = b.PO_NUMBER
                 AND a.COMPANY = b.COMPANY
                 AND a.PO_CODE = b.PO_CODE
       LEFT JOIN (SELECT PO_NUMBER,
                         LINE_NBR,
                         Sum(TOT_DIST_AMT) AS INVOICE_AMT
                  FROM   MAINVDTL
                  GROUP  BY PO_NUMBER,
                            LINE_NBR) c
              ON a.PO_NUMBER = c.PO_NUMBER
                 AND a.LINE_NBR = c.LINE_NBR
       LEFT JOIN POLINESRC d
              ON a.COMPANY = d.COMPANY
                 AND a.PO_NUMBER = d.PO_NUMBER
                 AND a.LINE_NBR = d.LINE_NBR
                 AND a.PO_CODE = d.PO_CODE
WHERE  b.PO_DATE >= '1/1/2014'
       AND a.CXL_QTY = 0; 

--#tmpMMDIST
SELECT DOC_NUMBER    AS PO_NUMBER,
       LINE_NBR,
       a.ACCT_UNIT,
       b.DESCRIPTION AS ACCT_UNIT_NAME
INTO #tmpMMDIST
FROM   MMDIST a
       LEFT JOIN GLNAMES b
              ON a.COMPANY = b.COMPANY
                 AND a.ACCT_UNIT = b.ACCT_UNIT
WHERE  SYSTEM_CD = 'PO'
       AND DOC_TYPE = 'PT'
       AND DOC_NUMBER IN (SELECT PO_NUMBER
                          FROM   PURCHORDER
                          WHERE  PO_DATE >= '1/1/2014'); 

--#tmpPOStatus
SELECT Row_number()
         OVER(
           ORDER BY a.PO_NUMBER, a.LINE_NBR) AS POKey,
       COMPANY                           AS Company,
       a.PO_NUMBER                         AS PONumber,
       a.LINE_NBR                          AS POLineNumber,
       PO_RELEASE                        AS PORelease,
       PO_CODE                           AS POCode,
       ITEM                              AS ItemNumber,
       a.VENDOR                            AS VendorCode,
	   d.VENDOR_VNAME					AS VendorName,
       a.BUYER_CODE                        AS Buyer,
	   c.NAME							AS BuyerName,
       LOCATION                          AS ShipLocation,
       ACCT_UNIT                         AS AcctUnit,
       ACCT_UNIT_NAME                    AS AcctUnitName,
       PO_DESCRIPTION                    AS PODescr,
       QUANTITY                          AS QtyOrdered,
       REC_QTY                           AS QtyReceived,
       AGREEMENT_REF                     AS AgrmtRef,
       ENT_UNIT_CST                      AS UnitCost,
       ENT_BUY_UOM                       AS BuyUOM,
       EBUY_UOM_MULT                     AS BuyUOMMult,
       PO_DATE                           AS PODate,
       EARLY_DL_DATE                     AS ExpectedDeliveryDate,
       LATE_DL_DATE                      AS LateDeliveryDate,
       REC_ACT_DATE                      AS ReceivedDate,
       CLOSE_DATE                        AS CloseDate,
       REQ_LOCATION                      AS PurchaseLocation,
       VEN_ITEM                          AS VendorItemNbr,
       CLOSED_FL                         AS ClosedFlag,
       CXL_QTY                           AS QtyCancelled,
       QUANTITY * ENT_UNIT_CST           AS POAmt,
       INVOICE_AMT                       AS InvoiceAmt,
       ITEM_TYPE                         AS POItemType,
       CASE
         WHEN ITEM_TYPE = 'S' THEN 0
         ELSE
           CASE
             WHEN REC_QTY = 0 THEN 0
             ELSE INVOICE_AMT - ( REC_QTY * ENT_UNIT_CST )
           END
       END                               AS PPV,
       1                                 AS POLine
INTO #tmpPOStatus
FROM   #tmpPOLines a
       LEFT JOIN #tmpMMDist b
              ON a.PO_NUMBER = b.PO_NUMBER
                 AND a.LINE_NBR = b.LINE_NBR 
		LEFT JOIN BUYER c
		ON a.BUYER_CODE = c.BUYER_CODE
		LEFT JOIN APVENMAST d ON a.VENDOR = d.VENDOR

--#tmpPOs

SELECT *,
CASE WHEN ClosedFlag = 'Y' THEN 'Closed' ELSE
	CASE WHEN QtyReceived + QtyCancelled = QtyOrdered THEN 'Closed' ELSE 'Open' END
	END 																as POStatus,
CASE WHEN POItemType = 'S' THEN 'N/A' ELSE
	CASE WHEN Dateadd(day, 3, ExpectedDeliveryDate) <= GETDATE() AND (QtyReceived+QtyCancelled < QtyOrdered) THEN 'Late' ELSE
		CASE WHEN Dateadd(day, 3, ExpectedDeliveryDate) > GETDATE() THEN 'In-Progress' ELSE
			CASE WHEN ReceivedDate <= Dateadd(day, 3, ExpectedDeliveryDate) AND (QtyReceived + QtyCancelled) = QtyOrdered THEN 'On-Time' ELSE 'Late' END
		END	
	
	END

END as PODeliveryStatus
INTO #tmpPOs
FROM #tmpPOStatus


/*************************		CREATE Sourcing		****************************/

SELECT *,
       CASE
         WHEN PODeliveryStatus = 'In-Progress' THEN 1
         ELSE 0
       END AS InProgress,
       CASE
         WHEN PODeliveryStatus = 'On-Time' THEN 1
         ELSE 0
       END AS OnTime,
       CASE
         WHEN PODeliveryStatus = 'Late' THEN 1
         ELSE 0
       END AS Late
INTO   tableau.Sourcing
FROM   #tmpPOs

/***********************		DROP Temp Tables	**************************/

DROP TABLE #tmpPOLines
DROP TABLE #tmpMMDIST
DROP TABLE #tmpPOStatus
DROP TABLE #tmpPOs

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Sourcing'

GO
grant exec on tb_Sourcing to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_StatCalls') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_StatCalls
GO

CREATE PROCEDURE tb_StatCalls
AS
BEGIN
SET NOCOUNT ON


SELECT
    TRANS_DATE as Date,
    COUNT(*) as StatCalls,
    LTRIM(RTRIM(c.ACCT_UNIT)) + ' - '+ c.DESCRIPTION       as Department
FROM
    ICTRANS a 
INNER JOIN
RQLOC b ON a.FROM_TO_CMPY = b.COMPANY AND a.FROM_TO_LOC = b.REQ_LOCATION
INNER JOIN
GLNAMES c ON b.COMPANY = c.COMPANY AND b.ISS_ACCT_UNIT = c.ACCT_UNIT
WHERE SYSTEM_CD = 'IC' AND DOC_TYPE = 'IS'
GROUP BY
    TRANS_DATE,
    c.ACCT_UNIT,
    c.DESCRIPTION


END
GO
grant exec on tb_StatCalls to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_WarehouseSize') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_WarehouseSize
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_WarehouseSize

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT 
       a.LocationID,
	   a.LocationName,
	   a.ItemID,
       a.ItemDescription,
       a.ItemClinicalDescription,
       a.ItemManufacturer,
       a.ItemManufacturerNumber,
       a.StockLocation,
       a.SOHQty,
       a.ReorderQty,
       a.ReorderPoint,
       a.UnitCost,
	   c.LastPODate,
	   a.StockUOM as UOM,
       Sum(CASE
             WHEN TRANS_DATE >= Dateadd(YEAR, Datediff(YEAR, 0, Dateadd(YEAR, -1, Getdate())), 0)
                  AND TRANS_DATE <= Dateadd(YEAR, -1, Getdate()) THEN b.QUANTITY * -1
             ELSE 0
           END) / Month(Getdate()) AS LYYTDIssueQty,
       Sum(CASE
             WHEN TRANS_DATE >= Dateadd(YEAR, Datediff(YEAR, 0, Getdate()), 0) THEN b.QUANTITY * -1
             ELSE 0
           END) / Month(Getdate()) AS CYYTDIssueQty
FROM   bluebin.DimWarehouseItem a
       INNER JOIN ICTRANS b
               ON a.ItemID = b.ITEM
			   INNER JOIN bluebin.DimItem c
			   ON a.ItemKey = c.ItemKey
WHERE  b.DOC_TYPE = 'IS'
       AND Year(TRANS_DATE) >= Year(Getdate()) - 1
GROUP  BY a.LocationID,
			a.LocationName,
			a.ItemID,
          a.ItemDescription,
          a.ItemClinicalDescription,
          a.ItemManufacturer,
          a.ItemManufacturerNumber,
          a.StockLocation,
          a.SOHQty,
          a.ReorderQty,
          a.ReorderPoint,
          a.UnitCost,
		  c.LastPODate,
		  a.StockUOM 

END
GO
grant exec on tb_WarehouseSize to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************


if exists (select * from dbo.sysobjects where id = object_id(N'tb_WarehouseSnapshot') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_WarehouseSnapshot
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_WarehouseSnapshot

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT 
	SnapshotDate,
	SUM(SOH * UnitCost) as DollarsOnHand,
	LocationID,
	LocationName
FROM   bluebin.FactWarehouseSnapshot a
INNER JOIN bluebin.DimLocation b
ON a.LocationKey = b.LocationKey
GROUP BY
	SnapshotDate,
	LocationID,
	LocationName
END
GO
grant exec on tb_WarehouseSnapshot to public
GO


--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Training')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Training
GO

CREATE PROCEDURE tb_Training

AS

SELECT 
bbr.LastName + ', ' + bbr.FirstName as Name
	  ,bbt.[Form3000] as [3000]
      ,bbt.[Form3001] as [3001]
      ,bbt.[Form3002] as [3002]
      ,bbt.[Form3003] as [3003]
      ,bbt.[Form3004] as [3004]
      ,bbt.[Form3005] as [3005]
      ,bbt.[Form3006] as [3006]
      ,bbt.[Form3007] as [3007]
      ,bbt.[Form3008] as [3008]
      ,bbt.[Form3009] as [3009]
      ,bbt.[Form3010] as [3010]
      ,left(bbt.[LastUpdated],11) as LastUpdated
FROM   bluebin.BlueBinTraining bbt
inner join bluebin.BlueBinResource bbr on bbt.BlueBinResourceID = bbr.BlueBinResourceID

ORDER BY 
bbr.LastName + ', ' + bbr.FirstName

GO

grant exec on tb_Training to public
GO

--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_GembaDashboard') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_GembaDashboard
GO

--exec tb_GembaDashboard 
CREATE PROCEDURE tb_GembaDashboard

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
	g.[GembaAuditNodeID],
	dl.[LocationID],
	g.LocationID as AuditLocationID,
        dl.[LocationName],
			dl.BlueBinFlag,
	u.LastName + ', ' + u.FirstName  as Auditer,
    u.[UserLogin] as Login,
	bbr.RoleName,
	g.PS_TotalScore,
	g.RS_TotalScore,
	g.SS_TotalScore,
	g.NIS_TotalScore,
	g.TotalScore,
	case when TotalScore < 90 then 1 else 0 end as ScoreUnder,
	(select count(*) from bluebin.DimLocation where BlueBinFlag = 1) as LocationCount,
    g.[Date],
	g2.[MaxDate] as LastAuditDate,
	case 
		when g.[Date] is null then 365
		else convert(int,(getdate() - g2.[MaxDate])) end as LastAudit,
    g.[LastUpdated]
from  [bluebin].[DimLocation] dl
		left join [gemba].[GembaAuditNode] g on dl.LocationID = g.LocationID
		left join (select Max([Date]) as MaxDate,LocationID from [gemba].[GembaAuditNode] group by LocationID) g2 on dl.LocationID = g2.LocationID and g.[Date] = g2.MaxDate
        --left join [bluebin].[DimLocation] dl on g.LocationID = dl.LocationID and dl.BlueBinFlag = 1
		left join [bluebin].[BlueBinUser] u on g.AuditerUserID = u.BlueBinUserID
		left join bluebin.BlueBinRoles bbr on u.RoleID = bbr.RoleID

WHERE dl.BlueBinFlag = 1 
            order by dl.LocationID,[Date] asc

END
GO
grant exec on tb_GembaDashboard to public
GO




--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************
if exists (select * from dbo.sysobjects where id = object_id(N'tb_KanbansAdjusted') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_KanbansAdjusted
GO

--exec tb_KanbansAdjusted

CREATE PROCEDURE [dbo].[tb_KanbansAdjusted] 
	
AS

BEGIN

with C as
(select 
[Date] 
,BinKey
,LocationID
,ItemID
,BinQty as YestBinQty
,BinUOM as YesBinUOM
--,OrderQty as YestOrderQty
--,OrderUOM as YestOrderUOM
from tableau.Kanban 
where [Date] >= getdate() -8 )
,
D as
(
select 
DATEPART(WEEK,a.[Date]) as [Week]
,a.[Date]
,C.[Date] as Yesterday
,a.BinKey
,a.LocationID
,dl.LocationName
,a.ItemID
,di.ItemDescription
,convert(int,a.BinQty) as BinQty
,a.BinUOM
,convert(int,C.YestBinQty) as YestBinQty
--,C.YesBinUOM
,a.OrderQty
,a.OrderUOM
--,C.YestOrderQty
--,C.YestOrderUOM
,convert(int,a.BinQty) - convert(int,C.YestBinQty) as BinChange
,a.OrderQty - convert(int,C.YestBinQty) as BinOrderChange
,a.BinCurrentStatus

from tableau.Kanban a
left join C on a.BinKey = C.BinKey and a.[Date]-1 = C.[Date]
left join bluebin.DimItem di on a.ItemID = di.ItemID
left join bluebin.DimLocation dl on a.LocationID = dl.LocationID
where a.[Date] >= getdate() -7
)
select 
[Week]
,[Date],Yesterday
,BinKey
,LocationID
,LocationName
,ItemID
,ItemDescription
,BinQty
,YestBinQty
,BinUOM
,OrderQty
,OrderUOM
, case when BinChange != 0 then 1 else BinChange end as BinChange
, case when BinOrderChange != 0 then 1 else BinOrderChange end as BinOrderChange
,BinCurrentStatus 
from D 
where 
(BinOrderChange != 0 or BinChange != 0)
	and BinUOM = OrderUOM 
		and OrderQty is not null
			and [Week] = datepart(WEEK,getdate())
order by LocationName,ItemDescription,[Date]
END
GO
grant exec on tb_KanbansAdjusted to public
GO
--*********************************************************************************************
--Tableau Sproc  These load data into the datasources for Tableau
--*********************************************************************************************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_JobStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_JobStatus
GO

--exec tb_JobStatus 'Demo'

CREATE PROCEDURE [dbo].[tb_JobStatus] 
@db nvarchar(20)
	
AS

BEGIN

declare @SQL nvarchar(max)


SET @SQL = 

'Use [' + @db + ']

Select ''' + @db + ''' as [Database]
select ''' + @db + ''' as [Database],a.BinSnapshotDate,Count(*) from tableau.Kanban a
inner join (select max(BinSnapshotDate) as MaxDate from tableau.Kanban) as b on a.BinSnapshotDate = b.MaxDate
group by a.BinSnapshotDate

select ''' + @db + ''' as [Database],ProcessID,StartTime,EndTime,Duration,Result from etl.JobHeader where StartTime > getdate() -.5 order by StartTime desc
select ''' + @db + ''' as [Database],ProcessID,StepName,StartTime,EndTime,Duration,[RowCount],Result,Message from etl.JobDetails where StartTime > getdate() -.5 order by StartTime desc
select ''' + @db + ''' as [Database],StepNumber,StepName,StepTable,ActiveFlag,LastModifiedDate from etl.JobSteps  order by ActiveFlag,StepNumber
'


EXEC (@SQL)

END
GO
grant exec on tb_JobStatus to public
GO





Print 'Tableau (tb) sprocs updated'
GO