/*******************************************************************************
**	Nome               alineaK
**	
**	Objectivo          O objectivo deste script � o de enviar emails a todos os 
**						h�spedes respons�veis por estadas que se ir�o iniciar 
**						dentro de um dado periodo temporal
**
**	Criado por         Grupo 4 
**	Data de Cria��o    14/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Estrutura do email a enviar  ************************************************************************/
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text NVARCHAR(255) AS
	PRINT 'De: Ger�ncia Glampinho'
	PRINT 'Para: ' + @email
	PRINT 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR)
	PRINT 'Mensagem: ' + @text
	PRINT ''

/*************************************** Envia email a todos os h�spedes respons�veis por estadas a come�ar dentro de x temp ************************************************************************/
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT AS
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(30)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.H�spede AS Hosp JOIN dbo.H�spedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.h�spede = 'true' AND Est.dataIn�cio <= DATEADD(DAY, @periodoTemporal, GETDATE())
	OPEN iterate_NIFs

	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC SendEmail @NIF, @email, 'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.' 
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs


/*************************************** Teste ************************************************************************/

EXEC dbo.sendEmails 7

SELECT * FROM dbo.Estada
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.H�spedeEstada

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES	(2, '2017-11-20', '2017-11-27'),
			(3, '2017-11-20', '2017-11-27'),
			(4, '2017-11-26', '2017-11-30')


INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 2, 'false')