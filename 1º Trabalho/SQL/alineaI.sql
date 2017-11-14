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
CREATE PROCEDURE dbo.inscreverHóspede @NIFHóspede INT, @númeroSequencial INT, @nomeParque NVARCHAR(30) AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @temp INT
			SELECT  @temp = hosEst.id FROM dbo.HóspedeEstada as hosEst INNER JOIN dbo.Estada as Est ON hosEst.id = Est.id JOIN dbo.AlojamentoEstada as AlojEst ON AlojEst.id = Est.id 
				WHERE  hosEst.NIF = @NIFHóspede AND Est.dataFim > GETDATE() AND AlojEst.nomeParque = @nomeParque

			IF(@@ROWCOUNT = 0)
				RAISERROR('Hóspede é inválido', 15, 1)

			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, NIF)
				VALUES(@nomeParque, @númeroSequencial, @NIFHóspede)
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na inscrição de um hóspede numa actividade', 5, 2)
		ROLLBACK
	END CATCH
	
/*************************************** Teste ************************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	      (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T5'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T5'

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO AlojamentoEstada(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 1', 1),
		   ('Glampinho', 'Rua 2', 2),
		   ('Glampinho', 'Rua 4', 3),
		   ('Glampinho', 'Rua 7', 4)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES(112233445, 2, 'false')

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES('Glampinho', 1, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '03-15-17 10:30')

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Hóspede

EXEC dbo.inscreverHóspede 566778899, 1, 'Glampinho' 