
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditScanLine') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditScanLine
GO

--exec sp_EditScanLine

CREATE PROCEDURE sp_EditScanLine

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON




END
GO
grant exec on sp_EditScanLine to public
GO
