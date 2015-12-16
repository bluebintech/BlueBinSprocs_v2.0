if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCNStatus
GO

--exec sp_EditQCNStatus 'TEST'

CREATE PROCEDURE sp_EditQCNStatus
@QCNStatusID int
,@Status varchar (255)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.QCNStatus set [Status] = @Status,[Active] = @Active, [LastUpdated ]= getdate() where QCNStatusID = @QCNStatusID

END

GO
grant exec on sp_EditQCNStatus to appusers
GO