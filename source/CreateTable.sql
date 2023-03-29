

/****** Object:  Table [dbo].[Log_IntegrationServices]    Script Date: 29/03/2023 11:04:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Log_IntegrationServices](
	[PackageID] [uniqueidentifier] NOT NULL,
	[PackageName] [varchar](100) NULL,
	[PackageStart] [datetime] NULL,
	[PackageEnd] [datetime] NULL,
	[Status] [bit] NULL,
	[Round] [int] NULL,
	[MessageDetail] [varchar](2000) NULL,
 CONSTRAINT [PK_Log_IntegrationServices] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Log_IntegrationServices] ADD  CONSTRAINT [DF_Log_IntegrationServices_PackageID]  DEFAULT (newid()) FOR [PackageID]
GO


