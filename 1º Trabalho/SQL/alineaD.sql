/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Cria��o    06/11/17
**
******************************************************************************/
USE Glampinho

/******************************* INSERTS ***********************************************************/
/******************************* INSERT Bungalow ***************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'InsertAlojamentoBungalow')
	DROP PROCEDURE dbo.InsertAlojamentoBungalow;
GO
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
												@descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @tipologia CHAR(2) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, 'bungalow')

		INSERT INTO dbo.Bungalow(nomeParque, localiza��o, tipologia)
			VALUES(@nomeParque, @localiza��o, @tipologia)
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
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
										   @descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @�rea INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, 'tenda')

		INSERT INTO dbo.Tenda(nomeParque, localiza��o, �rea)
			VALUES(@nomeParque, @localiza��o, @�rea)
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
CREATE PROCEDURE dbo.UpdateAlojamento @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @descri��o NVARCHAR(30), @nomeParque NVARCHAR(30), @localiza��o NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		UPDATE dbo.Alojamento SET pre�oBase = @pre�oBase, n�meroM�ximoPessoas = @n�meroM�ximoPessoas, descri��o = @descri��o WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH	 

/****************************** DELETE ***********************************************************/
/********************************** DELETE H�SPEDES ASSOCIADOS ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaH�spedesAssociados')
	DROP PROCEDURE dbo.eliminaH�spedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaH�spedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		DECLARE @NIFH�spede INT
		DECLARE @count INT

		DECLARE h�spedesAssociados CURSOR FOR SELECT NIF FROM dbo.H�spedeEstada WHERE id = @idEstada

		OPEN h�spedesAssociados
		FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.H�spede WHERE NIF = @NIFH�spede
			END
			
			FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede
		END

		CLOSE h�spedesAssociados
		DEALLOCATE h�spedesAssociados
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
CREATE PROCEDURE dbo.deleteAlojamento @localiza��o NVARCHAR(30), @nomeParque NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DECLARE @idEstada INT
		DECLARE eliminaAlojamentoInfo CURSOR FOR SELECT id FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o

		OPEN eliminaAlojamentoInfo
		FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(id) FROM dbo.AlojamentoEstada WHERE id = @idEstada) = 1
				BEGIN
					EXEC dbo.eliminaH�spedesAssociados @idEstada
					DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada
					DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
					DELETE FROM dbo.Estada WHERE id = @idEstada

				END
				ELSE
					DELETE FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
				FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada
		END

		CLOSE eliminaAlojamentoInfo
		DEALLOCATE eliminaAlojamentoInfo

		DELETE FROM dbo.AlojamentoExtra WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
		DELETE FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
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
	
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'Ant�nio', 'Rua 4', 'antonio@gmail.com', 44556677)

EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeiro bungalow do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', 'Lote 2', 'bonito', 12, 4, 50

INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 1, 'false'),
		   (566778899, 1, 'true' ),
		   (123456789, 2, 'true' ),
		   (123243546, 2, 'false'),
		   (112233445, 2, 'false')

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 12, 'pessoa')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Lote 1', 1, 60),
		   ('Glampinho', 'Lote 2', 2, 12) 

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Lote 1', 1)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (1, 1, 12),
		   (2, 1, 12)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.H�spede	
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Tenda	
SELECT * FROM dbo.Estada
SELECT * FROM dbo.H�spedeEstada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra

EXEC dbo.deleteAlojamento 'Lote 1','Glampinho'
EXEC dbo.deleteAlojamento 'Lote 2','Glampinho'

EXEC dbo.UpdateAlojamento 50, 10, 'bst', 'Glampinho', 'Lote 1'