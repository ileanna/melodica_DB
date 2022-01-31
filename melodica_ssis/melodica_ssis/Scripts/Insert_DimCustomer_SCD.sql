--SCD TYPE 2 INSERT

INSERT INTO [dbo].[DimCustomer]
           ([CustomerId]
           ,[FirstName]
           ,[LastName]
           ,[Company]
           ,[Address]
           ,[City]
           ,[State]
           ,[Country]
           ,[PostalCode]
           ,[Phone]
           ,[Fax]
           ,[Email]
           ,[SupportRepId]
		   ,RowIsCurrent, 
		   RowStartDate, 
		   RowChangeReason)
SELECT [CustomerId]
      ,[FirstName]
      ,[LastName]
      ,[Company]
      ,[Address]
      ,[City]
      ,[State]
      ,[Country]
      ,[PostalCode]
      ,[Phone]
      ,[Fax]
      ,[Email]
      ,[SupportRepId]
	  ,1
      ,CAST(GetDate() AS Date)
	  ,ActionName
  FROM
  (
	MERGE  [ChinookDW].[dbo].DimCustomer AS target
		USING [ChinookStaging].[dbo].StagingCustomer as source
		ON target.[CustomerID] = source.[CustomerID]
	 WHEN MATCHED AND (source.[FirstName] <> target.[FirstName] 
	 OR source.[LastName] <> target.[LastName] 
	 OR source.[Email] <> target.[Email] 
	 OR source.[Phone] <> target.[Phone]
	 OR source.[Address] <> target.[Address]) AND target.[RowIsCurrent] = 1 
	 THEN UPDATE SET
		 target.RowIsCurrent = 0,
		 target.RowEndDate = dateadd(day, -1, CAST(GetDate() AS Date)) ,
		 target.RowChangeReason = 'UPDATED NOT CURRENT'
	 WHEN NOT MATCHED THEN
	   INSERT  (
		   [CustomerId],
		   [FirstName]
           ,[LastName]
           ,[Company]
           ,[Address]
           ,[City]
           ,[State]
           ,[Country]
           ,[PostalCode]
           ,[Phone]
           ,[Fax]
           ,[Email]
           ,[SupportRepId],
		   RowStartDate ,
		   RowChangeReason
	   )
	   VALUES(source.[CustomerId]
           ,source.[FirstName]
           ,source.[LastName]
           ,source.[Company]
           ,source.[Address]
           ,source.[City]
           ,source.[State]
           ,source.[Country]
           ,source.[PostalCode]
           ,source.[Phone]
           ,source.[Fax]
           ,source.[Email]
           ,source.[SupportRepId],
		   CAST(GetDate() AS Date),
		   'NEW RECORD'
	   )
	WHEN NOT MATCHED BY Source THEN
		UPDATE SET 
			Target.RowEndDate= dateadd(day, -1, CAST(GetDate() AS Date))
			,target.RowIsCurrent = 0
			,Target.RowChangeReason  = 'SOFT DELETE'
	OUTPUT 
		source.[CustomerId]
           ,source.[FirstName]
           ,source.[LastName]
           ,source.[Company]
           ,source.[Address]
           ,source.[City]
           ,source.[State]
           ,source.[Country]
           ,source.[PostalCode]
           ,source.[Phone]
           ,source.[Fax]
           ,source.[Email]
           ,source.[SupportRepId],
		$Action as ActionName   
) AS Mrg
WHERE Mrg.ActionName='UPDATE'
AND [CustomerID] IS NOT NULL;

