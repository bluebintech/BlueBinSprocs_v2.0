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


    SELECT DISTINCT 
		DATEADD(DAY, 1, EOMONTH(DATEADD(MONTH, -1, Date))) as MonthStart,
		Eomonth(Date) AS MonthEnd
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
                  ON a.MonthEnd >= b.TRANS_DATE AND a.MonthStart <= b.TRANS_DATE
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