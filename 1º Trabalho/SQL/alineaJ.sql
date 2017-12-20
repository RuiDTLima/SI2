/*******************************************************************************
**	Nome               alineaJ
**	
**	Objectivo          O objectivo deste script � o de proceder ao pagamento 
**						devido por uma estada, emitindo a respectiva factura.
**					   Para isso, deve-se calcular o valor a pagar pelo 
**						alojamento, as actividades e os extras.
**
**	Criado por         Grupo 4 
**	Data de Cria��o    14/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Retirar pre�o base  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getAlojamentoPre�o')
	DROP PROCEDURE dbo.getAlojamentoPre�o;
GO
CREATE PROCEDURE dbo.getAlojamentoPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY descri��o) + @linha, 1, AlojEst.pre�oBase, Aloj.descri��o, 'alojamento' FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
					ON AlojEst.localiza��o = Aloj.localiza��o AND AlojEst.nomeParque = Aloj.nomeParque WHERE id = @idEstada
					
			SELECT @novaLinha = @@ROWCOUNT + @linha
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH	 
	
/*************************************** Retirar pre�o total dos extras de alojamento ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getEstadaExtrasPre�o')
	DROP PROCEDURE dbo.getEstadaExtrasPre�o;
GO
CREATE PROCEDURE dbo.getEstadaExtrasPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS	-- vai buscar o total a pagar de acordo com os extras para estada
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			DECLARE @totalDias INT

			SELECT @totalDias = DATEDIFF(DAY, dataIn�cio, dataFim) FROM dbo.Estada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descri��o) + @linha, @totalDias, EstExt.pre�oDia * @totalDias, Ext.descri��o, 'extra' 
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

/*************************************** Retirar pre�o total dos extras de alojamento ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getPessoalExtrasPre�o')
	DROP PROCEDURE dbo.getPessoalExtrasPre�o;
GO
CREATE PROCEDURE dbo.getPessoalExtrasPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS  -- vai buscar o total a pagar de acordo com os extras para pessoal
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @totalDias INT
			DECLARE @totalH�spedes INT

			SELECT @totalDias = DATEDIFF(DAY, dataIn�cio, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @totalH�spedes = COUNT(NIF) FROM dbo.H�spedeEstada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descri��o) + @linha, @totalDias * @totalH�spedes, EstExt.pre�oDia * @totalDias * @totalH�spedes, Ext.descri��o, 'extra' 
					FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
			
			SELECT @novaLinha = @@ROWCOUNT + @linha
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Retirar pre�o total das actividade ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'getCustoTotalActividades')
	DROP PROCEDURE dbo.getCustoTotalActividades;
GO
CREATE PROCEDURE dbo.getCustoTotalActividades @idEstada INT, @idFactura INT, @ano INT, @linha INT AS	-- vai buscar o custo total das actividades
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o, tipo)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Act.descri��o) + @linha, COUNT(Paga.n�meroSequencial), Paga.pre�oParticipante * COUNT(Paga.n�meroSequencial), Act.descri��o, 'actividade' 
					FROM dbo.H�spedeEstada AS HosEst JOIN dbo.Paga ON HosEst.NIF = Paga.NIF JOIN dbo.Actividades as Act 
						ON Paga.nomeParque = Act.nomeParque AND Paga.n�meroSequencial = Act.n�meroSequencial WHERE HosEst.id = @idEstada
						GROUP BY Act.descri��o, Paga.pre�oParticipante
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH
	
/*************************************** Adicionar pre�o total � factura ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'addPre�oTotal')
	DROP PROCEDURE dbo.addPre�oTotal;
GO
CREATE PROCEDURE dbo.addPre�oTotal @idFactura INT, @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			DECLARE @pre�oTotal INT

			SELECT @pre�oTotal = SUM(pre�o) FROM Item WHERE idFactura = @idFactura AND ano = @ano

			UPDATE dbo.Factura SET pre�oTotal = @pre�oTotal WHERE id = @idFactura AND ano = @ano
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
			DECLARE @NIFRespons�vel INT
			DECLARE @idFactura INT
			DECLARE @ano INT	
			DECLARE @novaLinha INT 
			DECLARE @data DATE
			DECLARE @nomeRespons�vel NVARCHAR(30)

			IF NOT EXISTS (SELECT 1 FROM dbo.Estada WHERE id = @idEstada)
				THROW 51000, 'A estada n�o existe', 1

			SELECT @ano = YEAR(GETDATE())

			SELECT @NIFRespons�vel = Hosp.NIF, @nomeRespons�vel = Hosp.nome FROM dbo.H�spedeEstada AS HospEst JOIN dbo.H�spede AS Hosp 
				ON HospEst.NIF = Hosp.NIF WHERE HospEst.id = @idEstada AND HospEst.h�spede = 'true'

			SELECT @idFactura = COUNT(id) + 1 FROM dbo.Factura WHERE ano = @ano
			
			INSERT INTO dbo.Factura(id, ano, NIFH�spede, nomeH�spede, pre�oTotal)
				VALUES (@idFactura, @ano, @NIFRespons�vel, @nomeRespons�vel, 0)	
			
			UPDATE Estada SET idFactura=@idFactura, ano = @ano WHERE id=@idEstada

			EXEC dbo.getAlojamentoPre�o @idEstada, @idFactura, @ano, 0, @novaLinha OUTPUT

			EXEC dbo.getEstadaExtrasPre�o @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getPessoalExtrasPre�o @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getCustoTotalActividades @idEstada, @idFactura, @ano, @novaLinha

			EXEC dbo.addPre�oTotal @idFactura, @ano
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
	
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
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

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim,nomeParque)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00','Glampinho'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00','Glampinho'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00','Glampinho'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00','Glampinho'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00','Glampinho')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 1, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 7', 1, 15)

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 4', 3)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (3, 1, 10),
		   (3, 2, 15),
		   (3, 3, 20)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (123456789, 3, 'true'),
		   (566778899, 3, 'false'),
		   (123456789, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', 14, 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', 10, 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3),
		   ('Glampinho', 2, 2017, 112233445, 2),
		   ('Glampinho', 2, 2017, 566778899, 2)

SELECT * FROM dbo.H�spede
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.EstadaExtra
SELECT * FROM dbo.Extra
SELECT * FROM dbo.H�spedeEstada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Factura
SELECT * FROM dbo.Item

DECLARE @novaLinha INT 
EXEC dbo.getAlojamentoPre�o 3, 1, 2017, 0, @novaLinha OUTPUT

EXEC dbo.getEstadaExtrasPre�o 3, 1, 2017, @novaLinha, @novaLinha OUTPUT

EXEC dbo.getPessoalExtrasPre�o 3, 1, 2017, @novaLinha, @novaLinha OUTPUT

EXEc dbo.getCustoTotalActividades 3, 1, 2017, @novaLinha

/* Corre vers�o final da cria��o da factura */
EXEC dbo.finishEstadaWithFactura 3