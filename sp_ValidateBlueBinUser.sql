if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateBlueBinUser
GO

--exec sp_ValidateBlueBinUser 'gbutler@bluebin.com','12345'
--grant exec on sp_ValidateBlueBinUser to appusers

CREATE PROCEDURE [dbo].[sp_ValidateBlueBinUser]
      @UserLogin NVARCHAR(30),
      @Password varchar(max)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastLoginDate DATETIME, @pwdHash varbinary(max), @MustChangePassword int
	  set @pwdHash = convert(varbinary(max),rtrim(@Password))
     
      SELECT 
	  @BlueBinUserID = BlueBinUserID, 
	  @LastLoginDate = LastLoginDate, 
	  @MustChangePassword = 
		case when LastUpdated  + PasswordExpires < getdate() then 1 else MustChangePassword end  --Password Expiration Date or if flag set
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin AND [Password] = (HASHBYTES('SHA1', @pwdHash))--@Password
     
      IF @UserLogin IS NOT NULL  
      BEGIN
            IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID)
            BEGIN
				IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID and Active = 1)
					BEGIN
					  IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID and Active = 1 and MustChangePassword = 0)
						BEGIN
						UPDATE [bluebin].[BlueBinUser]
						SET LastLoginDate = GETDATE()
						WHERE BlueBinUserID = @BlueBinUserID
						SELECT @BlueBinUserID [BlueBinUserID] -- User Valid
						END
						ELSE
						BEGIN
						SELECT -3 -- Must Change Password
						END
					END
					ELSE
					BEGIN
						SELECT -2 -- User not active.
					END
			END
			ELSE
			BEGIN
				SELECT -1 -- User invalid.
			END
	END
--select * from bluebin.BlueBinUser where [Password] = HASHBYTES('SHA1', @Password)
END
GO
grant exec on sp_ValidateBlueBinUser to appusers
GO


