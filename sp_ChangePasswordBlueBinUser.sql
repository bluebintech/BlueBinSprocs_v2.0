if exists (select * from dbo.sysobjects where id = object_id(N'sp_ChangePasswordBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ChangePasswordBlueBinUser
GO

CREATE PROCEDURE [dbo].[sp_ChangePasswordBlueBinUser]
      @UserLogin NVARCHAR(30),
      @OldPassword varchar(max),
	  @NewPassword varchar(max),
	  @ConfirmNewPassword varchar(max)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastLoginDate DATETIME, @newpwdHash varbinary(max), @oldpwdHash varbinary(max)
	  set @oldpwdHash = convert(varbinary(max),rtrim(@OldPassword))
	  set @newpwdHash = convert(varbinary(max),rtrim(@NewPassword))
     
      SELECT @BlueBinUserID = BlueBinUserID, @LastLoginDate = LastLoginDate
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin AND [Password] = (HASHBYTES('SHA1', @oldpwdHash))--@Password
     
      IF @BlueBinUserID IS NOT NULL  
      BEGIN
            IF @NewPassword = @ConfirmNewPassword
            BEGIN
				IF @OldPassword <> @NewPassword
					BEGIN
					  IF (@NewPassword like '%[0-9]%')
						BEGIN
						UPDATE [bluebin].[BlueBinUser]
						SET LastLoginDate = GETDATE(), MustChangePassword = 0,LastUpdated = getdate(), [Password] = (HASHBYTES('SHA1', @newpwdHash))
						WHERE BlueBinUserID = @BlueBinUserID

						SELECT @BlueBinUserID [BlueBinUserID] -- User Valid
						END
						ELSE
						BEGIN
						SELECT -3 -- Must use at least one number in Password
						END
					END
					ELSE
					BEGIN
						SELECT -2 -- Must use a different password than previous.
					END
			END
			ELSE
			BEGIN
				SELECT -1 -- Passwords don't match.
			END
	END
	ELSE
	BEGIN
	 SELECT -4 -- Old Password does not match with our database records.
	END

END
GO
grant exec on sp_ChangePasswordBlueBinUser to appusers
GO

