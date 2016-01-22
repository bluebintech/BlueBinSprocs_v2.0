if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditBlueBinResource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditBlueBinResource
GO

--exec sp_EditBlueBinResource 'TEST'

CREATE PROCEDURE sp_EditBlueBinResource
@BlueBinResourceID int
,@FirstName varchar (30)
,@LastName varchar (30)
,@MiddleName varchar (30)
,@Login varchar (60)
,@Email varchar (60)
,@Phone varchar (20)
,@Cell varchar (20)
,@Title varchar (50)
,@Active int



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update bluebin.BlueBinResource set 
FirstName = @FirstName
,LastName = @LastName
,MiddleName = @MiddleName
,[Login] = @Login
,Email = @Email
,Phone = @Phone
,Cell = @Cell
,Title = @Title
,Active = @Active, LastUpdated = getdate() 
where BlueBinResourceID = @BlueBinResourceID	

END
GO
grant exec on sp_EditBlueBinResource to appusers
GO