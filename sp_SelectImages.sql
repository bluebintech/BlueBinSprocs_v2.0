if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectImages
GO

--exec sp_SelectImages '','gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_SelectImages
@GembaAuditNodeID int,
@UserLogin varchar(100),
@ImageSourceIDPH int 



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select ImageID,ImageName,ImageType,ImageSource,ImageSourceID,Active,DateCreated 
from bluebin.[Image]    
where 
(ImageSourceID = @GembaAuditNodeID and ImageSource like 'GembaAuditNode%') 
or 
(ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH)))))
order by DateCreated desc


END
GO
grant exec on sp_SelectImages to appusers
GO