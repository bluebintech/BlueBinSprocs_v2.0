if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertRoleOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertRoleOperations
GO


CREATE PROCEDURE sp_InsertRoleOperations
@RoleID int,
@OpID int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into bluebin.BlueBinRoleOperations select @RoleID,@OpID

END
GO
grant exec on sp_InsertRoleOperations to appusers
GO
