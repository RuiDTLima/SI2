/*******************************************************************************
**	Nome               alineaH
**	
**	Objectivo          O objectivo deste script é o de criar uma estada, seguindo os seguintes sub-processamentos:
**
**					   1. Criar uma estada dado o NIF do hóspede responsável e o período temporal
**						pretendido;
**					   2. Adicionar um alojamento de um dado tipo com uma determinada lotação a
**						uma estada;
**					   3. Adicionar um hóspede a uma estada;
**					   4. Adicionar um extra a um alojamento de uma estada;
**					   5. Adicionar um extra pessoal a uma estada; 
**
**	Criado por         Grupo 4 
**	Data de Criação    09/11/17
**
******************************************************************************/
USE Glampinho
/*************************************** Criar uma estada *************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'createEstada')
	DROP PROCEDURE dbo.createEstada;
GO  
CREATE PROCEDURE dbo.createEstada @NIFResponsável INT, @tempoEstada INT, @idNumber INT OUTPUT AS -- em minutos
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			DECLARE @date DATETIME2

			SELECT @date = GETDATE()

			SELECT @idNumber = MAX(id) + 1 FROM dbo.Estada
			
			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES(@idNumber, @date, DATEADD(DAY, @tempoEstada, @date))

			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES(@NifResponsável, @idNumber, 'true')

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
CREATE PROCEDURE dbo.addAlojamento @tipoAlojamento VARCHAR(8), @lotação TINYINT, @idEstada INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- select e insert tem de ser seguido, para os dados que se vai inserir na tabela nao serem alterados sem saber 
			DECLARE @nomeParque NVARCHAR(30)
			DECLARE @localização NVARCHAR(30)
			DECLARE @preçoBase INT

			SELECT @nomeParque = AlojEst.nomeParque, @localização = AlojEst.localização, @preçoBase = Aloj.preçoBase FROM dbo.Alojamento AS Aloj LEFT JOIN dbo.AlojamentoEstada AS AlojEst 
				ON Aloj.nomeParque = AlojEst.nomeParque AND Aloj.localização = AlojEst.localização 
				JOIN dbo.Estada as Est ON Est.id = AlojEst.id
				WHERE Aloj.tipoAlojamento = @tipoAlojamento AND Aloj.númeroMáximoPessoas = @lotação AND Est.dataFim < GETDATE()

			INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
				VALUES(@nomeParque, @localização, @idEstada, @preçoBase)

			INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
				SELECT @idEstada, E.id, E.preçoDia FROM dbo.AlojamentoExtra AS AlojExtra JOIN dbo.Extra AS E ON AlojExtra.id = E.id WHERE nomeParque = @nomeParque AND localização = @localização
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Adicionar hóspede a Estada ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addHóspede')
	DROP PROCEDURE dbo.addHóspede;
GO
CREATE PROCEDURE dbo.addHóspede @NIF INT, @id INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
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
			DECLARE @localização NVARCHAR(30)
			DECLARE @associado VARCHAR(10)

			SELECT @associado = associado FROM dbo.Extra WHERE id = @idExtra
			
			IF(@associado <> 'alojamento')
				THROW 51000, 'Extra não é de pessoal', 5
			ELSE
				BEGIN
					SELECT @nomeParque = nomeParque, @localização = localização FROM dbo.AlojamentoEstada WHERE id = @idEstada

					INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
						VALUES(@nomeParque, @localização, @idExtra)
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
			DECLARE @preçoDia INT

			SELECT @associado = associado, @preçoDia = preçoDia FROM dbo.Extra WHERE id = @idExtra

			IF(@associado <> 'pessoa')
				THROW 51000, 'Extra não é de pessoal', 5
			ELSE
				INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
					VALUES(@idEstada, @idExtra, @preçoDia)
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
CREATE PROCEDURE dbo.createEstadaInTime @NIFResponsável INT, @NIFHóspede INT, @tempoEstada INT, @tipoAlojamento VARCHAR(8), @lotação TINYINT, @idExtraPessoal INT, @idExtraAlojamento INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE	-- durante a criação de uma estada não pode haver nenhuma alteração ao estado da base de dados devido em especial ao preços
			DECLARE @id INT
			EXEC dbo.createEstada @NIFResponsável, @tempoEstada,@id OUTPUT

			EXEC dbo.addAlojamento @tipoAlojamento, @lotação, @id

			EXEC dbo.addHóspede @NIFHóspede, @id

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

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	      (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (6, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 2, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 4, 15)

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 4', 1)

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Tenda
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.HóspedeEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra
/* Para testar cada procedure individualmente */
DECLARE @idTemp INT

EXEC dbo.createEstada 112233445, 5, @idTemp OUTPUT

EXEC dbo.addAlojamento 'tenda', 10, @idTemp

EXEC dbo.addHóspede 566778899, @idTemp

EXEC dbo.addExtraToAlojamento 3, @idTemp

EXEC dbo.addExtraToEstada 2, @idTemp

/* Testar procedure final */
EXEC dbo.createEstadaInTime 112233445, 566778899, 5, 'tenda', 10, 2, 3