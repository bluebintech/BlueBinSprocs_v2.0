if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertUserOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertUserOperations
GO

--exec sp_InsertUserOperations 2,2
CREATE PROCEDURE sp_InsertUserOperations
@BlueBinUserID int,
@OpID int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into bluebin.BlueBinUserOperations select @BlueBinUserID,@OpID

END
GO
grant exec on sp_InsertUserOperations to appusers
GO
