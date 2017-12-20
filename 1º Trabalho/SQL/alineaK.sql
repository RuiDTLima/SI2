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
	DROP PROCEDURE dbo.SendEmail;
GO
CREATE PROCEDURE dbo.SendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255),@mail NVARCHAR(4000) OUTPUT AS
	SET @mail=CONCAT('De: Ger�ncia Glampinho '+char(10)+'Para: ' + @email+char(10)+'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR)+char(10)+'Mensagem: ' +char(10)+@text,char(10)) 
	

/*************************************** Envia email a todos os h�spedes respons�veis por estadas a come�ar dentro de x temp ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'SendEmails')
	DROP PROCEDURE dbo.SendEmails;
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT,@text NVARCHAR(4000) OUTPUT AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    BEGIN TRY
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(500)
	DECLARE @emailText VARCHAR(4000)
	

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.H�spede AS Hosp JOIN dbo.H�spedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.h�spede = 'true' AND Est.dataIn�cio <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	SET @text = ''
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.',@emailText output
			/*SELECT @text= dbo.lol (112233445, 'jose@gmail.com', 'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.')*/
			SET @text =  CONCAT(@emailText,@text)
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	COMMIT
END TRY
BEGIN CATCH
 IF @@TRANCOUNT !=0
			ROLLBACK;
END CATCH 

/*************************************** Teste ************************************************************************/

DECLARE @T VARCHAR(4000)

EXEC dbo.sendEmails 7,@T output

SELECT @T

SELECT * FROM dbo.Estada
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.H�spedeEstada

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES	(2, '2017-12-25', '2017-12-27'),
			(3, '2017-12-17', '2017-12-27'),
			(4, '2017-12-19', '2017-12-30')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'Ant�nio', 'Rua 4', 'antonio@gmail.com', 44556677)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 3, 'true')






