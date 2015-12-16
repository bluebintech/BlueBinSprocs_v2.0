

/****** Object:  StoredProcedure [dbo].[exec sp_BlueBinRefreshDemo]    Script Date: 12/7/2015 2:31:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


if exists (select * from dbo.sysobjects where id = object_id(N'sp_BlueBinRefreshDemo') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_BlueBinRefreshDemo
GO

CREATE PROCEDURE [dbo].[sp_BlueBinRefreshDemo] 
	
AS

DECLARE 
	@ProcessID int,
	@RowCount int,
	@StepName varchar(50),
	@PrimaryLocation varchar(50);

/*   SET BUSINESS RULES  */

SET
	@PrimaryLocation = 'STORE';



SET @ProcessID = (SELECT MAX(CASE WHEN ProcessID IS NULL THEN 0 ELSE ProcessID END) + 1 FROM etl.JobHeader);

INSERT INTO [etl].[JobHeader]
           ([ProcessID]
           ,[StartTime])
     VALUES
           (@ProcessID, GETDATE())



-- All tables in the BlueBin Datamart are dropped and created using SELECT..INTO statements.
-- Tables must be created in order in order to preserve referential dependencies.

/************************************************

TABLE ORDER:
	1 - bluebin.DimItem
	2 - bluebin.DimLocation
	3 - bluebin.DimDate
	4 - bluebin.DimBinStatus
	5 - bluebin.DimBin
	6 - bluebin.FactScan
	7 - bluebin.FactBinSnapshot
	8 - tableau.SCMDashboard
	9 - tableau.POs (Sourcing Analytics)


************************************************/


--		1 - bluebin.DimItem
SET @StepName = 'DimItem'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')




BEGIN
	SET NOCOUNT ON;

BEGIN Try
    DROP TABLE bluebin.DimItem
END Try

BEGIN Catch
END Catch

BEGIN TRY
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

DROP TABLE #ClinicalDescriptions

DROP TABLE #LastPO

DROP TABLE #StockLocations

DROP TABLE #ItemContract 

END TRY

BEGIN CATCH
SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimItem)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName
END CATCH
END

SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimItem)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName






--		2 - bluebin.DimLocation

SET @StepName = 'DimLocation'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DROP TABLE bluebin.DimLocation
	END TRY

	BEGIN CATCH
	END CATCH

	BEGIN TRY
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

	END TRY

	BEGIN CATCH
	SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimLocation)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName
	
	END CATCH

END

SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimLocation)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName


--		3 - DimDate
SET @StepName = 'Date Dimensions'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')


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

/**********************************************************************************/

CREATE TABLE	bluebin.DimDate
	(	[DateKey] INT primary key, 
		[Date] DATETIME
	)


/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = DATEADD(yy,-2,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)) --Starting value of Date Range
DECLARE @EndDate DATETIME = DATEADD(yy, 1, DATEADD(yy, DATEDIFF(yy,0,getdate()) + 1, -1)) --End Value of Date Range



--Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate


/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 


/* Populate Your Dimension Table with values*/
	
	INSERT INTO bluebin.DimDate
	SELECT
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

CREATE TABLE	bluebin.DimSnapshotDate
	(	[DateKey] INT primary key, 
		[Date] DATETIME
	)


/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

SET @StartDate  = DATEADD(dd,-90,DATEADD(dd, DATEDIFF(dd,0,getdate()), 0)) --Starting value of Date Range
SET @EndDate  = DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) --End Value of Date Range



--Extract and assign various parts of Values from Current Date to Variable

SET @CurrentDate = @StartDate


/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 


/* Populate Your Dimension Table with values*/
	
	INSERT INTO bluebin.DimSnapshotDate
	SELECT
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END


SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimDate)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName



--		4 - DimBinStatus
SET @StepName = 'DimBinStatus'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

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


SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimBinStatus)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName




 --		5 - DimBin

 SET @StepName = 'DimBin'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')



BEGIN TRY
    DROP TABLE bluebin.DimBin
END TRY

BEGIN CATCH
END CATCH

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
WHERE  ITEMLOC.LOCATION = 'STORE'

SELECT ITEM,
       LAST_ISS_COST
INTO   #ItemStore
FROM   ITEMLOC
WHERE  LOCATION = 'STORE'

BEGIN TRY
    SELECT Row_number()
             OVER(
               ORDER BY ITEMLOC.LOCATION, ITEMLOC.ITEM)                                               AS BinKey,
			   ITEMLOC.COMPANY																			AS BinFacility,
           ITEMLOC.ITEM                                                                               AS ItemID,
           ITEMLOC.LOCATION                                                                           AS LocationID,
           PREFER_BIN                                                                                 AS BinSequence,
           CASE
             WHEN PREFER_BIN LIKE 'CARD%' THEN 'WALL'
             ELSE LEFT(PREFER_BIN, 1)
           END                                                                                        AS BinCart,
           CASE
             WHEN PREFER_BIN LIKE 'CARD%' THEN 'WALL'
             ELSE Substring(PREFER_BIN, 2, 1)
           END                                                                                        AS BinRow,
           CASE
             WHEN PREFER_BIN LIKE 'CARD%' THEN Cast('0' + RIGHT(PREFER_BIN, 2) AS VARCHAR)
             ELSE Substring(PREFER_BIN, 3, 2)
           END                                                                                        AS BinPosition,
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

DROP TABLE #BinAddDates
DROP TABLE #ItemReqs
DROP TABLE #ItemOrders
DROP TABLE #ItemAccounts
DROP TABLE #ItemStore

END TRY

BEGIN CATCH
SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimBin)
UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName
END CATCH 


SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimBin)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName


 --		7 - FactScan
 SET @StepName = 'FactScan'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')
BEGIN TRY



SELECT COMPANY,
       DOCUMENT,
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
       REQ_NUMBER,
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

SELECT a.SOURCE_DOC_N                                                                         AS REQ_NUMBER,
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
              ON a.COMPANY = e.COMPANY
                 AND a.REQ_NUMBER = e.DOCUMENT
                 AND a.LINE_NBR = e.LINE_NBR 

DROP TABLE #REQLINE
DROP TABLE #ICTRANS
DROP TABLE #POLINE

BEGIN Try
    DROP TABLE bluebin.FactScan
END Try

BEGIN Catch
END Catch


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

DROP TABLE #tmpScan

END TRY

BEGIN CATCH
SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactScan)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName


END CATCH

SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactScan)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName

  --		7 - FactBinSnapshot
 SET @StepName = 'FactBinSnapshot'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')



BEGIN TRY
BEGIN Try
    DROP TABLE bluebin.FactBinSnapshot
END Try

BEGIN Catch
END Catch

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

--SELECT BinKey,
--       Date,
--       [1] AS FirstScan,
--       [2] AS SecondScan
--INTO   #LastTwoScans
--FROM   (SELECT BinKey,
--               Scanseq,
--               b.Date,
--               ( HotScan + StockOut ) AS HotScan
--        FROM   bluebin.FactScan a
--               INNER JOIN bluebin.DimSnapshotDate b
--                       ON Cast(a.OrderDate AS DATE) <= Cast(b.Date AS DATE)
--        WHERE  Scanseq <= 2) p
--       PIVOT ( Sum(HotScan)
--             FOR Scanseq IN ([1],
--                             [2]) ) AS pvt

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
       --LEFT JOIN #LastTwoScans
       --       ON #tmpBinDates.BinKey = #LastTwoScans.BinKey
       --          AND #tmpBinDates.Date = #LastTwoScans.Date
       LEFT JOIN bluebin.DimLocation
              ON #tmpBinDates.LocationID = DimLocation.LocationID
			  AND #tmpBinDates.BinFacility = DimLocation.LocationFacility
       LEFT JOIN bluebin.DimItem
              ON #tmpBinDates.ItemID = DimItem.ItemID
		LEFT JOIN #tmpScannedBins
			ON #tmpBinDates.BinKey = #tmpScannedBins.BinKey




DROP TABLE #LastScans

DROP TABLE #ThresholdScans

--DROP TABLE #LastTwoScans 

DROP TABLE #tmpBinDates

DROP TABLE #tmpScannedBins
END TRY

BEGIN CATCH
SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactBinSnapshot)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName
END CATCH


SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactBinSnapshot)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName

 /********************************************************

 UPDATE CURRENT BIN STATUS

 ********************************************************/
  SET @StepName = 'Update Bin Status'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

UPDATE bluebin.DimBin
SET    DimBin.BinCurrentStatus = DimBinStatus.BinStatus
FROM   bluebin.DimBin
       INNER JOIN bluebin.FactBinSnapshot
               ON DimBin.BinKey = FactBinSnapshot.BinKey
       INNER JOIN bluebin.DimBinStatus
               ON FactBinSnapshot.BinStatusKey = DimBinStatus.BinStatusKey
WHERE  FactBinSnapshot.BinSnapshotDate = Cast(CONVERT(VARCHAR, Dateadd(DAY, -1, Getdate()), 101) AS DATETIME) 

SET @RowCount = (SELECT COUNT(*) FROM bluebin.DimBin)

UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName


 -----------------		Fact Issue

 SET @StepName = 'FactIssue'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')
 BEGIN TRY
 DROP TABLE bluebin.FactIssue
 END TRY
 BEGIN CATCH
 END CATCH
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


SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactIssue)

UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName


 -----------------------   FactWarehouseSnapshot
  SET @StepName = 'FactWarehouseSnapshot'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

 BEGIN TRY
 DROP TABLE bluebin.FactWarehouseSnapshot
 END TRY
 BEGIN CATCH
 END CATCH
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

DROP TABLE #MonthEndDates

DROP TABLE #MonthEndIssues 


SET @RowCount = (SELECT COUNT(*) FROM bluebin.FactWarehouseSnapshot)

UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName

   --		8 - Kanban
 SET @StepName = 'Kanban'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

BEGIN TRY
    DROP TABLE tableau.Kanban
END TRY

BEGIN CATCH
END CATCH

BEGIN TRY
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
END TRY

BEGIN CATCH
SET @RowCount = (SELECT COUNT(*) FROM tableau.Kanban)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Failure'
 WHERE ProcessID = @ProcessID AND StepName = @StepName
END CATCH

SET @RowCount = (SELECT COUNT(*) FROM tableau.Kanban)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName




 /**********************************************************

SOURCING ANALYTICS

 **********************************************************/

   --		10 - Sourcing

SET @StepName = 'Sourcing'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
           )
     VALUES
           (@ProcessID, @StepName, GETDATE())

BEGIN TRY
    DROP TABLE tableau.Sourcing
END TRY

BEGIN CATCH
END CATCH



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

DROP TABLE #tmpPOLines
DROP TABLE #tmpMMDIST
DROP TABLE #tmpPOStatus
DROP TABLE #tmpPOs
 

SET @RowCount = (SELECT COUNT(*) FROM tableau.Sourcing)


UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName

   SET @StepName = 'Contracts'

INSERT INTO [etl].[JobDetails]
           ([ProcessID]
           ,[StepName]
           ,[StartTime]
		   ,Result
           )
     VALUES
           (@ProcessID, @StepName, GETDATE(),'Pending')

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

SET @RowCount = (SELECT COUNT(*) FROM tableau.Contracts)

UPDATE [etl].[JobDetails]
   SET [EndTime] = GETDATE()
      ,[RowCount] = @RowCount
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID AND StepName = @StepName

/*************************************************************

UPDATE FINAL ETL STATS

*************************************************************/


UPDATE [etl].[JobHeader]
   SET [EndTime] = GETDATE()
      ,[Result] = 'Success'
 WHERE ProcessID = @ProcessID

