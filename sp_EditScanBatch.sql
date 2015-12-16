
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditScanBatch
GO

--exec sp_EditScanBatch

CREATE PROCEDURE sp_EditScanBatch

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON




END
GO
grant exec on sp_EditScanBatch to public
GO
