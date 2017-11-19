/*******************************************************************************
**	Nome               alineaL
**	
**	Objectivo          O objectivo deste script � o de listar todas as actividades
**						com lugares disponiveis para um intervalo de datas 
**						especificado
**
**	Criado por         Grupo 4 
**	Data de Cria��o    18/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** FUN��O PARA LISTAR ACTIVIDADES ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'listAtividades')
	DROP FUNCTION dbo.listAtividades;
GO
CREATE FUNCTION dbo.listAtividades(@dataInicio DATETIME2, @dataFim DATETIME2)
RETURNS  @rtnTable TABLE (
    -- columns returned by the function
    nome NVARCHAR(30) NOT NULL,
    descri��o NVARCHAR(30) NOT NULL
) AS

BEGIN
	INSERT INTO @rtnTable(nome, descri��o)
		SELECT nome, descri��o FROM dbo.Actividades INNER JOIN (
			SELECT n�meroSequencial, ano, count(n�meroSequencial) AS participantes FROM dbo.Paga 
			GROUP BY n�meroSequencial, ano) AS A 
			ON A.n�meroSequencial = Actividades.n�meroSequencial AND A.ano = Actividades.ano AND lota��oM�xima > participantes 
				AND dataRealiza��o BETWEEN @dataInicio AND @dataFim 
	RETURN
END

/*************************************** Apresenta todas as actividades com lugares disponiveis para um intervalo de datas ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE_DESC = 'SQL_STORED_PROCEDURE' AND NAME = 'listarAtividades')
	DROP PROCEDURE dbo.listarAtividades;
GO
CREATE PROCEDURE dbo.listarAtividades @dataInicio DATETIME2, @dataFim DATETIME2 AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

			SELECT * FROM dbo.listAtividades(@dataInicio, @dataFim)
			IF @@ROWCOUNT = 0 
				THROW 51000, 'As actividades encotram-se lotadas ou fora do intervalo especificado', 1
		COMMIT

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH 

/*************************************** Teste ************************************************************************/
GO
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua Manel', 'manel@test.com', 99001122)

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', 14, 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', 10, 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3)

SELECT * FROM dbo.Paga
SELECT * FROM dbo.Actividades

EXEC dbo.listarAtividades '2016-03-12', '2017-03-16'