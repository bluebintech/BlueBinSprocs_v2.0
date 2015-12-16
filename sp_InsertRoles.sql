if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertRoles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertRoles
GO


CREATE PROCEDURE sp_InsertRoles
@RoleName varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
insert into bluebin.BlueBinRoles select @RoleName

END
GO
grant exec on sp_InsertRoles to appusers
GO
