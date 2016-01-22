if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertImage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertImage
GO

--exec sp_SelectQCN ''
CREATE PROCEDURE sp_InsertImage
@ImageName varchar(100),
@ImageType varchar(10),
@ImageSource varchar(100),
@UserLogin varchar(60),
@ImageSourceID int,
@Image varbinary(max)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
insert into bluebin.[Image] 
(ImageName,ImageType,ImageSource,ImageSourceID,[Image],[Active],[DateCreated],[LastUpdated])        
VALUES 
(@ImageName,@ImageType,@ImageSource,(select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceID)))),@Image,1,getdate(),getdate())

;
declare @ImageSourcePH int = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceID))))
declare @Text varchar(60) = 'Insert Image - '+@ImageName

exec sp_InsertMasterLog @UserLogin,'Gemba',@Text,@ImageSourcePH

END
GO
grant exec on sp_InsertImage to appusers
GO

