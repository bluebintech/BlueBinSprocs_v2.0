if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCNType
GO

--exec sp_EditQCNType 'TEST'

CREATE PROCEDURE sp_EditQCNType
@QCNTypeID int
,@Name varchar (255)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.QCNType set Name = @Name,Active = @Active, LastUpdated = getdate() where QCNTypeID = @QCNTypeID

END

GO
grant exec on sp_EditQCNType to appusers
GO