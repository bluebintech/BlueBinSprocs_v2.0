if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateMenus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateMenus
GO

--exec sp_ValidateMenus 'MENU-QCN'

CREATE PROCEDURE [dbo].[sp_ValidateMenus]
	@ConfigName NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;

declare @Menu as Table (ConfigValue varchar(50))

Select 
Case	
	When ConfigValue = 1 or ConfigValue = 'Yes' Then 'Yes'
	Else 'No'
	End as ConfigValue
from bluebin.Config 
where ConfigName = @ConfigName


END
GO
grant exec on sp_ValidateMenus to appusers
GO