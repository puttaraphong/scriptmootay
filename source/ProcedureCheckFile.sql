

/****** Object:  StoredProcedure [dbo].[Log_IntegrationService]    Script Date: 29/03/2023 11:25:44 ******/
DROP PROCEDURE [dbo].[Log_IntegrationService]
GO

/****** Object:  StoredProcedure [dbo].[Log_IntegrationService]    Script Date: 29/03/2023 11:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	1: File is run success  , 0 file is ready to process , -1 files not ready 
-- =============================================
CREATE PROCEDURE [dbo].[Log_IntegrationService]
    @PackageName as varchar(100),
	@Status as bit,
	@MessageDetail as varchar(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @HasSuccess as bit ;
	DECLARE @HasFilesReady as bit ;
	DECLARE @ROUND as int;

	SET @HasSuccess = 0;
	SET @HasFilesReady = 0;


	--check package run is succss on current day
	IF EXISTS (SELECT 1 FROM Log_IntegrationServices WHERE PackageName = @PackageName
	    and DATEDIFF(day,PackageStart,GETDATE()) = 0 and Status = 1)
	BEGIN 
	  
		RETURN 1;
	END

	IF @Status = 1 
	BEGIN
	   IF NOT EXISTS (SELECT 1 FROM Log_IntegrationServices WHERE PackageName = @PackageName
	    and DATEDIFF(day,PackageStart,GETDATE()) = 0 )
        BEGIN
			INSERT INTO [dbo].[Log_IntegrationServices]
			  ([PackageID]
			 ,[PackageName]
			  ,[PackageStart]
			  ,[PackageEnd]
			  ,[Status]
			  ,[Round]
			  ,[MessageDetail])
		     VALUES
			  ( NEWID()       
			  ,@PackageName
			  ,GETDATE()
			  ,NULL
			  ,0
			  ,1
			  ,@MessageDetail)
        END

	   UPDATE Log_IntegrationServices SET Status = 1,
	          [PackageEnd] = GETDATE(),
			  MessageDetail = @MessageDetail			  
	          WHERE PackageName = @PackageName
	          AND  DATEDIFF(day,PackageStart,GETDATE()) = 0

		--delete item over 30 days

	     DELETE  FROM Log_IntegrationServices 
	          WHERE DATEDIFF(day,PackageStart,getdate()) > 30 

	   RETURN 1;
	END


	  IF NOT EXISTS (SELECT 1 FROM Log_IntegrationServices WHERE PackageName = @PackageName
	    and DATEDIFF(day,PackageStart,GETDATE()) = 0 )
        BEGIN
			INSERT INTO [dbo].[Log_IntegrationServices]
			  ([PackageID]
			 ,[PackageName]
			  ,[PackageStart]
			  ,[PackageEnd]
			  ,[Status]
			  ,[Round]
			  ,[MessageDetail])
		     VALUES
			  ( NEWID()       
			  ,@PackageName
			  ,GETDATE()
			  ,NULL
			  ,0
			  ,1
			  ,@MessageDetail)
        END
		ELSE
		BEGIN

		    SELECT @ROUND = [ROUND] from Log_IntegrationServices 
			WHERE PackageName = @PackageName and DATEDIFF(day,PackageStart,GETDATE()) = 0 
		     UPDATE Log_IntegrationServices
	         SET [Status] = 0 ,
			     [Round] = @ROUND+1

	      WHERE PackageName = @PackageName and DATEDIFF(day,PackageStart,GETDATE()) = 0
	     
		END



	-------------------************check all files ****************---------------------------------
	--return filse is ready or not 

	-------------------************end check all files ****************------------------------------
	SET @HasFilesReady = 1;
	IF @HasFilesReady = 1
	BEGIN
	  PRINT 'File ready'
	  RETURN 0;
	END
	ELSE 
	BEGIN
	  PRINT 'Files not ready'
	 RETURN -1;
	END
	
END
GO


