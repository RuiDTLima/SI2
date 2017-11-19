/*******************************************************************************
**	Nome               alineaL
**	
**	Objectivo          O objectivo deste script é o de listar todas as actividades
**						com lugares disponiveis para um intervalo de datas 
**						especificado
**
**	Criado por         Grupo 4 
**	Data de Criação    18/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** FUNÇÂO PARA LISTAR ACTIVIDADES ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'listAtividades')
	DROP FUNCTION dbo.listAtividades;
GO
CREATE FUNCTION dbo.listAtividades(@dataInicio DATETIME2, @dataFim DATETIME2)
RETURNS  @rtnTable TABLE (
    -- columns returned by the function
    nome NVARCHAR(30) NOT NULL,
    descrição NVARCHAR(30) NOT NULL
) AS

BEGIN
	INSERT INTO @rtnTable(nome, descrição)
		SELECT nome, descrição FROM dbo.Actividades INNER JOIN (
			SELECT númeroSequencial, ano, count(númeroSequencial) AS participantes FROM dbo.Paga 
			GROUP BY númeroSequencial, ano) AS A 
			ON A.númeroSequencial = Actividades.númeroSequencial AND A.ano = Actividades.ano AND lotaçãoMáxima > participantes 
				AND dataRealização BETWEEN @dataInicio AND @dataFim 
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

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua Manel', 'manel@test.com', 99001122)

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', 14, 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', 10, 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3)

SELECT * FROM dbo.Paga
SELECT * FROM dbo.Actividades

EXEC dbo.listarAtividades '2016-03-12', '2017-03-16'