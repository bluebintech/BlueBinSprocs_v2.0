if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectTableauURL') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectTableauURL
GO


CREATE PROCEDURE sp_SelectTableauURL

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'TableauURL'

END

GO
grant exec on sp_SelectTableauURL to appusers
GO