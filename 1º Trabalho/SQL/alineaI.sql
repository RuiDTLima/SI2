/*******************************************************************************
**	Nome               alineaI
**	
**	Objectivo          O objectivo deste script � o inscrever um h�spede numa actividade
**
**	Criado por         Grupo 4 
**	Data de Cria��o    09/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Inscrever h�spede a actividade  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'inscreverH�spede')
	DROP PROCEDURE dbo.inscreverH�spede;
GO 
CREATE PROCEDURE dbo.inscreverH�spede @NIFH�spede INT, @n�meroSequencial INT, @nomeParque NVARCHAR(30), @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- para nao perdermos uma atualiza��o
			DECLARE @dataRealiza��o DATETIME2
			SELECT @dataRealiza��o = dataRealiza��o FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano

			IF NOT EXISTS (SELECT 1 FROM dbo.H�spedeEstada as hosEst INNER JOIN dbo.Estada as Est ON hosEst.id = Est.id JOIN dbo.AlojamentoEstada as AlojEst ON AlojEst.id = Est.id
							WHERE hosEst.NIF = @NIFH�spede AND Est.dataFim > @dataRealiza��o AND Est.dataIn�cio < @dataRealiza��o AND AlojEst.nomeParque = @nomeParque AND Est.dataFim > GETDATE())
				THROW 51000, 'H�spede � inv�lido', 1 

			INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
				SELECT @nomeParque, @n�meroSequencial, @ano, @NIFH�spede, pre�oParticipante FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial
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
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-18 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 4, 15)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 2, 'false')

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 3, '2017-03-15 10:30:00')

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga
SELECT * FROM dbo.H�spede

EXEC dbo.inscreverH�spede 112233445, 1, 'Glampinho', 2017
EXEC dbo.inscreverH�spede 112233445, 2, 'Glampinho', 2017