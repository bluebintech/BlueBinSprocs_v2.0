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
--		INNER JOIN ICLOCATION e
--		ON a.COMPANY = e.COMPANY
--		AND a.LOCATION = e.LOCATION
--WHERE e.LOCATION_TYPE <> 'P'
 
GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'Warehouse Item'
GO