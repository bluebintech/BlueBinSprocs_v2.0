if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditRoles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditRoles
GO


CREATE PROCEDURE sp_EditRoles
@RoleID int,
@RoleName varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

update bluebin.BlueBinRoles set RoleName = @RoleName where RoleID = @RoleID
END
GO
grant exec on sp_EditRoles to appusers
GO