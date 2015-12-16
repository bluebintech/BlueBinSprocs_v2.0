if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertQCNType
GO

--exec sp_InsertQCNType 'TEST'

CREATE PROCEDURE sp_InsertQCNType
@Name varchar (255)



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from qcn.QCNType where Name = @Name)
BEGIN
GOTO THEEND
END
insert into qcn.QCNType (Name,Active,LastUpdated) VALUES (@Name,1,getdate())

END
THEEND:

GO
grant exec on sp_InsertQCNType to appusers
GO
