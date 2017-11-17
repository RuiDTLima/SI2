/*******************************************************************************
**	Nome               alineaK
**	
**	Objectivo          O objectivo deste script é o de enviar emails a todos os 
**						hóspedes responsáveis por estadas que se irão iniciar 
**						dentro de um dado periodo temporal
**
**	Criado por         Grupo 4 
**	Data de Criação    14/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Estrutura do email a enviar  ************************************************************************/
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text NVARCHAR(255) AS
	PRINT 'De: Gerência Glampinho'
	PRINT 'Para: ' + @email
	PRINT 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR)
	PRINT 'Mensagem: ' + @text
	PRINT ''

/*************************************** Envia email a todos os hóspedes responsáveis por estadas a começar dentro de x temp ************************************************************************/
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT AS
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(30)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.Hóspede AS Hosp JOIN dbo.HóspedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.hóspede = 'true' AND Est.dataInício <= DATEADD(DAY, @periodoTemporal, GETDATE())
	OPEN iterate_NIFs

	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC SendEmail @NIF, @email, 'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.' 
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs


/*************************************** Teste ************************************************************************/

EXEC dbo.sendEmails 7

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.HóspedeEstada

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES	(2, '2017-11-20', '2017-11-27'),
			(3, '2017-11-20', '2017-11-27'),
			(4, '2017-11-26', '2017-11-30')


INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 2, 'false')