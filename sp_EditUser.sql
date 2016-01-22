if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditUser
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_EditUser
@BlueBinUserID int,
@UserLogin varchar(60),
@FirstName varchar(30), 
@LastName varchar(30), 
@MiddleName varchar(30), 
@Active int,
@Email varchar(60), 
@MustChangePassword int,
@PasswordExpires int,
@Password varchar(50),
@RoleName  varchar(30),
@Title varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @newpwdHash varbinary(max),@message varchar(255), @fakelogin varchar(50)
set @newpwdHash = convert(varbinary(max),rtrim(@Password))

IF (@Password = '' or @Password is null)
	BEGIN
	update bluebin.BlueBinUser set 
        FirstName = @FirstName, 
        LastName = @LastName, 
        MiddleName = @MiddleName, 
        Active = @Active,
        Email = @UserLogin,--@Email, 
        LastUpdated = getdate(), 
        MustChangePassword = @MustChangePassword,
        PasswordExpires = @PasswordExpires,
        RoleID = (select RoleID from bluebin.BlueBinRoles where RoleName = @RoleName),
		Title = @Title
		Where BlueBinUserID = @BlueBinUserID
	END
	ELSE
	BEGIN
		update bluebin.BlueBinUser set 
        FirstName = @FirstName, 
        LastName = @LastName, 
        MiddleName = @MiddleName, 
        Active = @Active,
        Email = @UserLogin,--@Email, 
        LastUpdated = getdate(), 
        MustChangePassword = @MustChangePassword,
        PasswordExpires = @PasswordExpires,
		[Password] = (HASHBYTES('SHA1', @newpwdHash)),
        RoleID = (select RoleID from bluebin.BlueBinRoles where RoleName = @RoleName),
		Title = @Title
		Where BlueBinUserID = @BlueBinUserID
	END

	;
	set @message = 'User Updated - '+ @UserLogin
	select @fakelogin = 'gbutler@bluebin.com'
	exec sp_InsertMasterLog @fakelogin,'Users',@message,@BlueBinUserID
END
GO
grant exec on sp_EditUser to appusers
GO