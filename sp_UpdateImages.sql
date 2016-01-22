if exists (select * from dbo.sysobjects where id = object_id(N'sp_UpdateImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_UpdateImages
GO

--exec sp_UpdateImages 'gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_UpdateImages
@GembaAuditNodeID int,
@UserLogin varchar(60),
@ImageSourceIDPH int 


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from bluebin.[Image] where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH)))))
	BEGIN
	update [bluebin].[Image] set ImageSourceID = @GembaAuditNodeID where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
	END

END

GO
grant exec on sp_UpdateImages to appusers
GO