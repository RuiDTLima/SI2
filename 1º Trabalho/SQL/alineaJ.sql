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
CREATE PROCEDURE dbo.getAlojamentoPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY descrição) + @linha, 1, AlojEst.preçoBase, Aloj.descrição FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
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
CREATE PROCEDURE dbo.getEstadaExtrasPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS	-- vai buscar o total a pagar de acordo com os extras para estada
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias, EstExt.preçoDia * @totalDias, Ext.descrição 
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
CREATE PROCEDURE dbo.getPessoalExtrasPreço @idEstada INT, @idFactura INT, @ano INT, @linha INT, @novaLinha INT OUTPUT AS  -- vai buscar o total a pagar de acordo com os extras para pessoal
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT
			DECLARE @totalHóspedes INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @totalHóspedes = COUNT(NIF) FROM dbo.HóspedeEstada WHERE id = @idEstada

			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias * @totalHóspedes, EstExt.preçoDia * @totalDias * @totalHóspedes, Ext.descrição 
					FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
			
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
CREATE PROCEDURE dbo.getCustoTotalActividades @idEstada INT, @idFactura INT, @ano INT, @linha INT AS	-- vai buscar o custo total das actividades
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.Item(idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Act.descrição) + @linha, COUNT(Paga.númeroSequencial), Paga.preçoParticipante * COUNT(Paga.númeroSequencial), Act.descrição FROM dbo.HóspedeEstada AS HosEst JOIN dbo.Paga 
					ON HosEst.NIF = Paga.NIF JOIN dbo.Actividades as Act 
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
CREATE PROCEDURE dbo.addPreçoTotal @idFactura INT, @ano INT AS
	BEGIN TRY
		BEGIN TRANSACTION
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
CREATE PROCEDURE dbo.finishEstadaWithFactura @idEstada INT AS
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @NIFResponsável INT
			DECLARE @idFactura INT
			DECLARE @ano INT	
			DECLARE @novaLinha INT 
			DECLARE @data DATE
			DECLARE @nomeResponsável NVARCHAR(30)

			SELECT @ano = YEAR(GETDATE())

			SELECT @NIFResponsável = Hosp.NIF, @nomeResponsável = Hosp.nome FROM dbo.HóspedeEstada AS HospEst JOIN dbo.Hóspede AS Hosp 
				ON HospEst.NIF = Hosp.NIF WHERE HospEst.id = @idEstada AND HospEst.hóspede = 'true'

			SELECT @idFactura = COUNT(id) + 1 FROM dbo.Factura WHERE ano = @ano
			
			INSERT INTO dbo.Factura(id, ano, idEstada, NIFHóspede, nomeHóspede, preçoTotal)
				VALUES (@idFactura, @ano, @idEstada, @NIFResponsável, @nomeResponsável, 0)	

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
EXEC dbo.finishEstadaWithFactura 5
EXEC dbo.finishEstadaWithFactura 4
EXEC dbo.finishEstadaWithFactura 3
EXEC dbo.finishEstadaWithFactura 2
EXEC dbo.finishEstadaWithFactura 1


