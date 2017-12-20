/*******************************************************************************
**	Nome               alineaH
**	
**	Objectivo          O objectivo deste script � o de criar uma estada, seguindo os seguintes sub-processamentos:
**
**					   1. Criar uma estada dado o NIF do h�spede respons�vel e o per�odo temporal
**						pretendido;
**					   2. Adicionar um alojamento de um dado tipo com uma determinada lota��o a
**						uma estada;
**					   3. Adicionar um h�spede a uma estada;
**					   4. Adicionar um extra a um alojamento de uma estada;
**					   5. Adicionar um extra pessoal a uma estada; 
**
**	Criado por         Grupo 4 
**	Data de Cria��o    09/11/17
**
******************************************************************************/
USE Glampinho
/*************************************** Criar uma estada *************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'createEstada')
	DROP PROCEDURE dbo.createEstada;
GO  
CREATE PROCEDURE dbo.createEstada @NIFRespons�vel INT, @tempoEstada INT, @idNumber INT OUTPUT AS -- em minutos
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			DECLARE @date DATETIME2

			SELECT @date = GETDATE()

			SELECT @idNumber = MAX(id) + 1 FROM dbo.Estada
			
			INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
				VALUES(@idNumber, @date, DATEADD(DAY, @tempoEstada, @date))

			INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
				VALUES(@NifRespons�vel, @idNumber, 'true')

		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Adicionar alojamento ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addAlojamento')
	DROP PROCEDURE dbo.addAlojamento;
GO
CREATE PROCEDURE dbo.addAlojamento @tipoAlojamento VARCHAR(8), @lota��o TINYINT, @idEstada INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- select e insert tem de ser seguido, para os dados que se vai inserir na tabela nao serem alterados sem saber 
			DECLARE @nomeParque NVARCHAR(30)
			DECLARE @localiza��o NVARCHAR(30)
			DECLARE @pre�oBase INT

			SELECT @nomeParque = AlojEst.nomeParque, @localiza��o = AlojEst.localiza��o, @pre�oBase = Aloj.pre�oBase FROM dbo.Alojamento AS Aloj LEFT JOIN dbo.AlojamentoEstada AS AlojEst 
				ON Aloj.nomeParque = AlojEst.nomeParque AND Aloj.localiza��o = AlojEst.localiza��o 
				JOIN dbo.Estada as Est ON Est.id = AlojEst.id
				WHERE Aloj.tipoAlojamento = @tipoAlojamento AND Aloj.n�meroM�ximoPessoas = @lota��o AND Est.dataFim < GETDATE()

			INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
				VALUES(@nomeParque, @localiza��o, @idEstada, @pre�oBase)

			INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
				SELECT @idEstada, E.id, E.pre�oDia FROM dbo.AlojamentoExtra AS AlojExtra JOIN dbo.Extra AS E ON AlojExtra.id = E.id WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Adicionar h�spede a Estada ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addH�spede')
	DROP PROCEDURE dbo.addH�spede;
GO
CREATE PROCEDURE dbo.addH�spede @NIF INT, @id INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
				VALUES(@NIF, @id, 'false')
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Adicionar extra a um alojamento de uma Estada ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addExtraToAlojamento')
	DROP PROCEDURE dbo.addExtraToAlojamento;
GO	
CREATE PROCEDURE dbo.addExtraToAlojamento @idExtra INT, @idEstada INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @nomeParque NVARCHAR(30)
			DECLARE @localiza��o NVARCHAR(30)
			DECLARE @associado VARCHAR(10)

			SELECT @associado = associado FROM dbo.Extra WHERE id = @idExtra
			
			IF(@associado <> 'alojamento')
				THROW 51000, 'Extra n�o � de pessoal', 5
			ELSE
				BEGIN
					SELECT @nomeParque = nomeParque, @localiza��o = localiza��o FROM dbo.AlojamentoEstada WHERE id = @idEstada

					INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
						VALUES(@nomeParque, @localiza��o, @idExtra)
				END
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH 
		
/*************************************** Adicionar extra pessoal a uma Estada ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addExtraToEstada')
	DROP PROCEDURE dbo.addExtraToEstada;
GO
CREATE PROCEDURE dbo.addExtraToEstada @idExtra INT, @idEstada INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @associado VARCHAR(10)
			DECLARE @pre�oDia INT

			SELECT @associado = associado, @pre�oDia = pre�oDia FROM dbo.Extra WHERE id = @idExtra

			IF(@associado <> 'pessoa')
				THROW 51000, 'Extra n�o � de pessoal', 5
			ELSE
				INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
					VALUES(@idEstada, @idExtra, @pre�oDia)
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH 

/*************************************** Create Estada ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'createEstadaInTime')
	DROP PROCEDURE dbo.createEstadaInTime;
GO
CREATE PROCEDURE dbo.createEstadaInTime @NIFRespons�vel INT, @NIFH�spede INT, @tempoEstada INT, @tipoAlojamento VARCHAR(8), @lota��o TINYINT, @idExtraPessoal INT, @idExtraAlojamento INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE	-- durante a cria��o de uma estada n�o pode haver nenhuma altera��o ao estado da base de dados devido em especial ao pre�os
			DECLARE @id INT
			EXEC dbo.createEstada @NIFRespons�vel, @tempoEstada,@id OUTPUT

			EXEC dbo.addAlojamento @tipoAlojamento, @lota��o, @id

			EXEC dbo.addH�spede @NIFH�spede, @id

			EXEC dbo.addExtraToAlojamento @idExtraAlojamento, @id

			EXEC dbo.addExtraToEstada @idExtraPessoal, @id
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Teste ************************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	      (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (6, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 4, 15)

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 4', 1)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Tenda
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.H�spedeEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra
/* Para testar cada procedure individualmente */
DECLARE @idTemp INT

EXEC dbo.createEstada 112233445, 5, @idTemp OUTPUT

EXEC dbo.addAlojamento 'tenda', 10, @idTemp

EXEC dbo.addH�spede 566778899, @idTemp

EXEC dbo.addExtraToAlojamento 3, @idTemp

EXEC dbo.addExtraToEstada 2, @idTemp

/* Testar procedure final */
EXEC dbo.createEstadaInTime 112233445, 566778899, 5, 'tenda', 10, 2, 3