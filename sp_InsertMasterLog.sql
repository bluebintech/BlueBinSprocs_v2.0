if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertMasterLog') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertMasterLog
GO

CREATE PROCEDURE sp_InsertMasterLog
@UserLogin varchar (30)
,@ActionType varchar (30)
,@ActionName varchar (50)
,@ActionID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON


Insert into bluebin.MasterLog ([BlueBinUserID],[ActionType],[ActionName],[ActionID],[ActionDateTime]) Values
((select BlueBinUserID from bluebin.BlueBinUser where [UserLogin] = @UserLogin),@ActionType,@ActionName,@ActionID,getdate())

END
GO
grant exec on sp_InsertMasterLog to appusers
GO
