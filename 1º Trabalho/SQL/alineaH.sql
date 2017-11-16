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
CREATE PROCEDURE dbo.createEstada @NIFRespons�vel INT, @tempoEstada INT, @idNumber INT OUTPUT AS -- em minutos
	BEGIN TRY
		BEGIN TRANSACTION
			SELECT @idNumber = COUNT(id) + 1 FROM dbo.Estada
			
			INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
				VALUES(@idNumber, GETDATE(), DATEADD(MINUTE, @tempoEstada, GETDATE()))

			INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
				VALUES(@NifRespons�vel, @idNumber, 'true')

		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na cria��o da estada', 5, 1)
		ROLLbACK
	END CATCH

/*************************************** Adicionar alojamento ***********************************************************/
GO
CREATE PROCEDURE dbo.addAlojamento @tipoAlojamento VARCHAR(8), @lota��o TINYINT, @idEstada INT AS
	BEGIN TRY
		BEGIN TRANSACTION	-- select e insert tem de ser seguido 
			DECLARE @nomeParque NVARCHAR(30)
			DECLARE @localiza��o NVARCHAR(30)

			SELECT @nomeParque = AlojEst.nomeParque, @localiza��o = AlojEst.localiza��o FROM dbo.Alojamento AS Aloj LEFT JOIN dbo.AlojamentoEstada AS AlojEst 
			ON Aloj.nomeParque = AlojEst.nomeParque AND Aloj.localiza��o = AlojEst.localiza��o 
			JOIN dbo.Estada as Est ON Est.id = AlojEst.id
			WHERE Aloj.tipoAlojamento = @tipoAlojamento AND Aloj.n�meroM�ximoPessoas = @lota��o AND Est.dataFim < GETDATE()

			INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id)
				VALUES(@nomeParque, @localiza��o, @idEstada)

			INSERT INTO dbo.EstadaExtra(estadaId, extraId)
				SELECT @idEstada, id FROM dbo.AlojamentoExtra WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na adi��o do alojamento a estada', 5, 2)
		ROLLBACK
	END CATCH

/*************************************** Adicionar h�spede a Estada ***********************************************************/
GO
CREATE PROCEDURE dbo.addH�spede @NIF INT, @id INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
				VALUES(@NIF, @id, 'false')
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na adi��o do h�spede a estada', 5, 3)
		ROLLBACK
	END CATCH

/*************************************** Adicionar extra a um alojamento de uma Estada ***********************************************************/
GO	
CREATE PROCEDURE dbo.addExtraToAlojamento @idExtra INT, @idEstada INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @nomeParque NVARCHAR(30)
			DECLARE @localiza��o NVARCHAR(30)
			DECLARE @associado VARCHAR(10)

			SELECT @associado = associado FROM dbo.Extra WHERE id = @idExtra
			
			IF(@associado <> 'alojamento')
				RAISERROR('Extra n�o � de pessoal', 15, 5)
			ELSE
				BEGIN
					SELECT @nomeParque = nomeParque, @localiza��o = localiza��o FROM dbo.AlojamentoEstada WHERE id = @idEstada

					INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
						VALUES(@nomeParque, @localiza��o, @idExtra)
				END
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na adi��o de um extra a um alojamento de uma estada', 5, 4)
		ROLLBACK
	END CATCH 
		
/*************************************** Adicionar extra pessoal a uma Estada ***********************************************************/
GO
CREATE PROCEDURE dbo.addExtraToEstada @idExtra INT, @idEstada INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @associado VARCHAR(10)

			SELECT @associado = associado FROM dbo.Extra WHERE id = @idExtra

			IF(@associado <> 'pessoa')
				RAISERROR('Extra n�o � de pessoal', 15, 5)
			ELSE
				INSERT INTO dbo.EstadaExtra(estadaId, extraId)
					VALUES(@idEstada, @idExtra)
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na adi��o de um extra pessoal a uma estada', 5, 6)
		ROLLBACK
	END CATCH 

/*************************************** Adicionar extra pessoal a uma Estada ***********************************************************/
GO
CREATE PROCEDURE dbo.createEstadaInTime @NIFRespons�vel INT, @NIFH�spede INT, @tempoEstada INT, @tipoAlojamento VARCHAR(8), @lota��o TINYINT, @idExtraPessoal INT, @idExtraAlojamento INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @id INT
			EXEC dbo.createEstada @NIFRespons�vel, @tempoEstada, @idNumber = @id OUTPUT

			EXEC dbo.addAlojamento @tipoAlojamento, @lota��o, @id

			EXEC dbo.addH�spede @NIFH�spede, @id

			EXEC dbo.addExtraToAlojamento @idExtraAlojamento, @id

			EXEC dbo.addExtraToEstada @idExtraPessoal, @id
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro na adi��o de uma estada', 5, 7)
		ROLLBACK
	END CATCH

/*************************************** Teste ************************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	      (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T5'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T5'

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 1', 1),
		   ('Glampinho', 'Rua 2', 2),
		   ('Glampinho', 'Rua 4', 3),
		   ('Glampinho', 'Rua 7', 4)

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

EXEC dbo.createEstada 112233445, 60, @idTemp

EXEC dbo.addAlojamento 'tenda', 10, 6

EXEC dbo.addH�spede 566778899, 6

EXEC dbo.addExtraToAlojamento 1, 6

EXEC dbo.addExtraToEstada 2, 6

/* Testar procedure final */
EXEC dbo.createEstadaInTime 112233445, 566778899, 60, 'tenda', 10, 2, 3