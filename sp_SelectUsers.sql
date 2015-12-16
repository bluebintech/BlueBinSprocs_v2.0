if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectUsers') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectUsers
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_SelectUsers
@Name varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	[BlueBinUserID]
      ,[UserLogin]
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName
	  ,[Active]
      ,[LastUpdated]
      ,bbur.RoleID
	  ,bbur.RoleName
      ,[LastLoginDate]
      ,[MustChangePassword]
	  ,	case 
		when [MustChangePassword] = 1 then 'Yes' 
		Else 'No' 
		end as [MustChangePasswordName]
      ,[PasswordExpires]
      ,'' as [Password]
      ,[Email]
  FROM [bluebin].[BlueBinUser] bbu
  inner join bluebin.BlueBinRoles bbur on bbu.RoleID = bbur.RoleID
  where UserLogin <> ''
  and
  ([LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' )
  order by LastName

END
GO
grant exec on sp_SelectUsers to appusers
GO
