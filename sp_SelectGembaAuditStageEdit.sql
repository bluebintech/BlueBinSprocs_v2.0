if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditStageEdit') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditStageEdit
GO

--exec sp_SelectGembaAuditStageEdit 'TEST'

CREATE PROCEDURE sp_SelectGembaAuditStageEdit
@GembaAuditStageID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
    a.GembaAuditStageID
    , convert(varchar,a.[Date],101) as [Date]
    ,b.UserLogin as Auditer
    ,a.[KanbansFilled]
    ,a.[KanbansFilledText]
    ,a.[LeftBehind]
    ,a.[FollowUpDistrib]
    ,a.[FollowUpDistribText]
    ,a.[Concerns]
    ,a.[DirectOrderBins]
    ,convert(varchar,a.[OldestBin],101) as OldestBin
    ,a.[CheckOpenOrders]
    ,a.[CheckOpenOrdersText]
    ,a.[HowManyLate]
    ,a.[FollowUpBuyers]
    ,a.[FollowUpBuyersText]
    ,a.[UpdatedStatusTag]
    ,a.[UpdatedStatusTagText]
    ,a.[ReqsSubmitted]
    ,a.[ReqsSubmittedText]
    ,a.[BinsInOrder]
    ,a.[BinsInOrderText]
    ,a.[AreaNeatTidy]
    ,a.[AreaNeatTidyText]
    ,a.[CartsClean]
    ,a.[CartsCleanText]
    ,a.[AdditionalComments]
    , convert(varchar,a.[LastUpdated],101) as [LastUpdated]
from gemba.GembaAuditStage a 
	inner join bluebin.BlueBinUser b on a.[AuditerUserID] = b.BlueBinUserID
where 
	a.GembaAuditStageID=@GembaAuditStageID
END
GO
grant exec on sp_SelectGembaAuditStageEdit to appusers
GO
