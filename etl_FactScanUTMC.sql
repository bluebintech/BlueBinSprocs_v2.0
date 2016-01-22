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
WHERE b.BlueBinFlag = 1 --and DOCUMENT in (select SOURCE_DOC_N from POLINESRC where PO_NUMBER like '%426282%')

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
       AND KILL_QUANTITY = 0 --and REQ_NUMBER in (select SOURCE_DOC_N from POLINESRC where PO_NUMBER like '%426282%')

SELECT 
		CASE
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,6) = '000000' THEN RIGHT(a.SOURCE_DOC_N,4)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,5) = '00000' THEN RIGHT(a.SOURCE_DOC_N,5)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,4) = '0000' THEN RIGHT(a.SOURCE_DOC_N,6)
			WHEN LEN(a.SOURCE_DOC_N) = 10 and LEFT(a.SOURCE_DOC_N,3) = '000' THEN RIGHT(a.SOURCE_DOC_N,7)	
		ELSE a.SOURCE_DOC_N 
		END AS REQ_NUMBER,
       po.LINE_NBR   AS LINE_NBR
       ,MIN(Cast(CONVERT(VARCHAR, COALESCE(b.REC_DATE,po.REC_ACT_DATE), 101) 
			+ ' '
            + LEFT(RIGHT('00000' + CONVERT(VARCHAR, case when b.UPDATE_TIME is null then '00000000' else b.UPDATE_TIME end), 8), 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, case when b.UPDATE_TIME is null then '00000000' else b.UPDATE_TIME end), 8), 3, 2)
            + ':'
            + Substring(RIGHT('00000' + CONVERT(VARCHAR, case when b.UPDATE_TIME is null then '00000000' else b.UPDATE_TIME end), 8), 5, 2) 
			
			AS DATETIME)) AS REC_DATE
INTO #POLINE
FROM   POLINE po
       INNER JOIN POLINESRC a on ltrim(rtrim(po.PO_NUMBER)) = ltrim(rtrim(a.PO_NUMBER))
	   LEFT OUTER JOIN PORECLINE b
               ON ltrim(rtrim(a.PO_NUMBER)) = ltrim(rtrim(b.PO_NUMBER))
                  AND po.LINE_NBR = b.PO_LINE_NBR 
where po.REC_ACT_DATE > getdate()-5000  and REC_QTY >0 --and po.PO_NUMBER like '%426282%'

GROUP BY
	a.SOURCE_DOC_N,
	po.LINE_NBR



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
--WHERE a.REQ_NUMBER in (select SOURCE_DOC_N from POLINESRC where PO_NUMBER like '%426282%')

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
order by 8

/*****************************************		DROP Temp Tables		*******************************/

DROP TABLE #REQLINE
DROP TABLE #ICTRANS
DROP TABLE #POLINE
DROP TABLE #tmpScan

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'FactScan'

