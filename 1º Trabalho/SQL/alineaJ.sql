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
			INSERT INTO dbo.Item(idEstada, idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idEstada, @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY descrição) + @linha, 1, AlojEst.preçoBase, Aloj.descrição FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
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

			INSERT INTO dbo.Item(idEstada, idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idEstada, @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias, EstExt.preçoDia * @totalDias, Ext.descrição FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra AS Ext 
					ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'alojamento'

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

			INSERT INTO dbo.Item(idEstada, idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idEstada, @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Ext.descrição) + @linha, @totalDias * @totalHóspedes, EstExt.preçoDia * @totalDias * @totalHóspedes, Ext.descrição FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext 
					ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
			
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
			INSERT INTO dbo.Item(idEstada, idFactura, ano, linha, quantidade, preço, descrição)
				SELECT @idEstada, @idFactura, @ano, ROW_NUMBER() OVER (ORDER BY Act.descrição) + @linha, COUNT(Paga.númeroSequencial), Paga.preçoParticipante * COUNT(Paga.númeroSequencial), Act.descrição FROM dbo.HóspedeEstada AS HosEst JOIN dbo.Paga 
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

			SELECT @data = GETDATE()
			SELECT @ano = YEAR(@data)

			SELECT @NIFResponsável = Hosp.NIF, @nomeResponsável = Hosp.nome FROM dbo.HóspedeEstada AS HospEst JOIN dbo.Hóspede AS Hosp 
				ON HospEst.NIF = Hosp.NIF WHERE HospEst.id = @idEstada AND HospEst.hóspede = 'true'

			SELECT @idFactura = COUNT(id) + 1 FROM dbo.Factura WHERE ano = @ano

			/*************************************** Actualizar estada  ************************************************************************/
			UPDATE dbo.Estada SET dataFim = @data WHERE id = @idEstada

			INSERT INTO dbo.Factura(id, idEstada, ano, NIFHóspede, nomeHóspede)
				VALUES (@idFactura, @idEstada, @ano, @NIFResponsável, @nomeResponsável)	

			EXEC dbo.getAlojamentoPreço @idEstada, @idFactura, @ano, 0, @novaLinha OUTPUT

			EXEC dbo.getEstadaExtrasPreço @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getPessoalExtrasPreço @idEstada, @idFactura, @ano, @novaLinha, @novaLinha OUTPUT

			EXEC dbo.getCustoTotalActividades @idEstada, @idFactura, @ano, @novaLinha

		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Teste ************************************************************************/




drop proc dbo.getAlojamentoPreço 

drop proc dbo.getEstadaExtrasPreço 

drop proc dbo.getPessoalExtrasPreço 

drop proc dbo.getCustoTotalActividades 

/* Corre versão final da criação da factura */
EXEC dbo.finishEstadaWithFactura 3

SELECT * FROM 