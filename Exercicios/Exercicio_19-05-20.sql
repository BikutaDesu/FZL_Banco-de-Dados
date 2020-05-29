USE master 

DROP DATABASE IF EXISTS exercicioConstraints

CREATE DATABASE exercicioConstraints
GO
USE exercicioConstraints
GO

CREATE TABLE users (
	id				INTEGER			NOT NULL IDENTITY(1, 1),
	name			VARCHAR(45)		NOT NULL,
	username		VARCHAR(45)		NOT NULL UNIQUE,
	password		VARCHAR(45)		NOT NULL DEFAULT('123mudar'),
	email			VARCHAR(45)		NOT NULL
	PRIMARY KEY(id)
	
)

CREATE TABLE projects (
	id				INTEGER			NOT NULL IDENTITY(10001, 1),
	name			VARCHAR(45)		NOT NULL,
	description		VARCHAR(45)		NOT NULL,
	date			DATE			NOT NULL CHECK(date > '09-01-2014') 
	PRIMARY KEY(id)
)

CREATE TABLE users_has_projects (
	users_id		INTEGER			NOT NULL,
	projects_id		INTEGER			NOT NULL
	PRIMARY KEY(users_id, projects_id)
	FOREIGN KEY (users_id)		REFERENCES users(id),
	FOREIGN KEY (projects_id)	REFERENCES projects(id)
)

ALTER TABLE users
DROP COLUMN username