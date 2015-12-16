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