USE MASTER 
GO

CREATE DATABASE ChinookDW
GO

USE ChinookDW
GO

CREATE TABLE [dbo].[DimEmployee](
    [EmployeeId] [int] PRIMARY KEY,
    [LastName] [nvarchar](20) NOT NULL,
    [FirstName] [nvarchar](20) NOT NULL,
    [Title] [nvarchar](30) NULL,
    [ReportsTo] [int] NULL,
    [BirthDate] [datetime] NULL,
    [HireDate] [datetime] NULL,
    [Address] [nvarchar](70) NULL,
    [City] [nvarchar](40) NULL,
    [State] [nvarchar](40) NULL,
    [Country] [nvarchar](40) NULL,
    [PostalCode] [nvarchar](10) NULL,
    [Phone] [nvarchar](24) NULL,
    [Fax] [nvarchar](24) NULL,
    [Email] [nvarchar](60) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );


CREATE TABLE [dbo].[DimTrack](
    [TrackId] [int] PRIMARY KEY,
    [TrackName] [nvarchar](200) NOT NULL,
    [AlbumId] [int] NULL,
    [GenreId] [int] NULL,
    [Composer] [nvarchar](220) NULL,
    [Milliseconds] [int] NOT NULL,
    [Bytes] [int] NULL,
    [UnitPrice] [numeric](10, 2) NOT NULL,
    [AlbumTitle] [nvarchar](160) NOT NULL,
    [ArtistId] [int] NOT NULL,
    [ArtistName] [nvarchar](120) NULL,
    [GenreName] [nvarchar](120) NULL,
    [MediaTypeId] [int] NOT NULL,
    [MediaTypeName][nvarchar](120) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );

CREATE TABLE [dbo].[FactInvoices](
    [InvoiceLineId] [int]  NOT NULL,
    [InvoiceId] [int] NOT NULL,
    [TrackId] [int] NOT NULL,
    [UnitPrice] [numeric](10, 2) NOT NULL,
    [Quantity] [int] NOT NULL,
    [CustomerKey] [int] NOT NULL,      --Customerkey
	--[EmployeeId] [int] NOT NULL,     ---EmployeeID
    [InvoiceDateKey] [int] NOT NULL,
    [BillingAddress] [nvarchar](70) NULL,
    [BillingCity] [nvarchar](40) NULL,
    [BillingState] [nvarchar](40) NULL,
    [BillingCountry] [nvarchar](40) NULL,
    [BillingPostalCode] [nvarchar](10) NULL,
    [Total] [numeric](10, 2) NOT NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );

CREATE TABLE [dbo].[DimPlaylist](
    [PlaylistId] [int] NOT NULL,
    [TrackId] [int] NOT NULL,
    [Name] [nvarchar](120) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
	CONSTRAINT PK_PlaylistTrack PRIMARY KEY (PlaylistId,TrackId)
    );

CREATE TABLE [dbo].[DimCustomer](
	CustomerKey INT  IDENTITY(1,1) Primary Key,
    [CustomerId] [int]  NOT NULL,
    [FirstName] [nvarchar](40) NOT NULL,
    [LastName] [nvarchar](20) NOT NULL,
    [Company] [nvarchar](80) NULL,
    [Address] [nvarchar](70) NULL,
    [City] [nvarchar](40) NULL,
    [State] [nvarchar](40) NULL,
    [Country] [nvarchar](40) NULL,
    [PostalCode] [nvarchar](10) NULL,
    [Phone] [nvarchar](24) NULL,
    [Fax] [nvarchar](24) NULL,
    [Email] [nvarchar](60) NOT NULL,
    [SupportRepId] [int] NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
	
    );

	

---------------------FOR INCREMENTAL LOADING ------------------------------------
CREATE TABLE InvoicesVersionHistory (RecordOfVersion BIGINT, Date DATETIME);
	

----FOR INCREMENTAL LOADING ----------------------------------------------------------------


INSERT INTO InvoicesVersionHistory ([RecordOfVersion], [Date])
SELECT MAX([RecordOfVersion]), GETDATE()
FROM ChinookStaging.dbo.StagingInvoices;
GO

--------------------------------------------------------------------------------------------------------

select * 
into [ChinookDW].[dbo].DimDate
from [ChinookStaging].dbo.DimDate;

/*
alter table DimCustomer
	add foreign key(SupportRepId) references DimEmployee(EmployeeId) ;

alter table FactInvoices
	add foreign key(CustomerKey) references DimCustomer(CustomerKey) ;

alter table FactInvoices
	add foreign key(TrackId) references DimTrack(TrackId) ;

alter table DimPlaylist
	add foreign key(TrackId) references DimTrack(TrackId) ;

alter table dimDate
	add primary key  (DateKey) ;

	alter table FactInvoices
	add foreign key( InvoiceDateKey) references DimDate( DateKey) ;
*/
--mexri edw einai ok !


--ALTER TABLE [dbo].[DimCustomer] DROP CONSTRAINT [FK__DimCustom__Suppo__3A81B327]
--GO

--USE [ChinookDW]
--GO

--ALTER TABLE [dbo].[FactInvoices] DROP CONSTRAINT [FK__FactInvoi__Custo__3B75D760]
--GO




INSERT INTO [ChinookDW].[dbo].[DimEmployee]
           ([EmployeeId]
           ,[LastName]
           ,[FirstName]
           ,[Title]
           ,[ReportsTo]
           ,[BirthDate]
           ,[HireDate]
           ,[Address]
           ,[City]
           ,[State]
           ,[Country]
           ,[PostalCode]
           ,[Phone]
           ,[Fax]
           ,[Email])
	SELECT [EmployeeId]
      ,[LastName]
      ,[FirstName]
      ,[Title]
      ,[ReportsTo]
      ,[BirthDate]
      ,[HireDate]
      ,[Address]
      ,[City]
      ,[State]
      ,[Country]
      ,[PostalCode]
      ,[Phone]
      ,[Fax]
      ,[Email]
  FROM [ChinookStaging].[dbo].[StagingEmployee]
     
GO


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
GO


INSERT INTO [dbo].[DimTrack]
           ([TrackId]
           ,[TrackName]
           ,[AlbumId]
           ,[GenreId]
           ,[Composer]
           ,[Milliseconds]
           ,[Bytes]
           ,[UnitPrice]
           ,[AlbumTitle]
           ,[ArtistId]
           ,[ArtistName]
           ,[GenreName]
           ,[MediaTypeId]
           ,[MediaTypeName])
     SELECT
           [TrackId]
           ,[TrackName]
           ,[AlbumId]
           ,[GenreId]
           ,[Composer]
           ,[Milliseconds]
           ,[Bytes]
           ,[UnitPrice]
           ,[AlbumTitle]
           ,[ArtistId]
           ,[ArtistName]
           ,[GenreName]
           ,[MediaTypeId]
           ,[MediaTypeName]

	FROM [ChinookStaging].[dbo].[StagingTrack]

GO

INSERT INTO [dbo].[DimPlaylist]
           ([PlaylistId]
           ,[TrackId]
           ,[Name])
     SELECT
			[PlaylistId]
           ,[TrackId]
           ,[Name]
		FROM [ChinookStaging].[dbo].[StagingPlaylist] 


GO

----------INITIAL LOADING FOR FACT--------------------------------

INSERT INTO [dbo].[FactInvoices]
           ([InvoiceLineId]
           ,[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,[CustomerKey]
           ,[InvoiceDateKey]
           ,[BillingAddress]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingCountry]
           ,[BillingPostalCode]
           ,[Total])
     SELECT
           [InvoiceLineId]
           ,i.[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,c.[CustomerKey]
           ,d.[DateKey]
           ,i.[BillingAddress]
           ,i.[BillingCity]
           ,i.[BillingState]
           ,i.[BillingCountry]
           ,i.[BillingPostalCode]
           ,i.[Total]
	FROM [ChinookStaging].[dbo].[StagingInvoices] i
	inner join DimDate d on i.InvoiceDate = d.Date
	inner join DimCustomer c on CustomerKey = c.CustomerKey

	--SELECT * FROM FactInvoices;
GO


----------INCREMENTAL LOADING---------------

INSERT INTO [dbo].[FactInvoices]
           ([InvoiceLineId]
           ,[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,[CustomerKey]
           ,[InvoiceDateKey]
           ,[BillingAddress]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingCountry]
           ,[BillingPostalCode]
           ,[Total])
     SELECT
           [InvoiceLineId]
           ,i.[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,c.[CustomerKey]
           ,d.[DateKey]
           ,i.[BillingAddress]
           ,i.[BillingCity]
           ,i.[BillingState]
           ,i.[BillingCountry]
           ,i.[BillingPostalCode]
           ,i.[Total]
	FROM [ChinookStaging].[dbo].[StagingInvoices] i
	inner join DimDate d on i.InvoiceDate = d.Date
	inner join DimCustomer c on CustomerKey = c.CustomerKey
	WHERE [RecordOfVersion] >(SELECT MAX([RecordOfVersion]) FROM ChinookStaging.dbo.StagingInvoices);  --Incremental loading condition

	--SELECT * FROM FactInvoices;
GO

-- then, update Version history --

INSERT INTO ChinookDW.dbo.InvoicesVersionHistory(RecordOfVersion, Date)
SELECT MAX([RecordOfVersion]), GETDATE()
FROM ChinookStaging.dbo.StagingInvoices;

--END OF INCREMENTAL LOADING-------------------------------------------------------------

