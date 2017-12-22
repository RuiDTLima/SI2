/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script � o de inserir, remover e actualizar
**					   informa��o de um h�spede
**
**	Criado por         Grupo 4 
**	Data de Cria��o    05/11/17
**
******************************************************************************/
USE Glampinho

/********************************* INSERT *************************************************************/
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'Ant�nio', 'Rua 4', 'antonio@gmail.com', 44556677)

/********************************** UPDATE ************************************************************/

UPDATE dbo.H�spede SET morada = 'Rua Teste' WHERE NIF = 112233445

/********************************** DELETES ************************************************************/
/********************************** DELETE H�SPEDES ASSOCIADOS ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaH�spedesAssociados')
	DROP PROCEDURE dbo.eliminaH�spedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaH�spedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 	-- evita as anomalias dirty read e nonrepeatable read
		DECLARE @NIFH�spede INT
		DECLARE @count INT

		DECLARE h�spedesAssociados CURSOR FOR SELECT NIF FROM dbo.H�spedeEstada WHERE id = @idEstada

		OPEN h�spedesAssociados
		FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.H�spede WHERE NIF = @NIFH�spede
			END
			
			FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede
		END

		CLOSE h�spedesAssociados
		DEALLOCATE h�spedesAssociados
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE H�SPEDE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteHospede')
	DROP PROCEDURE dbo.deleteHospede;
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS 
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- para evitar lost updates
		DECLARE @h�spede VARCHAR(5)
		DECLARE @idEstada INT

		DECLARE eliminaEstadaInfo CURSOR FOR SELECT id, h�spede FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede

		OPEN eliminaEstadaInfo
		FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @h�spede

		WHILE @@FETCH_STATUS = 0
			BEGIN
				if @h�spede = 'true'	-- significa que deve ser elimina a estada e todas as entidades associativas associadas a ela
					BEGIN
						DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada

						EXEC dbo.eliminaH�spedesAssociados @idEstada	-- verifica se a estada � a unica dos seus h�spede, em caso afirmativo elimina esses h�spedes

						DELETE FROM dbo.Estada WHERE id = @idEstada
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				ELSE
					BEGIN
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				
				FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @h�spede
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

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 4', 3)

-- executar insert hospede primeiro
INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null),
		   (3, '2017-12-22 11:00:00', '2017-12-23 11:00:00', null, null)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 1, 'false'),
		   (566778899, 1, 'true' ),
		   (123456789, 2, 'true' ),
		   (123243546, 2, 'false'),
		   (112233445, 2, 'false'),
		   (566778899, 3, 'true')

INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (1, 1, 10),
		   (1, 2, 15),
		   (1, 3, 20),
		   (2, 1, 10),
		   (2, 2, 15),
		   (2, 3, 20)

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('testec#', 'rua de testes', 3, 20)

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.Estada
SELECT * FROM dbo.H�spedeEstada
SELECT * FROM dbo.EstadaExtra
SELECT * FROM dbo.Paga

EXEC dbo.deleteHospede 112233445
EXEC dbo.deleteHospede 123456789      