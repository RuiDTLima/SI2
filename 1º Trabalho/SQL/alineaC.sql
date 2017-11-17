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
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

/********************************** UPDATE ************************************************************/

UPDATE dbo.H�spede SET morada = 'Rua Teste' WHERE NIF = 112233445

/********************************** DELETE ************************************************************/
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS
BEGIN TRY
    BEGIN TRANSACTION
		DECLARE @count INT
		SELECT @count = COUNT(NIF) FROM dbo.H�spedeEstada 
			WHERE NIF = @NIFHospede AND h�spede = 'true'
		if(@count = 0)
			BEGIN
				DELETE FROM H�spedeEstada WHERE NIF=@NIFHospede
				DELETE FROM H�spede WHERE NIF=@NIFHospede
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
INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim)
	VALUES(1, '2017-11-09 13:00:00', '2017-11-11 13:00:00')

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES(112233445, 1, 'false'),
		  (566778899, 1, 'true')

SELECT * FROM dbo.H�spede

SELECT * FROM dbo.H�spedeEstada

EXEC dbo.deleteHospede 112233445
EXEC dbo.deleteHospede 566778899