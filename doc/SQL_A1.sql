IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'RaceDayDB')
BEGIN
    CREATE DATABASE RaceDayDB;
END;
GO

USE RaceDayDB;
GO

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;

CREATE TABLE dbo.Roles (
    RoleID INT IDENTITY(1,1) NOT NULL,
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT PK_Roles PRIMARY KEY (RoleID)
);

CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) NOT NULL,
    RoleID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID) ON DELETE CASCADE
);

CREATE TABLE dbo.Events (
    EventID INT IDENTITY(1,1) NOT NULL,
    CreatedByUserID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Description VARCHAR(MAX) NULL,
    EventDate DATETIME2 NOT NULL,
    Location VARCHAR(150) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Events PRIMARY KEY (EventID),
    CONSTRAINT FK_Events_Users FOREIGN KEY (CreatedByUserID) REFERENCES dbo.Users(UserID)
);

CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) NOT NULL,
    EventID INT NOT NULL,
    CategoryName VARCHAR(50) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    MaxParticipants INT DEFAULT 100 NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID) REFERENCES dbo.Events(EventID) ON DELETE CASCADE
);

CREATE TABLE dbo.Enrolments (
    EnrolmentID INT IDENTITY(1,1) NOT NULL,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Enrolments PRIMARY KEY (EnrolmentID),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
    CONSTRAINT UQ_User_Category UNIQUE (UserID, CategoryID)
);

CREATE TABLE dbo.Results (
    ResultID INT IDENTITY(1,1) NOT NULL,
    EnrolmentID INT NOT NULL UNIQUE,
    CompletionTime TIME(7) NOT NULL,
    Position INT NULL,
    CONSTRAINT PK_Results PRIMARY KEY (ResultID),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) REFERENCES dbo.Enrolments(EnrolmentID) ON DELETE CASCADE
);
GO

INSERT INTO dbo.Roles (RoleName) 
VALUES ('Organiser'), ('Participant');

INSERT INTO dbo.Users (RoleID, FirstName, LastName, Email, PasswordHash) VALUES 
(1, 'Sarah', 'Conner', 'sarah.c@raceday.com', 'hashed_pass_1'),
(1, 'Michael', 'Scott', 'michael.s@raceday.com', 'hashed_pass_2'),
(2, 'Alice', 'Smith', 'alice.smith@gmail.com', 'hashed_pass_3'),
(2, 'Bob', 'Jones', 'bob.jones@gmail.com', 'hashed_pass_4');

INSERT INTO dbo.Events (CreatedByUserID, Title, Description, EventDate, Location) VALUES 
(1, 'Cape Town Marathon 2026', 'Annual city marathon challenge.', '2026-10-15 06:00:00', 'Cape Town'),
(1, 'Table Mountain Trail Run', 'Off-road trail run up Table Mountain.', '2026-11-20 07:00:00', 'Cape Town'),
(2, 'Durban Coastal Cycle', 'Scenic coastal cycling event.', '2026-12-05 08:00:00', 'Durban');

INSERT INTO dbo.Categories (EventID, CategoryName, DistanceKm, MaxParticipants) VALUES 
(1, 'Full Marathon', 42.20, 500),
(1, 'Half Marathon', 21.10, 1000),
(2, '10K Trail Peak', 10.00, 200),
(3, '50K Road Cycle', 50.00, 300);

INSERT INTO dbo.Enrolments (UserID, CategoryID) VALUES 
(3, 1),
(3, 3),
(4, 1),
(4, 4);

INSERT INTO dbo.Results (EnrolmentID, CompletionTime, Position) VALUES 
(1, '03:45:12', 1),
(3, '04:10:05', 2);
GO