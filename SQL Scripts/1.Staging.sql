USE MASTER 
GO

CREATE DATABASE ChinookStaging
GO

USE ChinookStaging
GO

CREATE TABLE [dbo].[StagingEmployee](
	[EmployeeId] [int] ,
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
	[Email] [nvarchar](60) NULL
	);


CREATE TABLE [dbo].[StagingTrack](
	[TrackId] [int] ,
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
	[MediaTypeName][nvarchar](120) NULL
	);

CREATE TABLE [dbo].[StagingInvoices](
	[InvoiceLineId] [int]  NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[TrackId] [int] NOT NULL,
	[UnitPrice] [numeric](10, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[BillingAddress] [nvarchar](70) NULL,
	[BillingCity] [nvarchar](40) NULL,
	[BillingState] [nvarchar](40) NULL,
	[BillingCountry] [nvarchar](40) NULL,
	[BillingPostalCode] [nvarchar](10) NULL,
	[Total] [numeric](10, 2) NOT NULL
	);

CREATE TABLE [dbo].[StagingPlaylist](
	[PlaylistId] [int] NOT NULL,
	[TrackId] [int] NOT NULL,
	[Name] [nvarchar](120) NULL
	);

CREATE TABLE [dbo].[StagingCustomer](
	[CustomerId] [int] NOT NULL,
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

	
ALTER TABLE ChinookStaging.dbo.StagingInvoices ADD RecordOfVersion ROWVERSION NOT NULL;

	USE [ChinookStaging]
GO



INSERT INTO [dbo].[StagingEmployee]
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
    SELECT
           [EmployeeId]
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
	FROM [Chinook].[dbo].[Employee]
GO

INSERT INTO [dbo].[StagingCustomer]
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
           ,[SupportRepId])
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
  FROM [Chinook].[dbo].[Customer]
GO


INSERT INTO [dbo].[StagingTrack]
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
           ,t.[Name]
           ,t.[AlbumId]
           ,t.[GenreId]
           ,[Composer]
           ,[Milliseconds]
           ,[Bytes]
           ,[UnitPrice]
           ,[Chinook].[dbo].[Album].[Title]
           ,[Chinook].[dbo].[Album].[ArtistId]
           ,[Chinook].[dbo].[Artist].[Name]
           ,[Chinook].[dbo].[Genre].[Name]
           ,[Chinook].[dbo].[MediaType].[MediaTypeId]
           ,[Chinook].[dbo].[MediaType].[Name]

	FROM [Chinook].[dbo].[Track] t 
	inner join [Chinook].[dbo].[Genre] On t.GenreId = [Chinook].[dbo].[Genre].[GenreId]
	inner join [Chinook].[dbo].[Album] On t.AlbumId = [Chinook].[dbo].[Album].[AlbumId]
	inner join [Chinook].[dbo].[Artist] On [Chinook].[dbo].[Album].ArtistId = [Chinook].[dbo].[Artist].[ArtistId]
	inner join [Chinook].[dbo].[MediaType] On t.MediaTypeId = [Chinook].[dbo].MediaType.[MediaTypeId]

GO

INSERT INTO [dbo].[StagingInvoices]
           ([InvoiceLineId]
           ,[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,[CustomerId]
           ,[InvoiceDate]
           ,[BillingAddress]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingCountry]
           ,[BillingPostalCode]
           ,[Total])
     SELECT
           [InvoiceLineId]
           ,[Chinook].[dbo].[Invoice].[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,[CustomerId]
           ,[InvoiceDate]
           ,[BillingAddress]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingCountry]
           ,[BillingPostalCode]
           ,[Total]
	FROM [Chinook].[dbo].[InvoiceLine]
		inner join [Chinook].[dbo].[Invoice] On [Chinook].[dbo].[Invoice].InvoiceId = [Chinook].[dbo].[InvoiceLine].InvoiceId
GO


INSERT INTO [dbo].[StagingPlaylist]
           ([PlaylistId]
           ,[TrackId]
           ,[Name])
     SELECT
          [Chinook].[dbo].[Playlist].[PlaylistId]
           ,[TrackId]
           ,[Name]
	FROM [Chinook].[dbo].[Playlist] 
		inner join [Chinook].[dbo].[PlaylistTrack] on [Chinook].[dbo].[PlaylistTrack].[PlaylistId] = [Chinook].[dbo].[Playlist].[PlaylistId]

GO

