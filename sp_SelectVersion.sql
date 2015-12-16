if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectVersion
GO


CREATE PROCEDURE sp_SelectVersion

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'Version'

END

GO
grant exec on sp_SelectVersion to appusers
GO