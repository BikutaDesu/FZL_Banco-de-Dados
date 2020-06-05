USE master
DROP DATABASE IF EXISTS selects
CREATE DATABASE selects
GO
USE selects
GO
 
CREATE TABLE funcionario(
id          INT				NOT NULL	IDENTITY(1,1),
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL	CHECK(numero > 0 AND numero < 100000),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL		CHECK(LEN(cep) = 8),
ddd         CHAR(2)         NULL		DEFAULT('11'),
telefone    CHAR(8)         NULL		CHECK(LEN(telefone) = 8),
data_nasc   DATETIME        NOT NULL	CHECK(data_nasc < GETDATE()),
salario     DECIMAL(7,2)    NOT NULL	CHECK(salario > 0.00)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL	IDENTITY(1001,1),
nome        VARCHAR(200)    NOT NULL	UNIQUE,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL,
CONSTRAINT chk_dt CHECK(data_fim > data_inicio),
PRIMARY KEY (id_funcionario, codigo_projeto),
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo)
)

--DBCC CHECKIDENT (nome_tabela, RESEED, novo_valor)
DBCC CHECKIDENT ('funcionario', RESEED, 0)
DBCC CHECKIDENT ('projeto', RESEED, 1001)
 
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',  'da Silva', 'R. Voluntários da Patria',    8150,   'Santana',  '05423110', '76895248', '05-15-1974',   4350.00),
('Cicrano', 'De Souza', 'R. Anhaia', 353,   'Barra Funda',  '03598770', '99568741', '08-25-1984',   1552.00),
('Beltrano',    'Dos Santos',   'R. ABC', 1100, 'Artur Alvim',  '05448000', '25639854', '06-02-1963',   2250.00)
 
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',  'De Souza', 'Avenida Águia de Haia', 4430, 'Artur Alvim',  '05448000', NULL,   NULL,   '10-15-1975',   2804.00)
 
INSERT INTO projeto VALUES
('Implantação de Sistemas ','Colocar o sistema no ar'),
('Implantação de Sistemas Novos','Colocar o sistema novo no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)
 
INSERT INTO funcproj VALUES
(1, 1001, '04-18-2015', '04-30-2015'),
(3, 1001, '04-18-2015', '04-30-2015'),
(1, 1002, '05-06-2015', '05-10-2015'),
(2, 1002, '05-06-2015', '05-10-2015'),
(3, 1003, '05-11-2015', '05-13-2015')