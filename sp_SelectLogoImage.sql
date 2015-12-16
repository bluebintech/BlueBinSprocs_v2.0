if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectLogoImage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectLogoImage
GO


CREATE PROCEDURE sp_SelectLogoImage

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'CustomerImage'

END

GO
grant exec on sp_SelectLogoImage to appusers
GO