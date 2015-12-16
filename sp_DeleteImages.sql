if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteImages
GO

--exec sp_DeleteImages 'gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_DeleteImages
@UserLogin varchar(100),
@ImageSourceIDPH int 


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Delete 
from bluebin.[Image]
where 
ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
;
Delete from bluebin.MasterLog 
where ActionType = 'Gemba' and 
		BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin) and 
			ActionID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))

END
GO
grant exec on sp_DeleteImages to appusers
GO
