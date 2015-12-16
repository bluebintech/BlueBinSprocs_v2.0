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

--SELECT REQ_LOCATION,
--       Min(CREATION_DATE) AS BinAddedDate
--INTO   #BinAddDates
--FROM   REQLINE a INNER JOIN bluebin.DimLocation b ON a.REQ_LOCATION = b.LocationID
--WHERE  b.BlueBinFlag = 1
--GROUP  BY REQ_LOCATION

SELECT Row_number()
         OVER(
           Partition BY sl.ItemID,sl.Qty
           ORDER BY sl.ScanDateTime DESC) AS Itemreqseq,
       sl.ItemID,
       '' as        ENTERED_UOM,
       '' as        UNIT_COST
INTO   #ItemReqs
FROM   scan.ScanLine sl 
INNER JOIN scan.ScanBatch sb on sl.ScanBatchID = sb.ScanBatchID
INNER JOIN bluebin.DimLocation b ON sb.LocationID = b.LocationID
WHERE  b.BlueBinFlag = 1
;

/***********************************		CREATE	DimBin		***********************************/
WITH A AS
(
SELECT 
DISTINCT 
--Row_number()
--             OVER(
--               ORDER BY pm.[LocationName], pm.[ItemNumber])  AS BinKey,
			  'Caldwell' AS BinFacility,
           pm.ItemNumber AS ItemID,
           pm.LocationId  AS LocationID,
           pm.BinSequence AS BinSequence,
		   	CASE WHEN pm.BinSequence LIKE '[A-Z][A-Z]%' THEN LEFT(pm.BinSequence, 2) ELSE LEFT(pm.BinSequence, 1) END as BinCart,
			CASE WHEN pm.BinSequence LIKE '[A-Z][A-Z]%' THEN SUBSTRING(pm.BinSequence, 3, 1) ELSE SUBSTRING(pm.BinSequence, 2,1) END as BinRow,
			CASE WHEN pm.BinSequence LIKE '[A-Z][A-Z]%' THEN SUBSTRING (pm.BinSequence,4,2) ELSE SUBSTRING(pm.BinSequence, 3,2) END as BinPosition,
           CASE
             WHEN pm.BinSequence LIKE 'CARD%' THEN 'WALL'
             ELSE RIGHT(pm.BinSequence, 3)
           END AS BinSize,
           ''  AS BinUOM,
           CASE
				when scan.Qty is null then '' else scan.Qty End  AS BinQty,
           --CASE
           --  WHEN pm.LeadTime <6  THEN 3
           --  ELSE pm.LeadTime END   AS BinLeadTime,
		   '3' AS BinLeadTime,
           ''   AS BinGoLiveDate,
           '' AS BinCurrentCost,
           '' AS BinConsignmentFlag,
           '' AS BinGLAccount,
		   'Awaiting Updated Status'AS BinCurrentStatus
    --INTO   bluebin.DimBin
    FROM   [dbo].[ParMaster] pm
           INNER JOIN bluebin.DimLocation dl
                   ON pm.[LocationId] = dl.LocationID
				   AND dl.LocationFacility	= 'Caldwell'		   
           --INNER JOIN #BinAddDates
           --        ON ITEMLOC.LOCATION = #BinAddDates.REQ_LOCATION
           LEFT JOIN #ItemReqs ir
                  ON pm.ItemNumber = ir.ItemID
                     --AND ITEMLOC.UOM = #ItemReqs.ENTERED_UOM
                     AND ir.Itemreqseq = 1
           LEFT JOIN (
		   select sb.LocationID,sl.ItemID,sl.Qty 
		   from scan.ScanBatch sb 
		   inner join scan.ScanLine sl on sb.ScanBatchID = sl.ScanBatchID
		   ) as scan on pm.LocationId = scan.LocationID and pm.ItemNumber = scan.ItemID
	WHERE dl.BlueBinFlag = 1
)  

Select
Row_number()
             OVER(
               ORDER BY [LocationID], [ItemID])  AS BinKey,* 
			   INTO   bluebin.DimBin
			   from A
/*****************************************		DROP Temp Tables	**************************************/

--DROP TABLE #BinAddDates
DROP TABLE #ItemReqs


GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimBin'