/*******************************************************************************
**	Nome               alineaJ
**	
**	Objectivo          O objectivo deste script é o de proceder ao pagamento 
**						devido por uma estada, emitindo a respectiva factura.
**					   Para isso, deve-se calcular o valor a pagar pelo 
**						alojamento, as actividades e os extras.
**
**	Criado por         Grupo 4 
**	Data de Criação    14/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Retirar preço base  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getAlojamentoPreço')
	DROP PROCEDURE dbo.getAlojamentoPreço;
GO
CREATE PROCEDURE dbo.getAlojamentoPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY descrição) + @linha, 1, AlojEst.preçoBase, Aloj.descrição, 'alojamento' FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
					ON AlojEst.localização = Aloj.localização AND AlojEst.nomeParque = Aloj.nomeParque WHERE id = @idEstada
					
			SELECT @novaLinha = @@ROWCOUNT + @linha
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH	 
	
/*************************************** Retirar preço total dos extras de alojamento ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getEstadaExtrasPreço')
	DROP PROCEDURE dbo.getEstadaExtrasPreço;
GO
CREATE PROCEDURE dbo.getEstadaExtrasPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS	-- vai buscar o total a pagar de acordo com os extras para estada
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			DECLARE @totalDias INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias, EstExt.preçoDia * @totalDias, Ext.descrição, 'extra' 
					FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra AS Ext ON EstExt.extraId = Ext.id 
					WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'alojamento'

			SELECT @novaLinha = @@ROWCOUNT + @linha
		COMMiT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Retirar preço total dos extras de alojamento ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getPessoalExtrasPreço')
	DROP PROCEDURE dbo.getPessoalExtrasPreço;
GO
CREATE PROCEDURE dbo.getPessoalExtrasPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS  -- vai buscar o total a pagar de acordo com os extras para pessoal
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @totalDias INT
			DECLARE @totalHóspedes INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @totalHóspedes = COUNT(NIF) FROM dbo.HóspedeEstada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias * @totalHóspedes, EstExt.preçoDia * @totalDias * @totalHóspedes, Ext.descrição, 'extra' 
					FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
			
			SELECT @novaLinha = @@ROWCOUNT + @linha
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Retirar preço total das actividade ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getCustoTotalActividades')
	DROP PROCEDURE dbo.getCustoTotalActividades;
GO
CREATE PROCEDURE dbo.getCustoTotalActividades @idEstada INT, @idFactura INT, @ano INT, @linha INT AS	-- vai buscar o custo total das actividades
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Act.descrição) + @linha, COUNT(Paga.númeroSequencial), Paga.preçoParticipante * COUNT(Paga.númeroSequencial), Act.descrição, 'actividade' 
					FROM dbo.HóspedeEstada AS HosEst JOIN dbo.Paga ON HosEst.NIF = Paga.NIF JOIN dbo.Actividades as Act 
						ON Paga.nomeParque = Act.nomeParque AND Paga.númeroSequencial = Act.númeroSequencial WHERE HosEst.id = @idEstada
						GROUP BY Act.descrição, Paga.preçoParticipante
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/*************************************** Adicionar preço total à factura ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addPreçoTotal')
	DROP PROCEDURE dbo.addPreçoTotal;
GO
CREATE PROCEDURE dbo.addPreçoTotal @idFactura INT, @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @preçoTotal INT

			SELECT @preçoTotal = SUM(preço) FROM Item WHERE idFactura = @idFactura AND ano = @ano

			UPDATE dbo.Factura SET preçoTotal = @preçoTotal WHERE id = @idFactura AND ano = @ano
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Terminar Estada e apresentar factura ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'finishEstadaWithFactura')
	DROP PROCEDURE dbo.finishEstadaWithFactura;
GO
CREATE PROCEDURE dbo.finishEstadaWithFactura @idEstada INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			DECLARE @NIFResponsável INT
			DECLARE @idFactura INT
			DECLARE @ano INT	
			DECLARE @novaLinha INT 
			DECLARE @data DATE
			DECLARE @nomeResponsável NVARCHAR(30)

			IF NOT EXISTS (SELECT 1 FROM dbo.Estada WHERE id = @idEstada)
				THROW 51000, 'A estada não existe', 1

			SELECT @ano = YEAR(GETDATE())

			SELECT @NIFResponsável = Hosp.NIF, @nomeResponsável = Hosp.nome FROM dbo.HóspedeEstada AS HospEst JOIN dbo.Hóspede AS Hosp 
				ON HospEst.NIF = Hosp.NIF WHERE HospEst.id = @idEstada AND HospEst.hóspede = 'true'

			SELECT @idFactura = COUNT(id) + 1 FROM dbo.Factura WHERE ano = @ano
			
			INSERT INTO dbo.Factura(id, ano, NIFHóspede, nomeHóspede, preçoTotal)
				VALUES (@idFactura, @ano, @NIFResponsável, @nomeResponsável, 0)	
			
			UPDATE Estada SET idFactura=@idFactura, ano = @ano WHERE id=@idEstada

			EXEC dbo.getAlojamentoPreço @idEstada, @idFactura, @ano, 0, @novaLinha OUTPUT

			EXEC dbo.getEstadaExtrasPreço @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getPessoalExtrasPreço @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getCustoTotalActividades @idEstada, @idFactura, @ano, @novaLinha

			EXEC dbo.addPreçoTotal @idFactura, @ano
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Teste ************************************************************************/
GO
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua Manel', 'manel@test.com', 99001122)

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataInício, dataFim,nomeParque)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00','Glampinho'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00','Glampinho'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00','Glampinho'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00','Glampinho'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00','Glampinho')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 1, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 1, 15)

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 4', 3)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
	VALUES (3, 1, 10),
		   (3, 2, 15),
		   (3, 3, 20)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (123456789, 3, 'true'),
		   (566778899, 3, 'false'),
		   (123456789, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', 14, 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', 10, 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3),
		   ('Glampinho', 2, 2017, 112233445, 2),
		   ('Glampinho', 2, 2017, 566778899, 2)

SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.EstadaExtra
SELECT * FROM dbo.Extra
SELECT * FROM dbo.HóspedeEstada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Factura
SELECT * FROM dbo.Item

DECLARE @novaLinha INT 
EXEC dbo.getAlojamentoPreço 3, 1, 2017, 0, @novaLinha OUTPUT

EXEC dbo.getEstadaExtrasPreço 3, 1, 2017, @novaLinha, @novaLinha OUTPUT

EXEC dbo.getPessoalExtrasPreço 3, 1, 2017, @novaLinha, @novaLinha OUTPUT

EXEc dbo.getCustoTotalActividades 3, 1, 2017, @novaLinha

/* Corre versão final da criação da factura */
EXEC dbo.finishEstadaWithFactura 3