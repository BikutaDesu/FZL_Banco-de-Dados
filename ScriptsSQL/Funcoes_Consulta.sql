USE aulajoin10

SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM avaliacoes
SELECT * FROM notas ORDER BY id_materia, id_avaliacao
SELECT * FROM alunomateria

--Consultar a média das notas de cada avaliação por matéria
SELECT m.nome, av.tipo, 
		CAST(AVG(n.nota) AS DECIMAL(7,2)) AS media
FROM materias m INNER JOIN notas n
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao

ORDER BY m.nome

GROUP BY m.nome, av.tipo
SELECT m.nome, av.tipo, 
		CAST(AVG(n.nota) AS DECIMAL(7,2)) AS media
FROM materias m, notas n, avaliacoes av
WHERE m.id = n.id_materia
	AND av.id = n.id_avaliacao
GROUP BY m.nome, av.tipo
ORDER BY m.nome



--Consultar o RA do aluno (mascarado), a nota final dos alunos, 
--de alguma matéria e uma coluna conceito 
--(aprovado caso nota >= 6, reprovado, caso contrário)
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
		a.nome,
		CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(av.peso * n.nota) >= 6.0)
			THEN 'APROVADO'
			ELSE 'REPROVADO'
		END AS conceito
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
INNER JOIN materias m
ON m.id = n.id_materia
WHERE m.nome = 'Banco de Dados' 
GROUP BY ra, a.nome
ORDER BY a.nome

SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
		a.nome,
		CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final,
		CASE WHEN (SUM(av.peso * n.nota) >= 6.0)
			THEN 'APROVADO'
			ELSE 'REPROVADO'
		END AS conceito
FROM alunos a, notas n, avaliacoes av, materias m
WHERE a.ra = n.ra_aluno
	AND av.id = n.id_avaliacao
	AND m.id = n.id_materia
	AND m.nome = 'Banco de Dados' 
GROUP BY ra, a.nome
ORDER BY a.nome

--Consultar nome da matéria e quantos alunos estão matriculados
SELECT m.nome, COUNT(a.ra) AS matriculados
FROM alunos a INNER JOIN alunomateria am
ON a.ra = am.ra_aluno
INNER JOIN materias m
ON m.id = am.id_materia
GROUP BY m.nome

SELECT m.nome, COUNT(a.ra) AS matriculados
FROM alunos a, alunomateria am, materias m
WHERE a.ra = am.ra_aluno
	AND m.id = am.id_materia
GROUP BY m.nome


--Consultar quantos alunos não estão matriculados
SELECT COUNT(a.ra) total_nao_matriculados
FROM alunos a LEFT OUTER JOIN alunomateria am
ON a.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL


--Consultar quais alunos estão aprovados em alguma matéria 
--(nota final >= 6,0)
SELECT a.ra, a.nome,
		CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
INNER JOIN materias m
ON m.id = n.id_materia
WHERE m.nome = 'Banco de Dados'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) >= 6.0	

SELECT a.ra, a.nome,
		CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final
FROM alunos a, notas n, avaliacoes av, materias m
WHERE a.ra = n.ra_aluno
	AND av.id = n.id_avaliacao
	AND m.id = n.id_materia
	AND m.nome = 'Banco de Dados'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) >= 6.0	


--Consultar o nome dos alunos que tem a maior nota de alguma matéria
SELECT a.ra, a.nome
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
WHERE n.nota IN
(SELECT MAX(nota) 
FROM materias m INNER JOIN notas n
ON m.id = n.id_materia
WHERE m.nome = 'Banco de Dados')

SELECT a.ra, a.nome
FROM alunos a, notas n
WHERE a.ra = n.ra_aluno
	AND n.nota IN
(SELECT MAX(nota) 
FROM materias m, notas n
WHERE m.id = n.id_materia
	AND m.nome = 'Banco de Dados')