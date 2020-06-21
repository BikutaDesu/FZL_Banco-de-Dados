--	CTRL + R fecha o console
--	Comentario de linha

/*
	Comentario de bloco
*/

--	Criando o banco
CREATE DATABASE exercicioCRUD

--	Selecionando o banco
USE exercicioCRUD

/*
	Apagando o banco
	Não é possível apagar um banco que esteja em uso
	É necessário dar USE outroBanco
	DROP DATABASE exercicioCRUD
*/

/*
	Para criar um banco e já selecionar ele é só fazer
	O GO serve para sincronizar a execução, ele vai esperar criar o banco para depois seleciona-lo
	CREATE DATABASE meuBanco
	GO
	USE meuBanco
*/

--	Criando tabelas
/*
	A criação de tabalas deve seguir a seguinte ordem
	1º todas as tabelas em chave estrangeira
	2º todas as tabelas que possuem chave estrangeira
	3º todas as tabelas associativas
*/
	CREATE TABLE tbClientes (
		idCliente		INTEGER			NOT NULL,
		nomeCliente		VARCHAR(100)	NOT NULL,
		dtNascCLiente	DATE			NOT NULL
		PRIMARY KEY (idCliente)
	)

	--	Espera para criação da próxima tabela
	GO

	CREATE TABLE tbProdutos (
		idProduto		INTEGER			NOT NULL,
		nomeProduto		VARCHAR(50)		NOT NULL,
		valorUnProduto	DECIMAL(7,2)	NOT NULL
		PRIMARY KEY(idProduto)
	)

	GO

	CREATE TABLE tbCompras(
		idCliente		INT				NOT NULL,
		idProduto		INT				NOT NULL,
		dataHrCompra	DATETIME		NOT NULL,
		valorTCompra	DECIMAL(7,2)	NOT NULL
		PRIMARY KEY (idCliente, idProduto)
		FOREIGN KEY (idCliente) REFERENCES tbClientes(idCliente),
		FOREIGN KEY (idProduto) REFERENCES tbProdutos(idProduto)
	)

--	Caracteristicas das tabelas
	EXEC sp_help tbClientes
	EXEC sp_help tbProdutos
	EXEC sp_help tbCompras

--	Modificar uma tabela já existente
	ALTER TABLE tbClientes
	ADD telefoneCliente	CHAR(11)

--	ALTER COLUMN muda o TIPO, mas não o nome da coluna
	ALTER TABLE tbClientes
	ALTER COLUMN telefoneCliente	CHAR(10)

--	(NADA RECOMENDADO) Modificando nome da coluna (serve para tabela também)
	EXEC sp_rename 'dbo.tbClientes.telefoneCliente', 'telCliente', 'column'

--	Removendo uma coluna
	ALTER TABLE tbClientes
	DROP COLUMN telCliente

--	Adicionando uma chave estrangeira ou primária
	ALTER TABLE tbCompras
	ADD PRIMARY KEY (idCliente, idProcuto)

	ALTER TABLE tbCompras
	ADD FOREIGN KEY (idCliente) REFERENCES tbClientes (idCliente)

--	Removendo uma tabela
/*
	Se alguma tabela tiver uma chave estrangeira vinculada com a que será excluida, não será possível a exclusão
*/
DROP TABLE tbClientes 

--	CRUD
--	R - READ
	SELECT * FROM tbClientes
	SELECT * FROM tbProdutos
	SELECT * FROM tbCompras

--	C - CREATE(INSERT)
	--	Forma de data padrão do SQLServer (yyyy-mm-dd)
	INSERT INTO tbClientes
		VALUES (1001, 'Fulano de Tal', '1995-04-18')

	--	Inserção fora de ordem
	INSERT INTO tbClientes (dtNascCliente, nomeCliente, idCliente)
		VALUES ('1995-04-18', 'Ciclano de Tal', 1003)

	--	Dado NULL
	--	Vai dar erro, pois todas as colunas estão como NOT NULL
	INSERT INTO tbClientes
		VALUES (1002, 'Beltrano de Tal')

	--	Inserindo 'TUDO DUMA VEZ'
	INSERT INTO tbProdutos VALUES
	(1, 'Borracha', 0.50),
	(2, 'Caneta', 1.50),
	(3, 'Lapiseria', 5.00)

--	U - UPDATE
	UPDATE tbProdutos
	SET valorUnProduto = 10.50
	WHERE idProduto = 3

	UPDATE tbProdutos
	SET nomeProduto = 'Caneta Azul', valorUnProduto = 1.85
	WHERE idProduto = 2

	UPDATE tbProdutos
	SET valorUnProduto = 0.99
	WHERE nomeProduto = 'Borracha' AND valorUnProduto = 0.50 

	--	Deu a louca no gerente, 10% de desconto em tudo
	UPDATE tbProdutos
	SET valorUnProduto = valorUnProduto * 0.9

	UPDATE tbProdutos 
	SET valorUnProduto = valorUnProduto * 1.1
	WHERE valorUnProduto <= 2.0 OR valorUnProduto >= 8.0
	--	Diferente != ou <>

	-- Inserindo numa tabela associativa
	INSERT INTO tbCompras
	VALUES (1001, 1, '2020-05-10 12:00', 0.98)

	INSERT INTO tbCompras
	VALUES (1001, 2, '2020-05-10 12:00', 1.84)

--	D - Delete 
	DELETE tbClientes
	WHERE idCliente = 1003

--	DROP & CREATE TABLE
	TRUNCATE TABLE tbCompras