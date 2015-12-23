if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteBlueBinTraining
GO

CREATE PROCEDURE sp_DeleteBlueBinTraining
@BlueBinTrainingID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [bluebin].[BlueBinTraining] set [Active] = 0, [LastUpdated] = getdate() where BlueBinTrainingID = @BlueBinTrainingID

END
GO
grant exec on sp_DeleteBlueBinTraining to appusers
GO
