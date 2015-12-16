if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteGembaAuditStage
GO

CREATE PROCEDURE sp_DeleteGembaAuditStage
@GembaAuditStageID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditStage] set Active = 0, LastUpdated = getdate() where GembaAuditStageID = @GembaAuditStageID  

END
GO
grant exec on sp_DeleteGembaAuditStage to appusers
GO
