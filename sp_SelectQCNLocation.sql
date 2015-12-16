if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNLocation') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNLocation
GO

--exec sp_SelectQCN ''
CREATE PROCEDURE sp_SelectQCNLocation

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select distinct a.LocationID,rTrim(a.ItemID) as ItemID,b.ItemClinicalDescription,rTrim(a.ItemID)+ ' - ' + b.ItemClinicalDescription as ExtendedDescription 
from [bluebin].[DimBin] a 
                                inner join [bluebin].[DimItem] b on rtrim(a.ItemID) = rtrim(b.ItemID)  where b.ItemClinicalDescription is not null 
								UNION select distinct LocationID,'' as ItemID,'' as ItemClinicalDescription, ''  as ExtendedDescription from [bluebin].[DimBin]
                                       order by rTrim(a.ItemID)+ ' - ' + b.ItemClinicalDescription asc

END
GO
grant exec on sp_SelectQCNLocation to appusers
GO


