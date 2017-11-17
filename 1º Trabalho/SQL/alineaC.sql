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
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

/********************************** UPDATE ************************************************************/

UPDATE dbo.Hóspede SET morada = 'Rua Teste' WHERE NIF = 112233445

/********************************** DELETE ************************************************************/
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS
BEGIN TRY
    BEGIN TRANSACTION
		DECLARE @count INT
		SELECT @count = COUNT(NIF) FROM dbo.HóspedeEstada 
			WHERE NIF = @NIFHospede AND hóspede = 'true'
		if(@count = 0)
			BEGIN
				DELETE FROM HóspedeEstada WHERE NIF=@NIFHospede
				DELETE FROM Hóspede WHERE NIF=@NIFHospede
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
INSERT INTO	dbo.Estada(id, dataInício, dataFim)
	VALUES(1, '2017-11-09 13:00:00', '2017-11-11 13:00:00')

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES(112233445, 1, 'false'),
		  (566778899, 1, 'true')

SELECT * FROM dbo.Hóspede

SELECT * FROM dbo.HóspedeEstada

EXEC dbo.deleteHospede 112233445
EXEC dbo.deleteHospede 566778899