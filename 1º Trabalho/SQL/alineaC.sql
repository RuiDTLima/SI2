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

/****** INSERT *************************************************************/

INSERT INTO H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

/****** UPDATE ************************************************************/

UPDATE H�spede SET morada = 'Rua Teste' WHERE NIF = 112233445

/****** DELETE ***********************************************************  (duvida)-posso apagar um respons�vel? se sim, apago a estada tambem e a fatura?*/
GO
CREATE PROCEDURE dbo.deleteHospede 
@NIFHospede int
as
BEGIN TRY
    BEGIN TRANSACTION
    DELETE FROM H�spedeEstada WHERE NIF=@NIFHospede
	DELETE FROM H�spede WHERE NIF=@NIFHospede
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH

/*** TESTE ***********/

INSERT INTO ESTADA(id, dataIn�cio, dataFim)
	VALUES(1,'03-15-17 10:30',null)

INSERT INTO H�spedeEstada(NIF, id, h�spede)
	VALUES(112233445,1,'true')


SELECT * FROM dbo.H�spede

SELECT * FROM H�spedeEstada

exec dbo.deleteHospede 112233445
