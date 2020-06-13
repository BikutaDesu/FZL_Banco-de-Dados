USE master
DROP DATABASE IF EXISTS lojinha
CREATE DATABASE lojinha
GO
USE lojinha
GO

CREATE TABLE clientes (
	codigo				INT					NOT NULL	IDENTITY(33601,1),
	nome				VARCHAR(128)		NOT NULL,
	logradouro			VARCHAR(128)		NOT NULL,
	num_porta			INT					NOT NULL	CHECK(num_porta > 0 AND num_porta < 100000),
	telefone			CHAR(8)				NOT NULL	CHECK(LEN(telefone) = 8),
	data_nasc			DATETIME			NOT NULL,	CHECK(data_nasc < GETDATE()),
	PRIMARY KEY(codigo)
)

CREATE TABLE fornecedores (
	codigo				INT					NOT NULL	IDENTITY(1001,1),
	nome				VARCHAR(128)		NOT NULL,
	atividade			VARCHAR(32)			NOT NULL,
	telefone			CHAR(8)				NOT NULL	CHECK(LEN(telefone) = 8),
	PRIMARY KEY(codigo)
)

CREATE TABLE produtos (
	codigo				INT				NOT NULL	IDENTITY(1,1),
	nome				VARCHAR(128)	NOT NULL,
	valor_unitario		DECIMAL(7,2)	NOT NULL	CHECK(valor_unitario > 0.00),
	quantidade_estoque	INT				NOT NULL,
	descricao			VARCHAR(64)		NOT NULL,
	codigo_fornecedor	INT				NOT NULL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(codigo_fornecedor) REFERENCES fornecedores(codigo)
)

CREATE TABLE pedidos (
	codigo				INT				NOT NULL,
	codigo_cliente		INT				NOT NULL,
	codigo_produto		INT				NOT NULL,
	quantidade			INT				NOT NULL	CHECK(quantidade > 0),
	previsao_entrega	DATETIME		NOT NULL,
	PRIMARY KEY(codigo, codigo_cliente, codigo_produto),
	FOREIGN KEY(codigo_cliente) REFERENCES clientes(codigo),
	FOREIGN KEY(codigo_produto) REFERENCES produtos(codigo)
)

INSERT INTO clientes VALUES 
	('Maria Clara',		'R. 1° de Abril',			870,	'96325874', '1990-04-15'),
	('Alberto Souza',	'R. XV de Novembro',		987,	'95873625', '1975-02-27'),
	('Sonia Silva',		'R. Voluntários da Pátria', 1152,	'75418596', '1944-06-03'),
	('José Sobrinho',	'R. Paulista',				250,	'85236547', '1982-10-12'),
	('Carlos Camargo',	'R. Tiquatira',				9652,	'75896325', '1975-02-27')

INSERT INTO fornecedores VALUES 
	('Estrela',		'Brinquedo',				'41525898'),
	('Lacta',		'Chocolate',				'42698596'),
	('Asus',		'Informática',				'52014596'),
	('Tramontina',	'Utensílios Domésticos',	'50563985'),
	('Grow',		'Brinquedo',				'47896325'),
	('Mattel',		'Bonecos',					'59865898')

INSERT INTO produtos VALUES
	('Banco Imobiliário',		65.00,	15,	'Versão Super Luxo',		1001),
	('Puzzle 5000 peças',		50.00,	5,	'Mapas Mundo',				1005),
	('Faqueiro',				350.00,	0,	'120 peças',				1004),
	('Jogo para churrasco',		75.00,	3,	'7 peças',					1004),
	('Eee Pc',					750.00,	29,	'Netbook com 4Gb de HD',	1003),
	('Detetive',				49.00,	0,	'Nova Versão do Jogo',		1001),
	('Chocolate com paçoca',	6.00,	0,	'Barra',					1002),
	('Galak',					5.00,	65,	'Barra',					1002)

INSERT INTO pedidos VALUES
	(99001,	33601,	1,	1,	'2020-07-07'),
	(99001,	33601,	2,	1,	'2020-07-07'),
	(99001,	33601,	8,	3,	'2020-07-07'),
	(99002,	33602,	2,	1,	'2020-07-09'),
	(99002,	33602,	4,	3,	'2020-07-09'),
	(99003,	33605,	5,	1,	'2020-07-15')

--Codigo do produto, nome do produto, quantidade em estoque,								
--uma coluna dizendo se está baixo, bom ou confortável,								
--uma coluna dizendo o quanto precisa comprar para que o estoque fique minimamente confortável								

SELECT codigo, nome, quantidade_estoque,
	CASE 
		WHEN (quantidade_estoque > 20) THEN
			'CONFORTÁVEL'
		WHEN (quantidade_estoque > 10 AND quantidade_estoque <= 20) THEN
			'BOM'
		ELSE
			'BAIXO'
	END AS status_estoque,
	CASE
		WHEN (quantidade_estoque > 20) THEN
			0
		ELSE
			(21 - quantidade_estoque) 
	END AS quantidade_p_confortavel
FROM produtos

--Consultar o nome e o telefone dos fornecedores que não tem produtos cadastrados
SELECT f.nome, f.telefone FROM fornecedores f
LEFT OUTER JOIN produtos p
ON p.codigo_fornecedor = f.codigo
WHERE p.codigo_fornecedor IS NULL

--Consultar o nome e o telefone dos clientes que não tem pedidos cadastrados
SELECT c.nome, c.telefone FROM clientes c
LEFT OUTER JOIN pedidos p
ON p.codigo_cliente = c.codigo
WHERE p.codigo_cliente IS NULL

--Considerando a data do sistema, consultar o nome do cliente, 
--endereço concatenado com o número de porta
--o código do pedido e quantos dias faltam para a data prevista para a entrega
--criar, também, uma coluna que escreva ABAIXO para menos de 25 dias de previsão de entrega,
--ADEQUADO entre 25 e 30 dias e ACIMA para previsão superior a 30 dias
--as linhas de saída não devem se repetir e ordenar pela quantidade de dias

SELECT c.nome, c.logradouro + ', ' + CAST(c.num_porta AS VARCHAR(6)) AS endereco,
	p.codigo AS codigo_pedido, DATEDIFF(DAY, GETDATE(), p.previsao_entrega) AS dias_p_entrega,
	CASE 
		WHEN(DATEDIFF(DAY, GETDATE(), p.previsao_entrega) < 25) THEN
			'ABAIXO'
		WHEN(DATEDIFF(DAY, GETDATE(), p.previsao_entrega) > 25 AND DATEDIFF(DAY, GETDATE(), p.previsao_entrega) <= 30) THEN
			'ADEQUADO'
		WHEN(DATEDIFF(DAY, GETDATE(), p.previsao_entrega) > 30) THEN
			'ACIMA'
	END AS status_entrega
FROM clientes c
INNER JOIN pedidos p
ON p.codigo_cliente = c.codigo
GROUP BY p.codigo, c.nome, c.logradouro, c.num_porta, p.previsao_entrega
ORDER BY dias_p_entrega

--Consultar o Nome do cliente, o código do pedido, 		
--a soma do gasto do cliente no pedido e a quantidade de produtos por pedido		
--ordenar pelo nome do cliente		

SELECT c.nome, p.codigo, 
	CAST(SUM(pr.valor_unitario * p.quantidade) AS DECIMAL (7,2)) AS total_pedido, 
	SUM(p.quantidade) AS quantidade_produtos
FROM clientes c
INNER JOIN pedidos p
ON p.codigo_cliente = c.codigo
INNER JOIN produtos pr
ON pr.codigo = p.codigo_produto
GROUP BY c.nome, p.codigo
ORDER BY c.nome

--Consultar o Código e o nome do Fornecedor e 
--a contagem de quantos produtos ele fornece
SELECT f.codigo, f.nome, COUNT(p.codigo_fornecedor) AS quantidade_produtos
FROM fornecedores f
INNER JOIN produtos p
ON p.codigo_fornecedor = f.codigo
GROUP BY f.codigo, f.nome

--Consultar o nome e o telefone dos clientes que tem menos de 2 compras feitas
--A query não deve considerar quem fez 2 compras
SELECT c.nome, c.telefone FROM clientes c
INNER JOIN pedidos p
ON p.codigo_cliente = c.codigo
GROUP BY c.nome, c.telefone
HAVING COUNT(p.codigo_cliente) < 2

--Consultar o Codigo do pedido que tem o maior valor unitário de produto
SELECT p.codigo FROM pedidos p
INNER JOIN produtos pr
ON p.codigo_produto = pr.codigo
WHERE pr.valor_unitario IN 
	(SELECT MAX(valor_unitario) FROM produtos 
		INNER JOIN pedidos 
		ON pedidos.codigo_produto = produtos.codigo)

--Consultar o Codigo_Pedido, o Nome do cliente e o valor total da compra do pedido
--O valor total se dá pela somatória de valor_Unitário * quantidade comprada
SELECT p.codigo, c.nome, 
	CAST(SUM(pr.valor_unitario * p.quantidade) AS DECIMAL (7,2)) AS total_pedido
FROM pedidos p
INNER JOIN clientes c
ON p.codigo_cliente = c.codigo
INNER JOIN produtos pr
ON pr.codigo = p.codigo_produto
GROUP BY p.codigo, c.nome