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
CREATE PROCEDURE dbo.getAlojamentoPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY descri��o) + @linha, 1, AlojEst.pre�oBase, Aloj.descri��o FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
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
CREATE PROCEDURE dbo.getEstadaExtrasPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS	-- vai buscar o total a pagar de acordo com os extras para estada
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT

			SELECT @totalDias = DATEDIFF(DAY, dataIn�cio, dataFim) FROM dbo.Estada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descri��o) + @linha, @totalDias, EstExt.pre�oDia * @totalDias, Ext.descri��o 
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
CREATE PROCEDURE dbo.getPessoalExtrasPre�o @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS  -- vai buscar o total a pagar de acordo com os extras para pessoal
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT
			DECLARE @totalH�spedes INT

			SELECT @totalDias = DATEDIFF(DAY, dataIn�cio, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @totalH�spedes = COUNT(NIF) FROM dbo.H�spedeEstada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descri��o) + @linha, @totalDias * @totalH�spedes, EstExt.pre�oDia * @totalDias * @totalH�spedes, Ext.descri��o 
					FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
			
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
CREATE PROCEDURE dbo.getCustoTotalActividades @idEstada INT, @idFactura INT, @ano INT, @linha INT AS	-- vai buscar o custo total das actividades
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, pre�o, descri��o)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Act.descri��o) + @linha, COUNT(Paga.n�meroSequencial), Paga.pre�oParticipante * COUNT(Paga.n�meroSequencial), Act.descri��o FROM dbo.H�spedeEstada AS HosEst JOIN dbo.Paga 
					ON HosEst.NIF = Paga.NIF JOIN dbo.Actividades as Act 
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
CREATE PROCEDURE dbo.addPre�oTotal @idFactura INT, @ano INT AS
	BEGIN TRY
		BEGIN TRANSACTION
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
CREATE PROCEDURE dbo.finishEstadaWithFactura @idEstada INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @NIFRespons�vel INT
			DECLARE @idFactura INT
			DECLARE @ano INT	
			DECLARE @novaLinha INT 
			DECLARE @data DATE
			DECLARE @nomeRespons�vel NVARCHAR(30)

			SELECT @ano = YEAR(GETDATE())

			SELECT @NIFRespons�vel = Hosp.NIF, @nomeRespons�vel = Hosp.nome FROM dbo.H�spedeEstada AS HospEst JOIN dbo.H�spede AS Hosp 
				ON HospEst.NIF = Hosp.NIF WHERE HospEst.id = @idEstada AND HospEst.h�spede = 'true'

			SELECT @idFactura = COUNT(id) + 1 FROM dbo.Factura WHERE ano = @ano
			
			INSERT INTO dbo.Factura(id, ano, idEstada, NIFH�spede, nomeH�spede, pre�oTotal)
				VALUES (@idFactura, @ano, @idEstada, @NIFRespons�vel, @nomeRespons�vel, 0)	

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
EXEC dbo.finishEstadaWithFactura 5
EXEC dbo.finishEstadaWithFactura 4
EXEC dbo.finishEstadaWithFactura 3
EXEC dbo.finishEstadaWithFactura 2
EXEC dbo.finishEstadaWithFactura 1


