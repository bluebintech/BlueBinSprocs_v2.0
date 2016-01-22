if not exists (select * from sys.tables where name = 'JobHeader')
BEGIN

CREATE TABLE [etl].[JobHeader](
	[ProcessID] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Duration]  AS ((((right('0'+CONVERT([varchar],datediff(hour,[StartTime],[EndTime]),(0)),(2))+':')+right('0'+CONVERT([varchar],datediff(minute,[StartTime],[EndTime]),(0)),(2)))+':')+right('0'+CONVERT([varchar],datediff(second,[StartTime],[EndTime])%(60),(0)),(2))),
	[Result] [varchar](50) NULL
) ON [PRIMARY]

END
GO