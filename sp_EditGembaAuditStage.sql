if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditGembaAuditStage
GO

--exec sp_EditGembaAuditStage 'TEST'

CREATE PROCEDURE sp_EditGembaAuditStage
	@GembaAuditStageID int,
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
Update [gemba].[GembaAuditStage] Set

	[KanbansFilled] = @KanbansFilled,
	[KanbansFilledText] = @KanbansFilledText,
	[LeftBehind] = @LeftBehind,
	[FollowUpDistrib] = @FollowUpDistrib,
	[FollowUpDistribText] = @FollowUpDistribText,
	[Concerns] = @Concerns,
	[DirectOrderBins] = @DirectOrderBins,
	[OldestBin] = @OldestBin,
	[CheckOpenOrders] = @CheckedOpenOrders,
	[CheckOpenOrdersText] = @CheckedOpenOrdersText,
	[HowManyLate] = @HowManyLate,
	[FollowUpBuyers] = @FollowUpBuyers,
	[FollowUpBuyersText] = @FollowUpBuyersText,
	[UpdatedStatusTag] = @UpdatedStatusTag,
	[UpdatedStatusTagText] = @UpdatedStatusTagText,
	[ReqsSubmitted] = @ReqsSubmitted,
	[ReqsSubmittedText] = @ReqsSubmittedText,
	[BinsInOrder] = @BinsInOrder,
	[BinsInOrderText] = @BinsInOrderText,
	[AreaNeatTidy] = @AreaNeatTidy,
	[AreaNeatTidyText] = @AreaNeatTidyText,
	[CartsClean] = @CartsClean,
	[CartsCleanText] = @CartsCleanText,
	[AdditionalComments] = @AdditionalCommentsText,
    [LastUpdated] = getdate()
	Where [GembaAuditStageID] = @GembaAuditStageID	

END
GO
grant exec on sp_EditGembaAuditStage to appusers
GO
