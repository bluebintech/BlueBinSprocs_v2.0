if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertOperations
GO


CREATE PROCEDURE sp_InsertOperations
@OpName varchar(50),
@Description varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if not exists(select * from bluebin.BlueBinOperations where OpName = @OpName)
BEGIN
insert into bluebin.BlueBinOperations select @OpName,@Description
END

END
GO
grant exec on sp_InsertOperations to appusers
GO
