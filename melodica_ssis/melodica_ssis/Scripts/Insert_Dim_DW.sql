select * 
into [ChinookDW].[dbo].DimDate
from [ChinookStaging].dbo.DimDate;


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
  FROM [ChinookStaging].[dbo].[StagingEmployee];
     
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

	FROM [ChinookStaging].[dbo].[StagingTrack];


INSERT INTO [dbo].[DimPlaylist]
           ([PlaylistId]
           ,[TrackId]
           ,[Name])
     SELECT
			[PlaylistId]
           ,[TrackId]
           ,[Name]
		FROM [ChinookStaging].[dbo].[StagingPlaylist] ;


