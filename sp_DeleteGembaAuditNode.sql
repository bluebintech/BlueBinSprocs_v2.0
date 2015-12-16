if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteGembaAuditNode') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteGembaAuditNode
GO

CREATE PROCEDURE sp_DeleteGembaAuditNode
@GembaAuditNodeID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditNode] set Active = 0, LastUpdated = getdate() where GembaAuditNodeID = @GembaAuditNodeID  

END
GO
grant exec on sp_DeleteGembaAuditNode to appusers
GO