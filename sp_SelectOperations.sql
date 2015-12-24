if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectOperations
GO


CREATE PROCEDURE sp_SelectOperations



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select OpID,OpName,
isnull([Description],'') as [Description] from bluebin.BlueBinOperations
order by OpName

END
GO
grant exec on sp_SelectOperations to appusers
GO