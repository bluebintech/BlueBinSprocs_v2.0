if not exists (select * from sys.tables where name = 'JobDetails')
BEGIN

CREATE TABLE [etl].[JobDetails](
	[ProcessID] [int] NULL,
	[StepName] [varchar](50) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Duration]  AS ((((right('0'+CONVERT([varchar],datediff(hour,[StartTime],isnull([EndTime],getdate())),(0)),(2))+':')+right('0'+CONVERT([varchar],round(datediff(second,[StartTime],isnull([EndTime],getdate()))/(60),(0)),(0)),(2)))+':')+right('0'+CONVERT([varchar],datediff(second,[StartTime],isnull([EndTime],getdate()))%(60),(0)),(2))),
	[RowCount] [int] NULL,
	[Result] [varchar](50) NULL,
	[Message] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO