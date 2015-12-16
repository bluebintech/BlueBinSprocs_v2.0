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
