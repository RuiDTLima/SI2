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
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'sendEmail')
	DROP PROCEDURE dbo.sendEmail;
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255), @mail TEXT OUTPUT AS
	SET @mail=CONCAT('De: Ger�ncia Glampinho ' + char(10) + 'Para: ' + @email + char(10) + 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR) + char(10) + 'Mensagem: ' + @text, char(10), char(10)) 
	RETURN 

/*************************************** Envia email a todos os h�spedes respons�veis por estadas a come�ar dentro de x temp ************************************************************************/
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
	
	DECLARE @Notifica��es TABLE(
		mensagem TEXT NOT NULL
	)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.H�spede AS Hosp JOIN dbo.H�spedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.h�spede = 'true' AND Est.dataIn�cio > GETDATE() AND Est.dataIn�cio <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.', @emailText OUTPUT
			INSERT INTO @Notifica��es(mensagem) VALUES(@emailText)
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
		
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	SELECT mensagem FROM @Notifica��es
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
END CATCH 

/*************************************** Teste ************************************************************************/
INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES	(2, '2017-12-23 13:00:00', '2017-12-27 13:00:00'),
			(3, '2017-12-23 13:00:00', '2017-12-27 13:00:00'),
			(4, '2017-12-23 13:00:00', '2017-12-30 13:00:00')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'Ant�nio', 'Rua 4', 'antonio@gmail.com', 44556677)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 3, 'true')
	
SELECT * FROM dbo.Estada
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.H�spedeEstada

EXEC dbo.sendEmails 1