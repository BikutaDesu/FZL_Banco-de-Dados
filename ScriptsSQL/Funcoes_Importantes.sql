--Funções importantes
--Alias (AS)
SELECT GETDATE() AS hoje --NOW(), SELECT SYSDATE FROM DUAL
--System.out.Println("Número #"+varInt)
--CAST - SELECT CAST(valor AS NOVO_TIPO)
SELECT CAST(12.0 AS VARCHAR(4)) AS cast_to_varchar
SELECT CAST('12' AS INT) AS cast_to_int
--SQL Server CAST especial (CONVERT(NOVO_TIPO, valor, codigo*))
SELECT CONVERT(VARCHAR(4), 12) AS convert_to_varchar
SELECT CONVERT(INT, '12') AS convert_to_int
--CONVERT código 103 (dd/mm/yyyy) - Formato BR de data
SELECT CONVERT(CHAR(10), GETDATE(), 103) as Hoje
--CONVERT código 108 (HH:mm) - Formato de hora
SELECT CONVERT(CHAR(5), GETDATE(), 108) AS Hora_agora
--Os dois juntos
SELECT CONVERT(CHAR(10), GETDATE(), 103) as Hoje,
		CONVERT(CHAR(5), GETDATE(), 108) AS Hora_agora