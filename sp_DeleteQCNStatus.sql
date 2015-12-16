if exists (Select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCNStatus
GO

--exec sp_DeleteQCNStatus 

CREATE PROCEDURE sp_DeleteQCNStatus
@original_QCNStatusID int,
@original_Status varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.[QCNStatus] Set Active = 0 WHERE [QCNStatusID] = @original_QCNStatusID AND [Status] = @original_Status

END
GO
grant exec on sp_DeleteQCNStatus to appusers
GO