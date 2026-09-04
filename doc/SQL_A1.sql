-- 1. Create Database if it doesn't exist
CREATE DATABASE IF NOT EXISTS RaceDayDB;
USE RaceDayDB;

-- 2. Drop Tables if re-running cleanly 
DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Enrolments;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Roles;

-- 3. Create Tables
CREATE TABLE Roles (
    RoleID INT AUTO_INCREMENT NOT NULL,
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT PK_Roles PRIMARY KEY (RoleID)
);

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT NOT NULL,
    RoleID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE
);

CREATE TABLE Events (
    EventID INT AUTO_INCREMENT NOT NULL,
    CreatedByUserID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Description TEXT NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(150) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT PK_Events PRIMARY KEY (EventID),
    CONSTRAINT FK_Events_Users FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT NOT NULL,
    EventID INT NOT NULL,
    CategoryName VARCHAR(50) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    MaxParticipants INT DEFAULT 100 NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

CREATE TABLE Enrolments (
    EnrolmentID INT AUTO_INCREMENT NOT NULL,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT PK_Enrolments PRIMARY KEY (EnrolmentID),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_User_Category UNIQUE (UserID, CategoryID)
);

CREATE TABLE Results (
    ResultID INT AUTO_INCREMENT NOT NULL,
    EnrolmentID INT NOT NULL UNIQUE,
    CompletionTime TIME NOT NULL,
    Position INT NULL,
    CONSTRAINT PK_Results PRIMARY KEY (ResultID),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID) ON DELETE CASCADE
);

-- 4. Insert Seed Data
INSERT INTO Roles (RoleName) 
VALUES ('Organiser'), ('Participant');

INSERT INTO Users (RoleID, FirstName, LastName, Email, PasswordHash) VALUES 
(1, 'Sarah', 'Conner', 'sarah.c@raceday.com', 'hashed_pass_1'),
(1, 'Michael', 'Scott', 'michael.s@raceday.com', 'hashed_pass_2'),
(2, 'Alice', 'Smith', 'alice.smith@gmail.com', 'hashed_pass_3'),
(2, 'Bob', 'Jones', 'bob.jones@gmail.com', 'hashed_pass_4');

INSERT INTO Events (CreatedByUserID, Title, Description, EventDate, Location) VALUES 
(1, 'Cape Town Marathon 2026', 'Annual city marathon challenge.', '2026-10-15 06:00:00', 'Cape Town'),
(1, 'Table Mountain Trail Run', 'Off-road trail run up Table Mountain.', '2026-11-20 07:00:00', 'Cape Town'),
(2, 'Durban Coastal Cycle', 'Scenic coastal cycling event.', '2026-12-05 08:00:00', 'Durban');

INSERT INTO Categories (EventID, CategoryName, DistanceKm, MaxParticipants) VALUES 
(1, 'Full Marathon', 42.20, 500),
(1, 'Half Marathon', 21.10, 1000),
(2, '10K Trail Peak', 10.00, 200),
(3, '50K Road Cycle', 50.00, 300);

INSERT INTO Enrolments (UserID, CategoryID) VALUES 
(3, 1),
(3, 3),
(4, 1),
(4, 4);

INSERT INTO Results (EnrolmentID, CompletionTime, Position) VALUES 
(1, '03:45:12', 1),
(3, '04:10:05', 2);

-- 5. Verification Queries
SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM Enrolments;
SELECT * FROM Results;
