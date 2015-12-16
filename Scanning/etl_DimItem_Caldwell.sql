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



/*********************		CREATE DimItem		**************************************/


SELECT Row_number()
         OVER(
           ORDER BY a.[ItemNumber])                AS ItemKey,
       a.[ItemNumber]                        AS ItemID,
       a.[ItemDescription]                  AS ItemDescription,
	   ''						AS ItemDescription2,
       a.[ItemDescription]               AS ItemClinicalDescription,
       'A'                     AS ActiveStatus,
       ''                        AS ItemManufacturer,
       ''                         AS ItemManufacturerNumber,
       ''                      AS ItemVendor,
       ''                           AS ItemVendorNumber,
       ''                      AS LastPODate,
       ''                        AS StockLocation,
       ''                         AS VendorItemNumber,
	   'EA'							AS StockUOM,
       ''                              AS BuyUOM,
       '' AS PackageString
INTO   bluebin.DimItem
FROM   [dbo].[ItemMaster] a
 

GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimItem'

