use master
DROP DATABASE IF EXISTS livraria
CREATE DATABASE livraria
GO
USE livraria
GO

CREATE TABLE clientes (
    codigo          INT             NOT NULL    IDENTITY(1001,1),
    nome            VARCHAR(128)    NOT NULL,
    logradouro      VARCHAR(128),
    num_porta       INT             CHECK(num_porta > 0 AND num_porta < 100000),
    telefone        CHAR(9)         CHECK(LEN(telefone) = 9),
    PRIMARY KEY(codigo)
)

CREATE TABLE corredores (
    codigo          INT             NOT NULL    IDENTITY(3251,1),
    tipo            VARCHAR(64)     NOT NULL,
    PRIMARY KEY(codigo)
)

CREATE TABLE autores (
    codigo          INT             NOT NULL    IDENTITY(10001,1),
    nome            VARCHAR(128)    NOT NULL,
    pais            VARCHAR(64)     NOT NULL,
    biografia       VARCHAR(256)    NOT NULL,
    PRIMARY KEY (codigo)
)

CREATE TABLE livros (
    codigo          INT             NOT NULL    IDENTITY(1,1),
    cod_autor       INT             NOT NULL,
    cod_corredor    INT             NOT NULL,
    nome            VARCHAR(128)    NOT NULL,
    pag             INT             NOT NULL,
    idioma          VARCHAR(32)     NOT NULL,
    PRIMARY KEY (codigo),
    FOREIGN KEY (cod_autor)     REFERENCES autores(codigo),
    FOREIGN KEY (cod_corredor)  REFERENCES corredores(codigo)
)

CREATE TABLE emprestimos (
    cod_cliente     INT             NOT NULL,
    cod_livro       INT             NOT NULL,
    data_emprestimo DATETIME        NOT NULL,
    PRIMARY KEY (cod_cliente, cod_livro),
    FOREIGN KEY (cod_cliente)   REFERENCES clientes(codigo),        
    FOREIGN KEY (cod_livro)     REFERENCES livros(codigo)
)

INSERT INTO autores VALUES
('Ramez E. Elmasri',                'EUA',      'Professor da Universidade do Texas'),
('Andrew Tannenbaum',               'Holanda',  'Desenvolvedor do Minix'),
('Diva Marília Flemming',           'Brasil',   'Professora Adjunta da UFSC'),
('David Halliday',                  'EUA',      'Ph.D. da University of Pittsburgh'),
('Marco Antonio Furlan de Souza',   'Brasil',   'Prof. do IMT'),
('Alfredo Steinbruch',              'Brasil',   'Professor de Matemática da UFRS e da PUCRS')

INSERT INTO clientes VALUES
('Luis Augusto',        'R. 25 de Março',           250,    '996529632'),
('Maria Luisa',         'R. XV de Novembro',        890,    '998526541'),
('Claudio Batista',     'R. Anhaia',                112,    '996547896'),
('Wilson Mendes',       'R. do Hipódromo',          1250,   '991254789'),
('Ana Maria',           'R. Augusta',               896,    '999365589'),
('Cinthia Souza',       'R. Voluntários da Pátria', 1023,   '984256398'),
('Luciano Brito',       NULL,                       NULL,   '995678556'),
('Antônio do Valle',    'R. Sete de Setembro',      1894,   NULL)

INSERT INTO corredores VALUES 
('Informática'),
('Matemática'),
('Física'),
('Química')

INSERT INTO livros VALUES
(10001, 3251, 'Sistemas de Banco de Dados',                 720,    'Português'),
(10002, 3251, 'Sistemas Operacionais Modernos',             580,    'Português'),
(10003, 3252, 'Cálculo A',                                  290,    'Português'),
(10004, 3253, 'Fundamentos de Física I',                    185,    'Português'),
(10005, 3251, 'Algoritmos e Lógica de Programação',         90,     'Português'),
(10006, 3252, 'Geometria Analítica',                        75,     'Português'),
(10004, 3253, 'Fundamentos de Física II',                   150,    'Português'),
(10002, 3251, 'Redes de Computadores',                      493,    'Inglês'),
(10002, 3251, 'Organização Estruturada de Computadores',    576,    'Português')

INSERT INTO emprestimos VALUES
(1001, 1, '2012-05-10 00:00:00.000'),
(1001, 2, '2012-05-10 00:00:00.000'),
(1001, 8, '2012-05-10 00:00:00.000'),
(1002, 4, '2012-05-11 00:00:00.000'),
(1002, 7, '2012-05-11 00:00:00.000'),
(1003, 3, '2012-05-12 00:00:00.000'),
(1004, 5, '2012-05-14 00:00:00.000'),
(1001, 9, '2012-05-15 00:00:00.000')

--  Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada 
--padrão BR (dd/mm/yyyy)
SELECT c.nome, e.data_emprestimo FROM clientes c
INNER JOIN emprestimos e
ON e.cod_cliente = c.codigo
GROUP BY c.nome, e.data_emprestimo

--  Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por 
--Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 
--caracteres, mostrar só os 13 primeiros.
SELECT CASE
    WHEN(LEN(a.nome) > 15) THEN
        SUBSTRING(a.nome, 1, 13) + '...'
    ELSE
        a.nome
    END AS nome, COUNT(l.cod_autor) AS quantidade_livros 
FROM autores a 
INNER JOIN livros l
ON l.cod_autor = a.codigo
GROUP BY a.nome
ORDER BY quantidade_livros

--  Fazer uma consulta que retorne o nome do autor e o país de origem do livro com 
--maior número de páginas cadastrados no sistema
SELECT a.nome, a.pais FROM autores a 
INNER JOIN livros l 
ON l.cod_autor = a.codigo
WHERE l.pag IN (SELECT MAX(l.pag) FROM livros l)

--  Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem 
--livros emprestados
SELECT c.nome + ' - ' + c.logradouro  
FROM clientes c
INNER JOIN emprestimos e
ON e.cod_cliente = c.codigo
GROUP BY c.nome, c.logradouro

/*
    Nome dos Clientes, sem repetir e, concatenados como enderço_telefone, o 
logradouro, o numero e o telefone) dos clientes que Não pegaram livros. 
    Se o logradouro e o número forem nulos e o telefone não for nulo, mostrar 
só o telefone. 
    Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só 
logradouro e número. Se os três existirem, mostrar os três.
    O telefone deve estar mascarado XXXXX-XXXX
*/
SELECT c.nome, 
    (CASE WHEN (c.logradouro IS NOT NULL) THEN
        c.logradouro
    ELSE
        + ''
    END 
    + CASE WHEN (c.num_porta IS NOT NULL) THEN
        ', ' + CAST(c.num_porta AS VARCHAR(6)) + ', '
    ELSE
        + ''
    END  
        + CASE WHEN (c.telefone IS NOT NULL) THEN
            (SUBSTRING(c.telefone, 1, 5) + '-' 
            + SUBSTRING(c.telefone, 6, 9))  
        ELSE
            + ''
    END) AS endenreco_telefone
FROM clientes c
LEFT OUTER JOIN emprestimos e
ON e.cod_cliente = c.codigo
WHERE e.cod_cliente IS NULL
GROUP BY c.nome, c.logradouro, c.num_porta, c.telefone
    
--  Fazer uma consulta que retorne Quantos livros não foram emprestados.
SELECT COUNT(l.codigo) FROM livros l
LEFT OUTER JOIN emprestimos e
ON e.cod_livro = l.codigo
WHERE e.cod_livro IS NULL

--  Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, 
--ordenados por quantidade de livro.
SELECT a.nome, c.tipo, COUNT(l.cod_autor) AS qtd_livros FROM autores a
INNER JOIN livros l
ON l.cod_autor = a.codigo
INNER JOIN corredores c
ON l.cod_corredor = c.codigo
GROUP BY a.nome, l.cod_corredor, c.tipo

--  Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do 
--cliente, o nome do livro, o total de dias que cada um está com o livro e, uma 
--coluna que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', 
--caso contrário, apresente 'No Prazo'
SELECT c.nome, l.nome, DATEDIFF(DAY, e.data_emprestimo, '2012-05-18'),
    CASE
        WHEN(DATEDIFF(DAY, e.data_emprestimo, '2012-05-18') > 4) THEN
            'Atrasado'
        ELSE
            'No Prazo'
    END AS status_emprestimo
FROM clientes c
INNER JOIN emprestimos e
ON e.cod_cliente = c.codigo
INNER JOIN livros l
ON e.cod_livro = l.codigo
GROUP BY c.nome, l.nome, e.data_emprestimo

--  Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos 
--livros tem em cada corredor
SELECT c.codigo, c.tipo, COUNT(l.cod_corredor) AS qtd_livros FROM corredores c
INNER JOIN livros l
ON l.cod_corredor = c.codigo
GROUP BY c.codigo, c.tipo

--  Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros 
--cadastrado é maior ou igual a 2.
SELECT a.nome, COUNT(l.codigo) FROM autores a
INNER JOIN livros l
ON a.codigo = l.cod_autor
GROUP BY a.nome
HAVING COUNT(l.codigo) >= 2 
ORDER BY a.nome ASC 

--  Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do 
--cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT c.nome, l.nome FROM clientes c
INNER JOIN emprestimos e
ON e.cod_cliente = c.codigo
INNER JOIN livros l
ON e.cod_livro = l.codigo
GROUP BY c.nome, l.nome, e.data_emprestimo
HAVING DATEDIFF(DAY, e.data_emprestimo, '2012-05-18') >= 7