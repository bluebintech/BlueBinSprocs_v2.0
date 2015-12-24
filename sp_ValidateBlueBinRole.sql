if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateBlueBinRole') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateBlueBinRole
GO

--exec sp_ValidateBlueBinRole 'gbutler@bluebin.com','ADMIN-CONFIG'

CREATE PROCEDURE [dbo].[sp_ValidateBlueBinRole]
      @UserLogin NVARCHAR(30),
	  @OpName NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;
--Select RoleName from bluebin.BlueBinRoles
--where RoleID in (select RoleID from bluebin.BlueBinUser where UserLogin = @UserLogin)

declare @UserOp as Table (OpName varchar(50))

insert into @UserOp
select 
Distinct 
OpName 
from bluebin.BlueBinOperations
where 
OpID in (select OpID from bluebin.BlueBinUserOperations where BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))
or
OpID in (select OpID from bluebin.BlueBinRoleOperations where RoleID in (select RoleID from bluebin.BlueBinUser where UserLogin = @UserLogin))


if exists(select * from @UserOp where OpName like '%' + @OpName + '%')
BEGIN
	Select 'Yes'
END
ELSE
	Select 'No'


END
GO
grant exec on sp_ValidateBlueBinRole to appusers
GO