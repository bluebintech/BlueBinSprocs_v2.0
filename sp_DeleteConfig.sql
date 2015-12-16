if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteConfig
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_DeleteConfig
@original_ConfigID int,
@original_ConfigName varchar(30),
@original_ConfigValue varchar(30)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	DELETE FROM bluebin.[Config] 
	WHERE [ConfigID] = @original_ConfigID 
		AND [ConfigName] = @original_ConfigName 
			AND [ConfigValue] = @original_ConfigValue 
				

END
GO
grant exec on sp_DeleteConfig to appusers
GO
