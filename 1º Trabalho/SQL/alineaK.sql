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
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'sendEmail')
	DROP PROCEDURE dbo.sendEmail;
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255), @mail TEXT OUTPUT AS
	SET @mail=CONCAT('De: Gerência Glampinho ' + char(10) + 'Para: ' + @email + char(10) + 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR) + char(10) + 'Mensagem: ' + @text, char(10), char(10)) 
	RETURN 

/*************************************** Envia email a todos os hóspedes responsáveis por estadas a começar dentro de x temp ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'SendEmails')
	DROP PROCEDURE dbo.SendEmails;
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    BEGIN TRY
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(30)
	DECLARE @emailText VARCHAR(255)
	
	DECLARE @Notificações TABLE(
		mensagem TEXT NOT NULL
	)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.Hóspede AS Hosp JOIN dbo.HóspedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.hóspede = 'true' AND Est.dataInício > GETDATE() AND Est.dataInício <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.', @emailText OUTPUT
			INSERT INTO @Notificações(mensagem) VALUES(@emailText)
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
		
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	SELECT mensagem FROM @Notificações
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
END CATCH 

/*************************************** Teste ************************************************************************/
INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES	(2, '2017-12-23 13:00:00', '2017-12-27 13:00:00'),
			(3, '2017-12-23 13:00:00', '2017-12-27 13:00:00'),
			(4, '2017-12-23 13:00:00', '2017-12-30 13:00:00')

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'António', 'Rua 4', 'antonio@gmail.com', 44556677)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 3, 'true')
	
SELECT * FROM dbo.Estada
SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.HóspedeEstada

EXEC dbo.sendEmails 1