/*******************************************************************************
**	Nome               alineaI
**	
**	Objectivo          O objectivo deste script é o inscrever um hóspede numa actividade
**
**	Criado por         Grupo 4 
**	Data de Criação    09/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Inscrever hóspede a actividade  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'inscreverHóspede')
	DROP PROCEDURE dbo.inscreverHóspede;
GO 
CREATE PROCEDURE dbo.inscreverHóspede @NIFHóspede INT, @númeroSequencial INT, @nomeParque NVARCHAR(30), @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- para nao perdermos uma atualização
			DECLARE @dataRealização DATETIME2
			SELECT @dataRealização = dataRealização FROM dbo.Actividades WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano

			IF NOT EXISTS (SELECT 1 FROM dbo.HóspedeEstada as hosEst INNER JOIN dbo.Estada as Est ON hosEst.id = Est.id JOIN dbo.AlojamentoEstada as AlojEst ON AlojEst.id = Est.id
							WHERE hosEst.NIF = @NIFHóspede AND Est.dataFim > @dataRealização AND Est.dataInício < @dataRealização AND AlojEst.nomeParque = @nomeParque AND Est.dataFim > GETDATE())
				THROW 51000, 'Hóspede é inválido', 1 

			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
				SELECT @nomeParque, @númeroSequencial, @ano, @NIFHóspede, preçoParticipante FROM dbo.Actividades WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial
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
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-18 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 4, 15)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (112233445, 2, 'false')

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 3, '2017-03-15 10:30:00')

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Hóspede

EXEC dbo.inscreverHóspede 112233445, 1, 'Glampinho', 2017
EXEC dbo.inscreverHóspede 112233445, 2, 'Glampinho', 2017