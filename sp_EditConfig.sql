if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditConfig
GO

--exec sp_EditConfig 10,'3','Tableau',1


CREATE PROCEDURE sp_EditConfig
@ConfigID int
,@ConfigValue varchar (100)
,@ConfigType varchar(50)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update bluebin.Config set ConfigValue = @ConfigValue,ConfigType = @ConfigType,Active = @Active, LastUpdated = getdate() where ConfigID = @ConfigID

END
GO
grant exec on sp_EditConfig to appusers
GO
