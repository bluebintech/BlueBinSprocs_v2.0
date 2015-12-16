if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCN
GO

CREATE PROCEDURE sp_DeleteQCN
@QCNID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [qcn].[QCN] set [Active] = 0, [LastUpdated] = getdate() where QCNID = @QCNID

END
GO
grant exec on sp_DeleteQCN to appusers
GO
