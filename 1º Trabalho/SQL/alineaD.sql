/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Criação    06/11/17
**
******************************************************************************/
USE Glampinho

/******************************* INSERTS ***********************************************************/
/******************************* INSERT Bungalow ***************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'InsertAlojamentoBungalow')
	DROP PROCEDURE dbo.InsertAlojamentoBungalow;
GO
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
												@descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @tipologia CHAR(2) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, 'bungalow')

		INSERT INTO dbo.Bungalow(nomeParque, localização, tipologia)
			VALUES(@nomeParque, @localização, @tipologia)
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* INSERT Tenda ***************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'InsertAlojamentoTenda')
	DROP PROCEDURE dbo.InsertAlojamentoTenda;
GO
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
										   @descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @área INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, 'tenda')

		INSERT INTO dbo.Tenda(nomeParque, localização, área)
			VALUES(@nomeParque, @localização, @área)
		COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* UPDATE ***********************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'UpdateAlojamento')
	DROP PROCEDURE dbo.UpdateAlojamento;
GO
CREATE PROCEDURE dbo.UpdateAlojamento @preçoBase INT, @númeroMáximoPessoas TINYINT, @descrição NVARCHAR(30), @nomeParque NVARCHAR(30), @localização NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		UPDATE dbo.Alojamento SET preçoBase = @preçoBase, númeroMáximoPessoas = @númeroMáximoPessoas, descrição = @descrição WHERE nomeParque = @nomeParque AND localização = @localização
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH	 

/****************************** DELETE ***********************************************************/
/********************************** DELETE HÓSPEDES ASSOCIADOS ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaHóspedesAssociados')
	DROP PROCEDURE dbo.eliminaHóspedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaHóspedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		DECLARE @NIFHóspede INT
		DECLARE @count INT

		DECLARE hóspedesAssociados CURSOR FOR SELECT NIF FROM dbo.HóspedeEstada WHERE id = @idEstada

		OPEN hóspedesAssociados
		FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.Hóspede WHERE NIF = @NIFHóspede
			END
			
			FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede
		END

		CLOSE hóspedesAssociados
		DEALLOCATE hóspedesAssociados
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE ALOJAMENTO ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteAlojamento')
	DROP PROCEDURE dbo.deleteAlojamento;

GO
CREATE PROCEDURE dbo.deleteAlojamento @localização NVARCHAR(30), @nomeParque NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DECLARE @idEstada INT
		DECLARE eliminaAlojamentoInfo CURSOR FOR SELECT id FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localização = @localização

		OPEN eliminaAlojamentoInfo
		FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(id) FROM dbo.AlojamentoEstada WHERE id = @idEstada) = 1
				BEGIN
					EXEC dbo.eliminaHóspedesAssociados @idEstada
					DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada
					DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
					DELETE FROM dbo.Estada WHERE id = @idEstada

				END
				ELSE
					DELETE FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localização = @localização
				FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada
		END

		CLOSE eliminaAlojamentoInfo
		DEALLOCATE eliminaAlojamentoInfo

		DELETE FROM dbo.AlojamentoExtra WHERE nomeParque = @nomeParque AND localização = @localização
		DELETE FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localização = @localização
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** Teste ********************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'António', 'Rua 4', 'antonio@gmail.com', 44556677)

EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeiro bungalow do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', 'Lote 2', 'bonito', 12, 4, 50

INSERT INTO	dbo.Estada(id, dataInício, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (112233445, 1, 'false'),
		   (566778899, 1, 'true' ),
		   (123456789, 2, 'true' ),
		   (123243546, 2, 'false'),
		   (112233445, 2, 'false')

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 12, 'pessoa')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Lote 1', 1, 60),
		   ('Glampinho', 'Lote 2', 2, 12) 

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Lote 1', 1)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
	VALUES (1, 1, 12),
		   (2, 1, 12)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Hóspede	
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Tenda	
SELECT * FROM dbo.Estada
SELECT * FROM dbo.HóspedeEstada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra

EXEC dbo.deleteAlojamento 'Lote 1','Glampinho'
EXEC dbo.deleteAlojamento 'Lote 2','Glampinho'

EXEC dbo.UpdateAlojamento 50, 10, 'bst', 'Glampinho', 'Lote 1'