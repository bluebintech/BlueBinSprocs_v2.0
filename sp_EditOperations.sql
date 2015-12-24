if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditOperations
GO


CREATE PROCEDURE sp_EditOperations
@OpID int,
@OpName varchar(50),
@Description varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

update bluebin.BlueBinOperations set OpName = @OpName, [Description] = @Description where OpID = @OpID
END
GO
grant exec on sp_EditOperations to appusers
GO