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

/****** INSERT *************************************************************/

INSERT INTO Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

/****** UPDATE ************************************************************/

UPDATE Hóspede SET morada = 'Rua Teste' WHERE NIF = 112233445

/****** DELETE ***********************************************************  (duvida)-posso apagar um responsável? se sim, apago a estada tambem e a fatura?*/
GO
CREATE PROCEDURE dbo.deleteHospede 
@NIFHospede int
as
BEGIN TRY
    BEGIN TRANSACTION
    DELETE FROM HóspedeEstada WHERE NIF=@NIFHospede
	DELETE FROM Hóspede WHERE NIF=@NIFHospede
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH

/*** TESTE ***********/

INSERT INTO ESTADA(id, dataInício, dataFim)
	VALUES(1,'03-15-17 10:30',null)

INSERT INTO HóspedeEstada(NIF, id, hóspede)
	VALUES(112233445,1,'true')


SELECT * FROM dbo.Hóspede

SELECT * FROM HóspedeEstada

exec dbo.deleteHospede 112233445
