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
FROM   (SELECT COALESCE(a.COMPANY, b.COMPANY)       AS COMPANY,
               COALESCE(a.REQ_LOCATION, b.LOCATION) AS REQ_LOCATION,
               COALESCE(a.NAME, b.NAME)             AS NAME
        FROM   (SELECT COMPANY,
                       REQ_LOCATION AS LOCATION,
                       NAME
                FROM   RQLOC
                UNION
                SELECT COMPANY,
                       LOCATION,
                       NAME
                FROM   ICLOCATION) Loc
               LEFT JOIN RQLOC a
                      ON Loc.LOCATION = a.REQ_LOCATION
               LEFT JOIN ICLOCATION b
                      ON Loc.LOCATION = b.LOCATION)a  
GO

UPDATE etl.JobSteps
SET LastModifiedDate = GETDATE()
WHERE StepName = 'DimLocation'