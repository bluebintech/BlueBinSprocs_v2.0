if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertGembaAuditStage
GO

--exec sp_InsertGembaAuditStage 'TEST'

CREATE PROCEDURE sp_InsertGembaAuditStage
	@Auditer varchar(255),
	@KanbansFilled int,
	@KanbansFilledText varchar(max),
	@LeftBehind int,
	@FollowUpDistrib int,
	@FollowUpDistribText varchar(max),
	@Concerns varchar(max),
	@DirectOrderBins int,
	@OldestBin datetime,
	@CheckedOpenOrders int,
	@CheckedOpenOrdersText varchar(max),
	@HowManyLate int,
	@FollowUpBuyers int,
	@FollowUpBuyersText varchar(max),
	@UpdatedStatusTag int,
	@UpdatedStatusTagText varchar(max),
	@ReqsSubmitted int,
	@ReqsSubmittedText varchar(max),
	@BinsInOrder int,
	@BinsInOrderText varchar(max),
	@AreaNeatTidy int,
	@AreaNeatTidyText varchar(max),
	@CartsClean int,
	@CartsCleanText varchar(max),
	@AdditionalCommentsText varchar(max)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

declare @GembaAuditStageID int

insert into [gemba].[GembaAuditStage] (
    [Date],
	[AuditerUserID],
	[KanbansFilled],
	[KanbansFilledText],
	[LeftBehind],
	[FollowUpDistrib],
	[FollowUpDistribText],
	[Concerns],
	[DirectOrderBins],
	[OldestBin],
	[CheckOpenOrders],
	[CheckOpenOrdersText],
	[HowManyLate],
	[FollowUpBuyers],
	[FollowUpBuyersText],
	[UpdatedStatusTag],
	[UpdatedStatusTagText],
	[ReqsSubmitted],
	[ReqsSubmittedText],
	[BinsInOrder],
	[BinsInOrderText],
	[AreaNeatTidy],
	[AreaNeatTidyText],
	[CartsClean],
	[CartsCleanText],
	[AdditionalComments],
	[Active],
	[LastUpdated]
)
VALUES (
getdate(), --Date
(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer),
@KanbansFilled,
@KanbansFilledText,
@LeftBehind,
@FollowUpDistrib,
@FollowUpDistribText,
@Concerns,
@DirectOrderBins,
@OldestBin,
@CheckedOpenOrders,
@CheckedOpenOrdersText,
@HowManyLate,
@FollowUpBuyers,
@FollowUpBuyersText,
@UpdatedStatusTag,
@UpdatedStatusTagText,
@ReqsSubmitted,
@ReqsSubmittedText,
@BinsInOrder,
@BinsInOrderText,
@AreaNeatTidy,
@AreaNeatTidyText,
@CartsClean,
@CartsCleanText,
@AdditionalCommentsText,
1, --Active
getdate())	--Last Updated

	SET @GembaAuditStageID = SCOPE_IDENTITY()
	exec sp_InsertMasterLog @Auditer,'Gemba','New Gemba Stage Audit',@GembaAuditStageID


END
GO
grant exec on sp_InsertGembaAuditStage to appusers
GO