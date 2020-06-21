--	Feito por: Victor da Silva Neves
--	Data: 12/05/2020

--	Criar uma database Livraria, com as tabelas, conforme DER abaixo
CREATE DATABASE dbLivraria
GO
USE dbLivraria

CREATE TABLE tbLivro (
	idLivro		INTEGER			NOT NULL,
	nomeLivro	VARCHAR(100)		NULL,
	linguaLivro	VARCHAR(50)		NULL,
	anoLivro	INTEGER			NULL,
	PRIMARY KEY (idLivro)
)

GO

CREATE TABLE tbAutor (
	idAutor			INTEGER			NOT NULL,
	nomeAutor		VARCHAR(100)		NULL,
	dataNascAutor		DATE			NULL,
	paisAutor		VARCHAR(50)		NULL,
	biografiaAutor		VARCHAR(MAX)		NULL
	PRIMARY KEY(idAutor)
)

GO

CREATE TABLE tbEdicao(
	ISBN			INTEGER			NOT NULL,
	precoEdicao		DECIMAL(7,2)		NULL,
	ano			INTEGER			NULL,
	numPagEdicao		INTEGER			NULL,
	qtdEstoque		INTEGER			NULL,
	PRIMARY KEY(ISBN)
)

GO

CREATE TABLE tbEditora(
	idEditora		INTEGER			NOT NULL,
	nomeEditora		VARCHAR(50)		NULL,
	logradouroEditora	VARCHAR(255)		NULL,
	numeroEditora		INTEGER			NULL,
	CEPEditora		CHAR(8)			NULL,
	telefoneEditora		CHAR(11)		NULL,
	PRIMARY KEY(idEditora)
)

GO

CREATE TABLE tbLivro_Autor(
	idLivro INTEGER NOT NULL,
	idAutor	INTEGER NOT NULL,
	PRIMARY KEY(idLivro, idAutor),
	FOREIGN KEY(idLivro) REFERENCES tbLivro(idLivro),
	FOREIGN KEY(idAutor) REFERENCES tbAutor(idAutor)
)

GO

CREATE TABLE tbLivro_Edicao_Editora(
	ISBN		INTEGER NOT NULL,
	idEditora	INTEGER NOT NULL,
	idLivro		INTEGER NOT NULL,
	PRIMARY KEY (ISBN, idEditora, idLivro),
	FOREIGN KEY (ISBN) REFERENCES tbEdicao(ISBN),
	FOREIGN KEY (idEditora) REFERENCES tbEditora(idEditora),
	FOREIGN KEY (idLivro) REFERENCES tbLivro(idLivro)
)

GO

--	Modificar o nome da coluna ano da tabela edicoes, para AnoEdicao
EXEC sp_rename 'dbo.tbEdicao.ano', 'anoEdicao', 'column'

GO

--	Modificar o tamanho do varchar do Nome da editora de 50 para 30
ALTER TABLE tbEditora
ALTER COLUMN nomeEditora VARCHAR(30) NULL

--	Modificar o tipo da coluna ano da tabela autor para int
ALTER TABLE tbAutor
DROP COLUMN dataNascAutor

ALTER TABLE tbAutor
ADD anoNascAutor INTEGER NULL

GO

--	Inserir os dados
INSERT INTO tbLivro VALUES
(1001, 'CCNA 4.1',				'PT-BR',	2015), 
(1002, 'HTML 5',				'PT-BR',	2017),
(1003, 'Redes de Computadores',	'EN',		2010),
(1004, 'Android em Ação',		'PT-BT',	2018)

INSERT INTO tbAutor(idAutor, nomeAutor, anoNascAutor, paisAutor, biografiaAutor) VALUES
(10001, 'Inácio da Silva',		1975, 'Brasil', 'Programador WEB desde 1995'),
(10002, 'Andrew Tannenbau,',	1975, 'EUA',	'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij'),
(10003, 'Luis Rocha',			1975, 'Brasil', 'Programador desde 2000'),
(10004, 'David Halliday',		1975, 'EUA',	'Físico PH.D desde 1941')

INSERT INTO tbLivro_Autor VALUES
(1001, 10001),
(1002, 10003),
(1003, 10002),
(1004, 10003)

INSERT INTO tbEdicao VALUES
(0130661023, 189.99, 2018, 653, 10)

--	A universidade do Prof. Tannenbaum chama-se Vrije e não Vrij, modificar
UPDATE tbAutor
SET biografiaAutor = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
WHERE idAutor = 10002

--	A livraria vendeu 2 unidades do livro 0130661023, atualizar
UPDATE tbEdicao
SET qtdEstoque = qtdEstoque - 2
WHERE ISBN = 0130661023

DELETE tbAutor
WHERE idAutor = 10004

SELECT * FROM tbEdicao
