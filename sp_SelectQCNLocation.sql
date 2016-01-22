if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNLocation') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNLocation
GO

--exec sp_SelectQCNLocation
CREATE PROCEDURE sp_SelectQCNLocation

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select distinct a.LocationID,rTrim(a.ItemID) as ItemID,COALESCE(b.ItemClinicalDescription,b.ItemDescription,'No Description'),rTrim(a.ItemID)+ ' - ' + COALESCE(b.ItemClinicalDescription,b.ItemDescription,'No Description') as ExtendedDescription 
from [bluebin].[DimBin] a 
                                inner join [bluebin].[DimItem] b on rtrim(a.ItemID) = rtrim(b.ItemID)  
								UNION 
								select distinct LocationID,'' as ItemID,'' as ItemClinicalDescription, ''  as ExtendedDescription from [bluebin].[DimBin]
                                       order by rTrim(a.ItemID)+ ' - ' + COALESCE(b.ItemClinicalDescription,b.ItemDescription,'No Description') asc

END
GO
grant exec on sp_SelectQCNLocation to appusers
GO



