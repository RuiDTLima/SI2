/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script é o de inserir, remover e actualizar
**					   informação de um hóspede
**
**	Criado por         Grupo 4 
**	Data de Criação    05/11/17
**
******************************************************************************/
USE Glampinho

/********************************* INSERT *************************************************************/
INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'António', 'Rua 4', 'antonio@gmail.com', 44556677)

/********************************** UPDATE ************************************************************/

UPDATE dbo.Hóspede SET morada = 'Rua Teste' WHERE NIF = 112233445

/********************************** DELETES ************************************************************/
/********************************** DELETE HÓSPEDES ASSOCIADOS ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaHóspedesAssociados')
	DROP PROCEDURE dbo.eliminaHóspedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaHóspedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 	-- evita as anomalias dirty read e nonrepeatable read
		DECLARE @NIFHóspede INT
		DECLARE @count INT

		DECLARE hóspedesAssociados CURSOR FOR SELECT NIF FROM dbo.HóspedeEstada WHERE id = @idEstada

		OPEN hóspedesAssociados
		FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.Hóspede WHERE NIF = @NIFHóspede
			END
			
			FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede
		END

		CLOSE hóspedesAssociados
		DEALLOCATE hóspedesAssociados
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE HÓSPEDE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteHospede')
	DROP PROCEDURE dbo.deleteHospede;
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS 
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- para evitar lost updates
		DECLARE @hóspede VARCHAR(5)
		DECLARE @idEstada INT

		DECLARE eliminaEstadaInfo CURSOR FOR SELECT id, hóspede FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede

		OPEN eliminaEstadaInfo
		FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @hóspede

		WHILE @@FETCH_STATUS = 0
			BEGIN
				if @hóspede = 'true'	-- significa que deve ser elimina a estada e todas as entidades associativas associadas a ela
					BEGIN
						DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
						DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada

						EXEC dbo.eliminaHóspedesAssociados @idEstada	-- verifica se a estada é a unica dos seus hóspede, em caso afirmativo elimina esses hóspedes

						DELETE FROM dbo.Estada WHERE id = @idEstada
						DELETE FROM dbo.Hóspede WHERE NIF = @NIFHospede
					END
				ELSE
					BEGIN
						DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.Hóspede WHERE NIF = @NIFHospede
					END
				
				FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @hóspede
			END

		CLOSE eliminaEstadaInfo
		DEALLOCATE eliminaEstadaInfo
    COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* TESTE ***************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com'),
			('testec#', 'campo de teste', 4, 'teste@c#.com')

EXEC dbo.InsertAlojamentoTenda    'Glampinho', 'tenda pequena',  'Rua 1', 'bonito',			   12, 4,  50
EXEC dbo.InsertAlojamentoTenda    'Glampinho', 'tenda grande',	 'Rua 2', 'grande',			   15, 10, 50
EXEC dbo.InsertAlojamentoTenda    'Glampinho', 'tenda tempo',	 'Rua 3', 'tempo',			   15, 11, 50
EXEC dbo.InsertAlojamentoTenda	  'Glampinho', 'tenda vazia',	 'Rua 4', 'vazia',			   15, 10, 50
EXEC dbo.InsertAlojamentoTenda	  'Glampinho', 'tenda nova',     'Rua 5', 'por estrear',	   15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje',  'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow',  15, 9,  'T3'
EXEC dbo.InsertAlojamentoBungalow 'testec#', 'teste', 'rua de testes', 'teste de c#', 10, 5, 'T3'

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 4', 3)

-- executar insert hospede primeiro
INSERT INTO	dbo.Estada(id, dataInício, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null),
		   (3, '2017-12-22 11:00:00', '2017-12-23 11:00:00', null, null)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (112233445, 1, 'false'),
		   (566778899, 1, 'true' ),
		   (123456789, 2, 'true' ),
		   (123243546, 2, 'false'),
		   (112233445, 2, 'false'),
		   (566778899, 3, 'true')

INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
	VALUES (1, 1, 10),
		   (1, 2, 15),
		   (1, 3, 20),
		   (2, 1, 10),
		   (2, 2, 15),
		   (2, 3, 20)

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('testec#', 'rua de testes', 3, 20)

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.Estada
SELECT * FROM dbo.HóspedeEstada
SELECT * FROM dbo.EstadaExtra
SELECT * FROM dbo.Paga

EXEC dbo.deleteHospede 112233445
EXEC dbo.deleteHospede 123456789      