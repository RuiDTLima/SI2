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
		   (123456789, 'Maria', 'Rua 2', 'maria@gmail.com', 123456789),
		   (2, 'Maria', 'Rua 2', 'maria@gmail.com', 22),
		   (3, 'Maria', 'Rua 2', 'maria@gmail.com', 33),
		   (4, 'Maria', 'Rua 2', 'maria@gmail.com', 44)



/********************************** UPDATE ************************************************************/

UPDATE dbo.H�spede SET morada = 'Rua Teste' WHERE NIF = 112233445

/********************************** DELETE ************************************************************/
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS 
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- para evitar lost updates
		DECLARE @h�spede VARCHAR(5)
		DECLARE @idEstada INT
		DECLARE eliminaEstadaInfo CURSOR FOR SELECT id, h�spede FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede

		OPEN eliminaEstadaInfo
		FETCH FROM eliminaEstadaInfo INTO @idEstada, @h�spede

		WHILE @@FETCH_STATUS = 0
			BEGIN
				if @h�spede = 'true'	-- significa que deve ser elimina a estada e todas as entidades associativas associadas a ela
					BEGIN
						DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada
						DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede

						EXEC dbo.eliminaH�spedesAssociados @idEstada	-- verifica se a estada � a unica dos seus h�spede, em caso afirmativo elimina esses h�spedes

						DELETE FROM dbo.Estada WHERE id = @idEstada
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				ELSE
					BEGIN
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				
				FETCH FROM eliminaEstadaInfo INTO @idEstada, @h�spede
			END
    COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* TESTE ***************************************************************/
-- executar insert hospede primeiro
INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim, idFactura, ano)
	VALUES(1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES(112233445, 1, 'false'),
		  (566778899, 1, 'true')

SELECT * FROM dbo.H�spede

SELECT * FROM dbo.H�spedeEstada

EXEC dbo.deleteHospede 112233445
EXEC dbo.deleteHospede 566778899