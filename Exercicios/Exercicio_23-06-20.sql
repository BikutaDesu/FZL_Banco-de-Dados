use master
DROP DATABASE IF EXISTS loja_ex_23_03
CREATE DATABASE loja_ex_23_03
GO
USE loja_ex_23_03
GO

CREATE TABLE clientes (
    cpf             CHAR(11)        NOT NULL,
    nome            VARCHAR(128)    NOT NULL,
    telefone        CHAR(9)         NOT NULL    CHECK(LEN(telefone) >= 8)
    PRIMARY KEY(cpf)
)

CREATE TABLE fornecedores (
    codigo          INTEGER         NOT NULL    IDENTITY(1,1),
    nome            VARCHAR(128)    NOT NULL,
    logradouro      VARCHAR(128)    NOT NULL,
    numero          CHAR(6)         NOT NULL,
    complemento     VARCHAR(64)     NOT NULL,
    cidade          VARCHAR(64)     NOT NULL
    PRIMARY KEY(codigo)
)

CREATE TABLE produtos (
    codigo          INTEGER         NOT NULL    IDENTITY(1,1),
    descricao       VARCHAR(MAX)    NOT NULL,
    cod_fornecedor  INTEGER         NOT NULL,
    preco           DECIMAL(7,2)    NOT NULL    CHECK(preco > 0)
    PRIMARY KEY(codigo)
    FOREIGN KEY (cod_fornecedor) REFERENCES fornecedores(codigo)
)

CREATE TABLE vendas (
    codigo          INTEGER         NOT NULL,
    cod_produto     INTEGER         NOT NULL,
    cpf_cliente     CHAR(11)        NOT NULL,
    quantidade      INTEGER         NOT NULL    CHECK(quantidade > 0),
    valor_total     DECIMAL(7,2)    NOT NULL    CHECK(valor_total > 0),
    data_venda      DATETIME        NOT NULL    CHECK(data_venda < GETDATE())
    PRIMARY KEY(codigo, cod_produto, cpf_cliente, data_venda)
    FOREIGN KEY (cod_produto) REFERENCES produtos(codigo),
    FOREIGN KEY (cpf_cliente) REFERENCES clientes(cpf)
)

INSERT INTO clientes VALUES 
('25186533710',     'Maria Antonia',    '87652314'),
('34578909290',     'Julio Cesar',      '82736541'),
('79182639800',     'Paulo Cesar',      '90765273'),
('87627315416',     'Luiz Carlos',      '61289012'),
('36587498700',     'Paula Carla',      '23547888')

INSERT INTO fornecedores VALUES 
('LG',          'Rod. Bandeirantes', '70000', 'Km 70',      'Itapeva'),
('Asus',        'Av. Nações Unidas', '10206', 'Sala 255',   'São Paulo'),
('AMD',         'Av. Nações Unidas', '10206', 'Sala 1095',  'São Paulo'),
('Leadership',  'Av. Nações Unidas', '10206', 'Sala 87',    'São Paulo'),
('Inno',        'Av. Nações Unidas', '10206', 'Sala 34',    'São Paulo'),
('Kingston',    'Av. Nações Unidas', '10206', 'Sala 18',    'São Paulo')

INSERT INTO produtos VALUES
('Monitor 19 pol.',                         1, 449.99),
('Zenfone',                                 2, 1599.99),
('Gravador de DVD - Sata',                  1, 99.99),
('Leitor de CD',                            1, 49.99),
('Processador - Ryzen 5',                   3, 599.99),
('Mouse',                                   4, 19.99),
('Teclado',                                 4, 25.99),
('Placa de Video - RTX 2060',               2, 2399.99),
('Pente de Memória 4GB DDR 4 2400 MHz',     5, 259.99)

INSERT INTO vendas VALUES 
(1, 1, '25186533710', 1, 449.99,    '2009-09-03'),
(1, 4, '25186533710', 1, 49.99,     '2009-09-03'),
(1, 5, '25186533710', 1, 349.99,    '2009-09-03'),
(2, 6, '79182639800', 4, 79.96,     '2009-09-06'),
(3, 3, '87627315416', 1, 99.99,     '2009-09-06'),
(3, 7, '87627315416', 1, 25.99,     '2009-09-06'),
(3, 8, '87627315416', 1, 599.99,    '2009-09-06'),
(4, 2, '34578909290', 2, 1399.98,   '2009-09-08')

--  Quantos produtos não foram vendidos ?
SELECT COUNT(p.codigo) AS produtos_n_vendidos FROM produtos p
LEFT OUTER JOIN vendas v
ON v.cod_produto = p.codigo
WHERE v.cod_produto IS NULL

--  Nome do produto, Nome do fornecedor, count() do produto nas vendas
SELECT p.descricao AS produto, f.nome AS fornecedor, COUNT(p.codigo) AS qtd_prod_vendas FROM produtos p
INNER JOIN fornecedores f
ON f.codigo = p.cod_fornecedor
INNER JOIN vendas v
ON v.cod_produto = p.codigo
WHERE v.cod_produto = p.codigo
GROUP BY p.descricao, f.nome, v.quantidade

--  Nome do cliente e Quantos produtos cada um comprou ordenado pela 
--quantidade
SELECT c.nome, COUNT(c.cpf) AS produtos_comprados FROM clientes c
INNER JOIN vendas v 
ON v.cpf_cliente = c.cpf
GROUP BY c.nome, c.cpf
ORDER BY produtos_comprados DESC

--  Nome do produto e Quantidade de vendas do produto com menor valor 
--do catálogo de produtos
SELECT p.descricao, COUNT(p.codigo) AS qtd_vendas FROM produtos p
INNER JOIN vendas v
ON v.cod_produto = p.codigo
WHERE p.preco IN (SELECT MIN(p.preco) FROM produtos p)
GROUP BY p.descricao

--  Nome do Fornecedor e Quantos produtos cada um fornece
SELECT f.nome AS fornecedor, COUNT(p.cod_fornecedor) AS qtd_produtos FROM fornecedores f
INNER JOIN produtos p
ON p.cod_fornecedor = f.codigo
GROUP BY f.nome

--  Considerando que hoje é 20/10/2009, consultar o código da compra, 
--nome do cliente, telefone do cliente e quantos dias da data da compra
SELECT v.codigo, c.nome, c.telefone, DATEDIFF(DAY, v.data_venda, '2009-10-20') AS dias_compra
FROM vendas v
INNER JOIN clientes c
ON v.cpf_cliente = c.cpf
GROUP BY v.codigo, c.nome, c.telefone, v.data_venda

--  CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e 
--quantidade que comprou mais de 2 produtos
SELECT SUBSTRING(c.cpf, 1,3) + '.' + SUBSTRING(c.cpf, 4,3) + '.' 
    + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf, c.nome, 
    COUNT(v.cpf_cliente) AS qtd_prod_comprados FROM clientes c
INNER JOIN vendas v
ON v.cpf_cliente = c.cpf
GROUP BY c.cpf, c.nome
HAVING COUNT(v.cpf_cliente) > 2

--  CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma 
--do valor_total gasto
SELECT SUBSTRING(c.cpf, 1,3) + '.' + SUBSTRING(c.cpf, 4,3) + '.' 
    + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf, c.nome, 
    SUM(v.valor_total) AS total_gasto FROM clientes c
INNER JOIN vendas v
ON v.cpf_cliente = c.cpf
GROUP BY c.cpf, c.nome

--  Código da compra, data da compra em formato (DD/MM/AAAA) e uma coluna, 
--chamada dia_semana, que escreva o dia da semana por extenso
--      Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever 
--segunda-feira, assim por diante, até caso dia 7, escrever sábado
SELECT v.codigo AS codigo_compra, CONVERT(CHAR(10), v.data_venda, 103) 
    AS data_compra, CASE
    WHEN (DAY(v.data_venda) % 7 = 1) THEN
        'Domingo'
    WHEN (DAY(v.data_venda) % 7 = 2) THEN
        'Segunda-Feira'
    WHEN (DAY(v.data_venda) % 7 = 3) THEN
        'Terça-Feira'
    WHEN (DAY(v.data_venda) % 7 = 4) THEN
        'Quarta-Feira'
    WHEN (DAY(v.data_venda) % 7 = 5) THEN
        'Quinta-Feira'
    WHEN (DAY(v.data_venda) % 7 = 6) THEN
        'Sexta-Feira'
    WHEN (DAY(v.data_venda) % 7 = 0) THEN
        'Sábado'
    END AS dia_semana FROM vendas v
GROUP BY v.codigo, v.data_venda
