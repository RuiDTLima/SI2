/*******************************************************************************
**	Nome               testeAlineaD
**	
**	Objectivo          O objectivo deste script é o de testar o correcto 
**						funcionamento da alinea D
**
**	Criado por         Grupo 4 
**	Data de Criação    19/11/17
**
******************************************************************************/
use Glampinho

/********************************** TESTA alinea C ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaC')
	DROP PROCEDURE dbo.testeAlineaC;
GO
CREATE PROC dbo.testeAlineaC AS
SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts

			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.HóspedeEstada

			EXEC dbo.deleteHospede 112233445
			EXEC dbo.deleteHospede 566778899

			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.HóspedeEstada
		ROLLBACK
		END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA alinea D ************************************************************/
/********************************** TESTA INSERT BUNGALOW ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testaInsertAlojamentoBungalow')
	DROP PROCEDURE dbo.testaInsertAlojamentoBungalow;
GO
CREATE PROCEDURE dbo.testaInsertAlojamentoBungalow AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts

			EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Teste', 'Lote teste', 'bungalow teste', 60, 12, 'T0'

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Bungalow
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA INSERT TENDA ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testaInsertAlojamentoTenda')
	DROP PROCEDURE dbo.testaInsertAlojamentoTenda;
GO
CREATE PROCEDURE dbo.testaInsertAlojamentoTenda AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			EXEC dbo.inserts

			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'teste tenda', 'Lote teste tenda', 'bonito', 12, 4, 50

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Tenda
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA DELETE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaD_DELETE')
	DROP PROCEDURE dbo.testeAlineaD_DELETE;
GO
CREATE PROC dbo.testeAlineaD_DELETE AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
					   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
					   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
					   (123243546, 'António', 'Rua 4', 'antonio@gmail.com', 44556677)

			EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'T3'
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

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Tenda
			SELECT * FROM dbo.Bungalow

			EXEC dbo.deleteAlojamento 'Lote 1','Glampinho'
			EXEC dbo.deleteAlojamento 'Lote 2','Glampinho'

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Tenda
			SELECT * FROM dbo.Bungalow
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA alinea E ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaE')
	DROP PROCEDURE dbo.testeAlineaE;
GO
CREATE PROC dbo.testeAlineaE AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
				VALUES (1,'descricao', 12, 'alojamento'),
					   (2, 'erro', 20, 'pessoa')

			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'vermelho', '12EA1', 'bonito', 12, 4, 50

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-03-15 10:03:00', '2017-03-20 13:00:00')

			INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
				VALUES ('Glampinho', '12EA1', 1)

			INSERT INTO dbo.EstadaExtra(estadaId, ExtraId, preçoDia)
				VALUES(1, 1, 12)

			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.EstadaExtra

			EXEC dbo.deleteExtra 1
			EXEC dbo.deleteExtra 2
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		print 'Extra 2 tem de ser de alojamento'
		SELECT * FROM dbo.Extra
		SELECT * FROM dbo.Alojamento
		SELECT * FROM dbo.Estada
		SELECT * FROM dbo.AlojamentoExtra
		SELECT * FROM dbo.EstadaExtra
	END CATCH

/********************************** TESTA alinea F ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaF')
	DROP PROCEDURE dbo.testeAlineaF;
GO
CREATE PROC dbo.testeAlineaF AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
				VALUES (1,'descricao', 12, 'alojamento'),
					   (2, 'erro', 20, 'pessoa')

			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'vermelho', '12EA1', 'bonito', 12, 4, 50

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-03-15 10:03:00', '2017-03-20 13:00:00')

			INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
				VALUES ('Glampinho', '12EA1', 1)

			INSERT INTO dbo.EstadaExtra(estadaId, ExtraId, preçoDia)
				VALUES(1, 1, 12)

			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.EstadaExtra

			EXEC dbo.deleteExtraPessoa 2
			EXEC dbo.deleteExtraPessoa 1
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		print ' O extra 1 devia ser de pessoal'

		SELECT * FROM dbo.Extra
		SELECT * FROM dbo.Alojamento
		SELECT * FROM dbo.Estada
		SELECT * FROM dbo.AlojamentoExtra
		SELECT * FROM dbo.EstadaExtra
	END CATCH

/********************************** TESTA alinea G ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaG')
	DROP PROCEDURE dbo.testeAlineaG;
GO
CREATE PROC dbo.testeAlineaG AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344)

			INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
				VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00'),
					   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-11-19 10:30:00')

			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
				VALUES ('Glampinho', 1, 2017, 112233445, 3),
					   ('Glampinho', 2, 2017, 112233445, 2)

			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.Paga
			SELECT * FROM dbo.Actividades

			exec dbo.deleteAtividades 'Glampinho', 1, 2017

			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.Paga
			SELECT * FROM dbo.Actividades
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/********************************** TESTA alinea H ************************************************************/
/********************************** TESTA procedure CreateEstada ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHCreateEstada')
	DROP PROCEDURE dbo.testeAlineaHCreateEstada;
GO
CREATE PROC dbo.testeAlineaHCreateEstada AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			
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
			
			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Estada

			DECLARE @idTemp INT
			EXEC dbo.createEstada 112233445, 5, @idTemp OUTPUT

			SELECT @idTemp AS id
			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Estada
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA procedure addAlojamento ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHAddAlojamento')
	DROP PROCEDURE dbo.testeAlineaHAddAlojamento;
GO
CREATE PROC dbo.testeAlineaHAddAlojamento AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

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
			SELECT * FROM dbo.EstadaExtra

			EXEC dbo.addAlojamento 'tenda', 10, 6

			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Tenda
			SELECT * FROM dbo.Bungalow
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.AlojamentoEstada
			SELECT * FROM dbo.EstadaExtra
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA procedure addHóspede ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHAddHóspede')
	DROP PROCEDURE dbo.testeAlineaHAddHóspede;
GO
CREATE PROC dbo.testeAlineaHAddHóspede AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
					  (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
	
			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
					   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
					   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
					   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
					   (6, '2017-08-10 10:00:00', '2017-09-11 10:00:00')
			
			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.HóspedeEstada

			EXEC dbo.addHóspede 566778899, 2

			SELECT * FROM dbo.Hóspede
			SELECT * FROM dbo.HóspedeEstada
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/********************************** TESTA procedure addExtraToAlojamento ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHAddExtraToAlojamento')
	DROP PROCEDURE dbo.testeAlineaHAddExtraToAlojamento;
GO
CREATE PROC dbo.testeAlineaHAddExtraToAlojamento AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

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

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.AlojamentoEstada

			EXEC dbo.addExtraToAlojamento 3, 1

			SELECT * FROM dbo.Alojamento
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.AlojamentoEstada
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA procedure addExtraToEstada ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHAddExtraToEstada')
	DROP PROCEDURE dbo.testeAlineaHAddExtraToEstada;
GO
CREATE PROC dbo.testeAlineaHAddExtraToEstada AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
		
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
					   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
					   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
					   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
					   (6, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

			INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
				VALUES (1, 'descricao', 10, 'alojamento'), 
					   (2, 'teste', 15, 'pessoa'), 
					   (3, 'metodo', 20, 'alojamento')

			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.EstadaExtra

			EXEC dbo.addExtraToEstada 2, 1

			SELECT * FROM dbo.ParqueCampismo
			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.EstadaExtra
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/********************************** TESTA procedure createEstadaInTime ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaHCreateEstadaInTime')
	DROP PROCEDURE dbo.testeAlineaHCreateEstadaInTime;
GO
CREATE PROC dbo.testeAlineaHCreateEstadaInTime AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
		
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

			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.AlojamentoEstada
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.HóspedeEstada
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.EstadaExtra

			EXEC dbo.createEstadaInTime 112233445, 566778899, 5, 'tenda', 10, 2, 3

			SELECT * FROM dbo.Estada
			SELECT * FROM dbo.AlojamentoEstada
			SELECT * FROM dbo.Extra
			SELECT * FROM dbo.HóspedeEstada
			SELECT * FROM dbo.AlojamentoExtra
			SELECT * FROM dbo.EstadaExtra
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA alinea I ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaI')
	DROP PROCEDURE dbo.testeAlineaI;
GO
CREATE PROC dbo.testeAlineaI AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (1, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)
	       
			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-10-15 13:00:00', '2018-03-16 13:00:00')
		
			INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
				VALUES ('Glampinho', 'Rua 1', 1, 12)
		
			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES (1, 1, 'true')

			INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
				VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00')

			SELECT * FROM dbo.Paga
			EXEC dbo.inscreverHóspede 1, 1,'Glampinho', 2017
			SELECT * FROM dbo.Paga
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
		
/********************************** TESTA alinea J ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaJ')
	DROP PROCEDURE dbo.testeAlineaJ;
GO
CREATE PROC dbo.testeAlineaJ AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)
	      
			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00')
		
			INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
				VALUES ('Glampinho', 'Rua 1', 1, 12)
		  
			INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
				VALUES (1, 'descricao', 10, 'alojamento'), 
					   (2, 'teste', 15, 'pessoa'), 
					   (3, 'metodo', 20, 'alojamento')

			INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
				VALUES ('Glampinho', 'Rua 1', 1),
					   ('Glampinho', 'Rua 1', 2),
					   ('Glampinho', 'Rua 1', 3)

			INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
				VALUES (1, 1, 10),
					   (1, 2, 15),
					   (1, 3, 20)

			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES (112233445, 1, 'true')
		   
			INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
				VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00')
		   
			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
				VALUES ('Glampinho', 1, 2017, 112233445, 3)

			SELECT * FROM dbo.Factura
			SELECT * FROM dbo.Item

			EXEC dbo.finishEstadaWithFactura 1

			SELECT* FROM dbo.Factura
			SELECT * FROM dbo.Item
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
		  
/********************************** TESTA alinea K ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaK')
	DROP PROCEDURE dbo.testeAlineaK;
GO
CREATE PROC dbo.testeAlineaK AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES	(2, '2017-11-20', '2017-11-27'),
						(3, '2017-11-20', '2017-11-27')
			
			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (1, 'Teste1', 'Rua teste', 'teste@teste.com', 11223344),
					   (2, 'Teste2', 'Rua teste', 'teste@teste.com', 11223344),
					   (3, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344)

			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES	(1, 2, 'true'),
						(2, 2, 'false'),
						(3, 3, 'true')

			EXEC dbo.sendEmails 365
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA alinea L ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaL')
	DROP PROCEDURE dbo.testeAlineaL;
GO
CREATE PROC dbo.testeAlineaL AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES (1, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)	       
	
			EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

			INSERT INTO dbo.Estada(id, dataInício, dataFim)
				VALUES (1, '2017-10-15 13:00:00', '2018-03-16 13:00:00')
		
			INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
				VALUES ('Glampinho', 'Rua 1', 1, 12)
		
			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES (1, 1, 'true')

			INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
				VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00')

			INSERT INTO dbo.Paga(ano,NIF,nomeParque,númeroSequencial,preçoParticipante)
				VALUES (2017,1,'Glampinho',1,3)

			EXEC dbo.listarAtividades '2017-11-15' ,'2017-11-16' 
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA alinea M ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaM')
	DROP PROCEDURE dbo.testeAlineaM;
GO
CREATE PROC dbo.testeAlineaM AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
			VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

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
					   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

			INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
				VALUES ('Glampinho', 'Rua 1', 1, 12),
					   ('Glampinho', 'Rua 2', 1, 15),
					   ('Glampinho', 'Rua 4', 3, 15),
					   ('Glampinho', 'Rua 5', 2, 11),
					   ('Glampinho', 'Rua 6', 4, 70),
					   ('Glampinho', 'Rua 7', 5, 22)

			INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
				VALUES (1, 'descricao', 10, 'alojamento'), 
					   (2, 'teste', 15, 'pessoa'), 
					   (3, 'metodo', 20, 'alojamento')

			INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
				VALUES ('Glampinho', 'Rua 4', 1),
					   ('Glampinho', 'Rua 4', 2),
					   ('Glampinho', 'Rua 5', 3),
					   ('Glampinho', 'Rua 6', 3),
					   ('Glampinho', 'Rua 7', 3)

			INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
				VALUES (3, 1, 10),
					   (3, 2, 15),
					   (1, 3, 20),
					   (2, 3, 20),
					   (4, 3, 12),
					   (5, 3, 34)

			INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
				VALUES  (4, 'Teste1', 'Rua teste', 'teste@teste.com', 11223344),
						(2, 'Teste2', 'Rua teste', 'teste@teste.com', 11223344),
						(3, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),
						(123456789, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),	
						(566778899, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),	
						(112233445, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344)			

			INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
				VALUES (112233445, 3, 'true'),
					   (566778899, 3, 'false'),
					   (123456789, 1, 'true'),
					   (2, 2, 'true'),
					   (3, 4, 'true'),
					   (4, 5, 'true')

			INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
				VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00'),
					   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-10-07 10:00:00')

			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
				VALUES ('Glampinho', 1, 2017, 112233445, 3),
					   ('Glampinho', 1, 2017, 566778899, 3),
					   ('Glampinho', 1, 2017, 123456789, 3),
					   ('Glampinho', 2, 2017, 112233445, 2),
					   ('Glampinho', 2, 2017, 566778899, 2),
					   ('Glampinho', 2, 2017, 4, 2),
					   ('Glampinho', 2, 2017, 3, 2),
					   ('Glampinho', 2, 2017, 2, 2)

			EXEC dbo.finishEstadaWithFactura 1
			EXEC dbo.finishEstadaWithFactura 2
			EXEC dbo.finishEstadaWithFactura 3
			EXEC dbo.finishEstadaWithFactura 4
			EXEC dbo.finishEstadaWithFactura 5

			SELECT preçoTotal FROM dbo.Factura

			EXEC dbo.mediaPagamentos 2
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/********************************** TESTA alinea N ************************************************************/
/********************************** TESTA trigger de Insert ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaNTriggerInsert')
	DROP PROCEDURE dbo.testeAlineaNTriggerInsert;
GO
CREATE PROC dbo.testeAlineaNTriggerInsert AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			INSERT INTO dbo.Bungalows(nome, email, estrelas, morada, descrição, localização, nomeAlojamento, númeroMáximoPessoas, preçoBase, tipoAlojamento, tipologia)
				VALUES ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'primeiro bungalow', 'Rua 6', 'Bungalow hoje', 10, 15, 'bungalow', 'T3'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'segundo bungalow', 'Rua 7', 'Bungalow ontem', 9, 15, 'bungalow', 'T3')

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA trigger de Delete ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaNTriggerDelete')
	DROP PROCEDURE dbo.testeAlineaNTriggerDelete;
GO
CREATE PROC dbo.testeAlineaNTriggerDelete AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
				
			INSERT INTO dbo.Bungalows(nome, email, estrelas, morada, descrição, localização, nomeAlojamento, númeroMáximoPessoas, preçoBase, tipoAlojamento, tipologia)
				VALUES ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'primeiro bungalow', 'Rua 6', 'Bungalow hoje', 10, 15, 'bungalow', 'T0'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'segundo bungalow', 'Rua 7', 'Bungalow ontem', 9, 15, 'bungalow', 'T1'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'terceiro bungalow', 'Rua 8', 'Bungalow teste', 9, 15, 'bungalow', 'T2'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'quarto bungalow', 'Rua 9', 'Bungalow imagem', 9, 15, 'bungalow', 'T3')

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow  

			DELETE FROM dbo.Bungalows WHERE nome = 'Glampinho' AND localização = 'Rua 5'

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			DELETE FROM dbo.Bungalows WHERE nome = 'Glampinho' AND localização = 'Rua 6'

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			DELETE FROM dbo.Bungalows

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** TESTA trigger de UPDATE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'testeAlineaNTriggerUpdate')
	DROP PROCEDURE dbo.testeAlineaNTriggerUpdate;
GO
CREATE PROC dbo.testeAlineaNTriggerUpdate AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
				VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
				
			INSERT INTO dbo.Bungalows(nome, email, estrelas, morada, descrição, localização, nomeAlojamento, númeroMáximoPessoas, preçoBase, tipoAlojamento, tipologia)
				VALUES ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'primeiro bungalow', 'Rua 6', 'Bungalow hoje', 10, 15, 'bungalow', 'T0'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'segundo bungalow', 'Rua 7', 'Bungalow ontem', 9, 15, 'bungalow', 'T1'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'terceiro bungalow', 'Rua 8', 'Bungalow teste', 9, 15, 'bungalow', 'T2'),
					   ('Glampinho', 'parque1@email.com', 3, 'campo dos parques', 'quarto bungalow', 'Rua 9', 'Bungalow imagem', 9, 15, 'bungalow', 'T3')

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			UPDATE BUNGALOWS SET preçoBase = 100 WHERE localização = 'Rua 6' 

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			UPDATE BUNGALOWS SET preçoBase = 0 WHERE morada = 'campo dos parques'

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow

			UPDATE BUNGALOWS SET preçoBase = 50 WHERE morada = 'campo parques'

			SELECT * FROM dbo.Bungalows
			SELECT * FROM dbo.Alojamento									 
			SELECT * FROM dbo.Bungalow
		ROLLBACK
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/********************************** A EXECUTAR ************************************************************/
EXEC dbo.testeAlineaC
EXEC dbo.testaInsertAlojamentoBungalow
EXEC dbo.testaInsertAlojamentoTenda
EXEC dbo.testeAlineaD_DELETE
EXEC dbo.testeAlineaE
EXEC dbo.testeAlineaF
EXEC dbo.testeAlineaG
EXEC dbo.testeAlineaHCreateEstada
EXEC dbo.testeAlineaHAddAlojamento
EXEC dbo.testeAlineaHAddHóspede
EXEC dbo.testeAlineaHAddExtraToAlojamento
EXEC dbo.testeAlineaHAddExtraToEstada
EXEC dbo.testeAlineaHCreateEstadaInTime
EXEC dbo.testeAlineaI
EXEC dbo.testeAlineaJ
EXEC dbo.testeAlineaK 
EXEC dbo.testeAlineaL
EXEC dbo.testeAlineaM
EXEC dbo.testeAlineaNTriggerInsert
EXEC dbo.testeAlineaNTriggerDelete
EXEC dbo.testeAlineaNTriggerUpdate