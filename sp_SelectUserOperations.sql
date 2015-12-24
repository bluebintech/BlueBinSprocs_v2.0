if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectUserOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectUserOperations
GO

--exec sp_SelectUserOperations 'Butler'
CREATE PROCEDURE sp_SelectUserOperations
@Name varchar(50)
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select 
bbuo.BlueBinUserID,
bbuo.OpID,
bbu.UserLogin,
bbu.LastName + ', ' + FirstName as Name,
bbr.RoleName as [CurrentRole],
bbo.OpName 
from bluebin.BlueBinUserOperations bbuo
inner join bluebin.BlueBinUser bbu on bbuo.BlueBinUserID = bbu.BlueBinUserID
inner join bluebin.BlueBinRoles bbr on bbu.RoleID = bbr.RoleID
inner join bluebin.BlueBinOperations bbo on bbuo.OpID = bbo.OpID
where bbu.Active = 1
  and
  ([LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' )
order by bbu.LastName + ', ' + FirstName,bbo.OpName

END
GO
grant exec on sp_SelectUserOperations to appusers
GO