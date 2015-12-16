if not exists (select * from sys.tables where name = 'JobSteps')
BEGIN

CREATE TABLE [etl].[JobSteps](
	[StepNumber] [int] NOT NULL,
	[StepName] [varchar](255) NOT NULL,
	[StepProcedure] [varchar](255) NOT NULL,
	[StepTable] [varchar](255) NULL,
	[ActiveFlag] [int] NOT NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY]
;
insert into etl.JobSteps (StepNumber,StepName,StepProcedure,StepTable,ActiveFlag,LastModifiedDate) VALUES
('1','DimItem','etl_DimItem','bluebin.DimItem',0,getdate()),
('2','DimLocation','etl_DimLocation','bluebin.DimLocation',0,getdate()),
('3','DimDate','etl_DimDate','bluebin.DimDate',0,getdate()),
('4','DimBinStatus','etl_DimBinStatus','bluebin.DimBinStatus',0,getdate()),
('5','DimBin','etl_DimBin','bluebin.DimBin',0,getdate()),
('6','FactScan','etl_FactScan','bluebin.FactScan',0,getdate()),
('7','FactBinSnapshot','etl_FactBinSnapshot','bluebin.FactBinSnapshot',0,getdate()),
('9','FactIssue','etl_FactIssue','bluebin.FactIssue',0,getdate()),
('10','FactWarehouseSnapshot','etl_FactWarehouseSnapshot','bluebin.FactWarehouseSnapshot',0,getdate()),
('11','Kanban','tb_Kanban','tableau.Kanban',0,getdate()),
('12','Sourcing','tb_Sourcing','tableau.Sourcing',0,getdate()),
('13','Contracts','tb_Contracts','tableau.Contracts',0,getdate()),
('8','Update Bin Status','etl_UpdateBinStatus','bluebin.DimBin',0,getdate()),
('14','Warehouse Item','etl_DimWarehouseItem','bluebin.DimWarehouseItem',0,getdate())
END
GO