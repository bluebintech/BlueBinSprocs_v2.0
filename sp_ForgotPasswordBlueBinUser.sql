if exists (select * from dbo.sysobjects where id = object_id(N'sp_ForgotPasswordBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ForgotPasswordBlueBinUser
GO
CREATE PROCEDURE sp_ForgotPasswordBlueBinUser
      @UserLogin NVARCHAR(30)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastUpdated DATETIME,@RandomPassword varchar(20), @newpwdHash varbinary(max)
	  
     
      SELECT @BlueBinUserID = BlueBinUserID
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin --(HASHBYTES('SHA1', @oldpwdHash))--@Password
     
      IF @BlueBinUserID IS NOT NULL  
      BEGIN
            DECLARE @UserTable TABLE (BlueBinUserID int, UserLogin varchar(50), pwd varchar(10),created datetime)
			declare @table table (p varchar(50))

			insert @table exec sp_GeneratePassword 8 
			set @RandomPassword = (Select p from @table)
			insert @UserTable (BlueBinUserID,UserLogin,pwd,created) VALUES (@BlueBinUserID,@UserLogin,@RandomPassword,getdate())
			set @newpwdHash = convert(varbinary(max),rtrim(@RandomPassword))

						UPDATE [bluebin].[BlueBinUser]
						SET MustChangePassword = 1,LastUpdated = getdate(), [Password] = (HASHBYTES('SHA1', @newpwdHash))
						WHERE BlueBinUserID = @BlueBinUserID

			Select pwd from @UserTable
			--Select @newpwdHash
			--select (HASHBYTES('SHA1', @newpwdHash))
	--
	END
END
	
GO
grant exec on sp_ForgotPasswordBlueBinUser to appusers
GO
