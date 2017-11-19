/*******************************************************************************
**	Nome               testeAlineaC
**	
**	Objectivo          O objectivo deste script é o de testar o correcto 
**						funcionamento da alinea C
**
**	Criado por         Grupo 4 
**	Data de Criação    19/11/17
**
******************************************************************************/
use Glampinho;

/********************************** PROCEDIMENTOS DE TESTE ************************************************************/
/********************************** TESTA INSERTS ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testaInsert')
	DROP PROCEDURE dbo.testaInsert;
GO
CREATE PROCEDURE dbo.testaInsert AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (11111111, 'insertTeste', 'Avenida teste', 'insertteste@teste.com', 11111111)

			SELECT * FROM dbo.Hóspede
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA UPDATES ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testaUpdate')
	DROP PROCEDURE dbo.testaUpdate;
GO
CREATE PROCEDURE dbo.testaUpdate AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts
			UPDATE dbo.Hóspede SET morada = 'teste' WHERE NIF = 112233445 

			SELECT * FROM dbo.Hóspede
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA DELETES ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testaDelete')
	DROP PROCEDURE dbo.testaDelete;
GO
CREATE PROCEDURE dbo.testaDelete AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts

			SELECT * FROM dbo.EstadaExtra
			SELECT * FROM dbo.HóspedeEstada
			SELECT * FROM dbo.AlojamentoEstada
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.Hóspede

			EXEC dbo.deleteHospede 112233445
			
			SELECT * FROM dbo.EstadaExtra
			SELECT * FROM dbo.HóspedeEstada
			SELECT * FROM dbo.AlojamentoEstada
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.Hóspede
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** EXECUTA TESTES ************************************************************/
EXEC dbo.testaInsert

EXEC dbo.testaUpdate

EXEC dbo.testaDelete