if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectRoleOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectRoleOperations
GO

--exec sp_SelectRoleOperations
CREATE PROCEDURE sp_SelectRoleOperations

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select 
bbro.RoleID,
bbro.OpID,
bbr.RoleName,
bbo.OpName 
from bluebin.BlueBinRoleOperations bbro
inner join bluebin.BlueBinRoles bbr on bbro.RoleID = bbr.RoleID
inner join bluebin.BlueBinOperations bbo on bbro.OpID = bbo.OpID
order by bbr.RoleName,bbo.OpName

END
GO
grant exec on sp_SelectRoleOperations to appusers
GO