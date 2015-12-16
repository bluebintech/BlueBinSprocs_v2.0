if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectBlueBinResource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectBlueBinResource
GO


CREATE PROCEDURE sp_SelectBlueBinResource
@Name varchar (30)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
[BlueBinResourceID], 
[Login], 
[FirstName], 
[LastName], 
[MiddleName], 
[Email], 
[Title],
[Phone],
[Cell],
case when Active = 1 then 'Yes' Else 'No' end as ActiveName,
Active,
LastUpdated

FROM [bluebin].[BlueBinResource] 

WHERE [LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' 
	
ORDER BY [LastName]
END

GO
grant exec on sp_SelectBlueBinResource to appusers
GO
