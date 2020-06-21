--Consultas:
--Select Simples funcionario
SELECT id, nome, sobrenome, logradouro, numero, bairro, salario
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva%'

--Select Simples funcionario(s) Souza
SELECT id, nome, sobrenome, logradouro, numero, bairro, salario
FROM funcionario
WHERE sobrenome LIKE '%Souza%'

--Id e Nome Concatenado de quem não tem telefone
--NULL (IS NULL || IS NOT NULL)
SELECT id,
		nome+' '+sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL

--Id, Nome Concatenado e telefone (sem ddd) de quem tem telefone
SELECT id,
		nome+' '+sobrenome AS nome_completo,
		telefone
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome, sobrenome ASC
--ORDER BY nome_completo DESC

--ORDER BY coluna1, coluna2, ... ASC (ou DESC)

--Id, Nome Concatenado e telefone (sem ddd) 
--de quem tem telefone em ordem alfabética

--Id, Nome completo, Endereco completo (Rua, nº e CEP), 
--ddd e telefone, ordem alfabética crescente
SELECT id,
		nome+' '+sobrenome AS nome_completo,
		logradouro+','+CAST(numero AS VARCHAR(5))+' - CEP:'+cep AS endereco,
		ddd,
		telefone
FROM funcionario
ORDER BY nome_completo ASC

--Nome completo, Endereco completo (Rua, nº e CEP), data_nasc (BR), ordem alfabética decrescente
SELECT	id,
		nome+' '+sobrenome AS nome_completo,
		logradouro+','+CAST(numero AS VARCHAR(5))+' - CEP:'+cep AS endereco,
		ddd,
		telefone,
		CONVERT(CHAR(10),data_nasc,103) AS data_nasc
FROM funcionario
ORDER BY nome_completo DESC

--Datas distintas (BR) de inicio de trabalhos
-- DISTINCT elimina linhas que são inteiramente iguais
SELECT DISTINCT CONVERT(CHAR(10),data_inicio,103) AS data_inicio
FROM funcproj

--nome_completo e 15% de aumento para Cicrano
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario,
		CAST(salario * 1.15 AS DECIMAL(7,2)) AS pedido_novo_salario
FROM funcionario
WHERE nome = 'Cicrano' 

--Nome completo e salario de quem ganha mais que 3000
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario > 3000

--Nome completo e salario de quem ganha menos que 2000
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario <= 2000

--Nome completo e salario de quem ganha entre 2000 e 3000
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario > 2000 AND salario < 3000

--BETWEEN
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario BETWEEN 2000 AND 3000

--Nome completo e salario de quem ganha menos que 2000 e mais que 3000
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario <= 2000 OR salario >= 3000

--NOT BETWEEN
SELECT  id,
		nome+' '+sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario NOT BETWEEN 2000 AND 3000