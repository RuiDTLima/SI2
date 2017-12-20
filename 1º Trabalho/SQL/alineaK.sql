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
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255),@mail TEXT OUTPUT AS
	SET @mail=CONCAT('De: Gerência Glampinho '+char(9)+'Para: ' + @email+char(9)+'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR)+char(9)+'Mensagem: ' +char(9)+@text,char(9)) 
	RETURN 

/*************************************** Envia email a todos os hóspedes responsáveis por estadas a começar dentro de x temp ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'SendEmails')
	DROP PROCEDURE dbo.SendEmails;
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT,@text TEXT OUTPUT AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    BEGIN TRY
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(30)
	DECLARE @emailText VARCHAR(255)
	

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.Hóspede AS Hosp JOIN dbo.HóspedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.hóspede = 'true' AND Est.dataInício <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	SET @text = ''
	WHILE @@FETCH_STATUS = 0
		BEGIN
			/*EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.',@emailText */
			SELECT @text= dbo.lol (112233445, 'jose@gmail.com', 'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.')
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

DECLARE @T VARCHAR(255)

EXEC dbo.sendEmails 7,@T


SELECT @T

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.HóspedeEstada

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES	(2, '2017-12-18', '2017-12-27'),
			(3, '2017-12-17', '2017-12-27'),
			(4, '2017-12-19', '2017-12-30')

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'António', 'Rua 4', 'antonio@gmail.com', 44556677)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES	(112233445, 2, 'true'),
			(566778899, 3, 'true')



GO
CREATE Function dbo.enviarEmail (@NIF INT, @email NVARCHAR(30), @text VARCHAR(255))
 RETURNS VARCHAR(255) 
 AS
 BEGIN
	DECLARE @mail NVARCHAR(255)
	SET @mail=CONCAT('De: Gerência Glampinho '+char(9)+'Para: ' + @email+char(9)+'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR)+char(9)+'Mensagem: ' +char(9)+@text,char(9)) 
	RETURN @mail
END


GO
CREATE Function dbo.enviarEmails(@periodoTemporal INT)
 RETURNS VARCHAR(255) 
  AS
  begin
DECLARE @emailText VARCHAR(255)
DECLARE @text VARCHAR(255)
DECLARE @NIF INT
DECLARE @email VARCHAR(255)
	
	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.Hóspede AS Hosp JOIN dbo.HóspedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.hóspede = 'true' AND Est.dataInício <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @emailText= dbo.enviarEmail(@NIF, @email, 'Email de teste')
			SET @text = CONCAT(@text,@emailText,char(9))
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	RETURN @text
	END


	select dbo.enviarEmails(7)