
/*
Script to create default BlueBin Users with or without generic random passwords.
If Generic Passwords is set to 'Yes' then all users have the Password Pa55w0rd! otherwise it will be a random password
select * from bluebin.BlueBinUser
select * from bluebin.BlueBinResource
delete from bluebin.BlueBinUser
delete from bluebin.BlueBinResource
exec sp_InsertBlueBinUser 'Yes'
*/

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertBlueBinUser
GO

CREATE PROCEDURE [dbo].[sp_InsertBlueBinUser]
      @UseGeneric varchar(3)

AS
BEGIN

DECLARE @UserTable TABLE (iid int identity (1,1) PRIMARY KEY,BlueBinUserID_id int, UserLogin varchar(255),LastName varchar(15),FirstName varchar(15),Email varchar(50),RoleName varchar (20), [Password] varchar(50),Created int);
DECLARE @length int = 8, @p varchar(50)
declare @iid int,@UserLogin varchar(255),@LastName varchar(15),@FirstName varchar(15),@Email varchar(50), @Password varbinary(max), @RoleID int, @RoleName varchar(20)





/*Users to Create.  List all users here*/
--**********************************************
insert @UserTable (BlueBinUserID_id, UserLogin,LastName,FirstName,Email, RoleName,[Password],Created) VALUES

(0,'gbutler@bluebin.com','Butler','Gerry','gbutler@bluebin.com','BlueBinPersonnel','',0),
(0,'dhagan@bluebin.com','Hagan','Derek','dhagan@bluebin.com','BlueBinPersonnel','',0),
(0,'snevins@bluebin.com','Nevins','Sabrina','snevins@bluebin.com','BlueBinPersonnel','',0),
(0,'chodge@bluebin.com','Hodge','Charles','chodge@bluebin.com','BlueBinPersonnel','',0),
(0,'rswan@bluebin.com','Swan','Robb','rswan@bluebin.com','BlueBinPersonnel','',0),
(0,'cpetschke@bluebin.com','Petschke','Carl','cpetschke@bluebin.com','BlueBinPersonnel','',0)


/*Create generic passwords*/
--**********************************************
select @iid = MIN(iid) from @usertable
while @iid < (select MAX(iid)+ 1 from @usertable)
begin
	declare @table table (p varchar(50))
	insert @table exec sp_GeneratePassword @length 
	update @UserTable set [Password] = 
		case	
			when @UseGeneric = 'Yes' then 'Pa55w0rd!'
			when @UseGeneric = 'No' then (select p from @table) 
			else 'Error!'
		end
		where iid = @iid
	delete from @table
	set @iid = @iid +1
END


/*Create Users and send out an email*/
--**********************************************
select @iid = MIN(iid) from @UserTable
while @iid < (select MAX(iid)+ 1 from @UserTable)
begin
	if not exists (select * from bluebin.BlueBinUser where UserLogin in (select UserLogin from @UserTable where iid = @iid))
	BEGIN	
	select @Password =  convert(varbinary(max),rtrim([Password])) from @UserTable where iid = @iid
	select @RoleID =  RoleID from bluebin.BlueBinRoles where RoleName = (select RoleName from @UserTable where iid = @iid)
		
	Insert Into bluebin.BlueBinUser (UserLogin,FirstName,LastName,MiddleName,Active,LastUpdated,RoleID,LastLoginDate,MustChangePassword,PasswordExpires,[Password],Email)
	Select UserLogin,FirstName,LastName,'',1,getdate(),@RoleID,getdate()-1,1,'90',HASHBYTES('SHA1',@Password),Email from @UserTable where iid = @iid
	update @UserTable set Created = 1 where iid = @iid
--exec sp_sacc_epoint_set_pwd @@IDENTITY,@PWD,@hosp

/*Email with info*/
--**********************************************
/*
			if @email_yn = 'Yes'
			Begin
			select @subject = (select 'New Production Site Login')
			set @message = 'New Production site now available for ' + @newsite1 + ' at ' + @newsite2 + '. You have 5 days to reset your password before being locked out. Your credentials are below.' ;
			set @message = @message + CHAR (13);
			set @message = @message + CHAR (13);
			set @message = @message +  'UID: ' + @user_login ;
			set @message = @message + CHAR (13);
			set @message = @message +  'PWD: ' + @PWD + '  (you will be prompted to change)';
			set @message = @message + CHAR (13);
			set @message = @message + CHAR (13);
			set @message = @message + 'If you have any problems, please contact the TPA ('+@TPA+') on this project.'


			exec sp_sendmail  
			 @varProfile='Support'
			, @varTo = @email
			, @varSubject = @subject
			, @varMessage = @message
			end
--**********************************************
*/
	END

	set @FirstName = (select FirstName from @UserTable where iid = @iid)
	set @LastName = (select LastName from @UserTable where iid = @iid)
	set @UserLogin = (select UserLogin from @UserTable where iid = @iid)
	set @Email = (select Email from @UserTable where iid = @iid)
	set @RoleName = (select RoleName from @UserTable where iid = @iid)

	if not exists (select BlueBinResourceID from bluebin.BlueBinResource where FirstName = @FirstName and LastName = @LastName)--select * from bluebin.BlueBinResource
	BEGIN
		exec sp_InsertBlueBinResource 
		@FirstName,
		@LastName,
		'',
		@UserLogin,
		@Email,'','',
		@RoleName
	END

	set @iid = @iid +1
	
END

Select UserLogin,FirstName,LastName,RoleName,[Password],Email from @UserTable order by LastName
END
GO


