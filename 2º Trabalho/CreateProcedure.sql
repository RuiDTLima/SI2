/*******************************************************************************
**	Nome               createProc
**	
**	Objectivo          O objectivo deste script é o de criar os scripts necessários
**						a correr a aplicação
**
**	Criado por         Grupo 4 
**	Data de Criação    22/12/17
**
******************************************************************************/
USE Glampinho

/********************************** DELETE HÓSPEDES ASSOCIADOS ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaHóspedesAssociados')
	DROP PROCEDURE dbo.eliminaHóspedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaHóspedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 	-- evita as anomalias dirty read e nonrepeatable read
		DECLARE @NIFHóspede INT
		DECLARE @count INT

		DECLARE hóspedesAssociados CURSOR FOR SELECT NIF FROM dbo.HóspedeEstada WHERE id = @idEstada

		OPEN hóspedesAssociados
		FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.HóspedeEstada WHERE NIF = @NIFHóspede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.Hóspede WHERE NIF = @NIFHóspede
			END
			
			FETCH NEXT FROM hóspedesAssociados INTO @NIFHóspede
		END

		CLOSE hóspedesAssociados
		DEALLOCATE hóspedesAssociados
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE HÓSPEDE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteHospede')
	DROP PROCEDURE dbo.deleteHospede;
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS 
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- para evitar lost updates
		DECLARE @hóspede VARCHAR(5)
		DECLARE @idEstada INT

		DECLARE eliminaEstadaInfo CURSOR FOR SELECT id, hóspede FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede

		OPEN eliminaEstadaInfo
		FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @hóspede

		WHILE @@FETCH_STATUS = 0
			BEGIN
				if @hóspede = 'true'	-- significa que deve ser elimina a estada e todas as entidades associativas associadas a ela
					BEGIN
						DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
						DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada

						EXEC dbo.eliminaHóspedesAssociados @idEstada	-- verifica se a estada é a unica dos seus hóspede, em caso afirmativo elimina esses hóspedes

						DELETE FROM dbo.Estada WHERE id = @idEstada
						DELETE FROM dbo.Hóspede WHERE NIF = @NIFHospede
					END
				ELSE
					BEGIN
						DELETE FROM dbo.HóspedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.Hóspede WHERE NIF = @NIFHospede
					END
				
				FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @hóspede
			END

		CLOSE eliminaEstadaInfo
		DEALLOCATE eliminaEstadaInfo
    COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* INSERT Bungalow ***************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'InsertAlojamentoBungalow')
	DROP PROCEDURE dbo.InsertAlojamentoBungalow;
GO
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
												@descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @tipologia CHAR(2) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, 'bungalow')

		INSERT INTO dbo.Bungalow(nomeParque, localização, tipologia)
			VALUES(@nomeParque, @localização, @tipologia)
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
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
										   @descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @área INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, 'tenda')

		INSERT INTO dbo.Tenda(nomeParque, localização, área)
			VALUES(@nomeParque, @localização, @área)
		COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************* UPDATE ***********************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'UpdateAlojamento')
	DROP PROCEDURE dbo.UpdateAlojamento;
GO
CREATE PROCEDURE dbo.UpdateAlojamento @preçoBase INT, @númeroMáximoPessoas TINYINT, @descrição NVARCHAR(30), @nomeParque NVARCHAR(30), @localização NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		UPDATE dbo.Alojamento SET preçoBase = @preçoBase, númeroMáximoPessoas = @númeroMáximoPessoas, descrição = @descrição WHERE nomeParque = @nomeParque AND localização = @localização
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
CREATE PROCEDURE dbo.deleteAlojamento @localização NVARCHAR(30), @nomeParque NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DECLARE @idEstada INT
		DECLARE eliminaAlojamentoInfo CURSOR FOR SELECT id FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localização = @localização

		OPEN eliminaAlojamentoInfo
		FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(id) FROM dbo.AlojamentoEstada WHERE id = @idEstada) = 1
				BEGIN
					EXEC dbo.eliminaHóspedesAssociados @idEstada
					DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada
					DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
					DELETE FROM dbo.Estada WHERE id = @idEstada

				END
				ELSE
					DELETE FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localização = @localização
				FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada
		END

		CLOSE eliminaAlojamentoInfo
		DEALLOCATE eliminaAlojamentoInfo

		DELETE FROM dbo.AlojamentoExtra WHERE nomeParque = @nomeParque AND localização = @localização
		DELETE FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localização = @localização
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE Extra Alojamento *******************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteExtra')
	DROP PROCEDURE dbo.deleteExtra;
GO 
CREATE PROCEDURE dbo.deleteExtra @id INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		IF NOT EXISTS(SELECT 1 FROM dbo.Extra WHERE id = @id AND associado = 'alojamento')
			THROW 51000, 'O extra tem de ser de alojamento', 1
		DELETE FROM dbo.AlojamentoExtra WHERE id=@id 
		DELETE FROM dbo.EstadaExtra WHERE estadaId=@id
		DELETE FROM dbo.Extra WHERE id=@id
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/************************************** DELETE Extra Pessoa *******************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteExtraPessoa')
	DROP PROCEDURE dbo.deleteExtraPessoa;
GO 
CREATE PROCEDURE dbo.deleteExtraPessoa @id INT AS
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		IF NOT EXISTS(SELECT 1 FROM dbo.Extra WHERE id = @id AND associado = 'pessoa')
			THROW 51000, 'O extra tem de ser de pessoa', 1
		DELETE FROM dbo.AlojamentoExtra WHERE id=@id
		DELETE FROM dbo.EstadaExtra WHERE estadaId=@id
		DELETE FROM dbo.Extra WHERE id=@id
    COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/******************************************* DELETE Actividade *******************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteAtividades')
	DROP PROCEDURE dbo.deleteAtividades;
GO
CREATE PROCEDURE dbo.deleteAtividades @nomeParque NVARCHAR(30), @númeroSequencial INT, @ano INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DELETE FROM dbo.Paga WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano
		DELETE FROM dbo.Actividades WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

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

			SELECT @nomeParque = Aloj.nomeParque, @localização = Aloj.localização, @preçoBase = Aloj.preçoBase FROM dbo.Alojamento AS Aloj LEFT JOIN dbo.AlojamentoEstada AS AlojEst 
				ON Aloj.nomeParque = AlojEst.nomeParque AND Aloj.localização = AlojEst.localização 
				LEFT JOIN dbo.Estada as Est ON Est.id = AlojEst.id
				WHERE Aloj.tipoAlojamento = @tipoAlojamento AND Aloj.númeroMáximoPessoas >= @lotação AND (Est.dataFim < GETDATE() OR Est.id IS NULL)

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
			EXEC dbo.createEstada @NIFResponsável, @tempoEstada, @id OUTPUT
			
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

/*************************************** Inscrever hóspede a actividade  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'inscreverHóspede')
	DROP PROCEDURE dbo.inscreverHóspede;
GO 
CREATE PROCEDURE dbo.inscreverHóspede @NIFHóspede INT, @númeroSequencial INT, @nomeParque NVARCHAR(30), @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- para nao perdermos uma atualização
			DECLARE @dataRealização DATETIME2
			SELECT @dataRealização = dataRealização FROM dbo.Actividades WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano

			IF NOT EXISTS (SELECT 1 FROM dbo.HóspedeEstada as hosEst INNER JOIN dbo.Estada as Est ON hosEst.id = Est.id JOIN dbo.AlojamentoEstada as AlojEst ON AlojEst.id = Est.id
							WHERE hosEst.NIF = @NIFHóspede AND Est.dataFim > @dataRealização AND Est.dataInício < @dataRealização AND AlojEst.nomeParque = @nomeParque AND Est.dataFim > GETDATE())
				THROW 51000, 'Hóspede é inválido', 1 

			INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
				SELECT @nomeParque, @númeroSequencial, @ano, @NIFHóspede, preçoParticipante FROM dbo.Actividades WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

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

/*************************************** Estrutura do email a enviar  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'sendEmail')
	DROP PROCEDURE dbo.sendEmail;
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255), @mail TEXT OUTPUT AS
	SET @mail=CONCAT('De: Gerência Glampinho ' + char(10) + 'Para: ' + @email + char(10) + 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR) + char(10) + 'Mensagem: ' + @text, char(10), char(10)) 
	RETURN 

/*************************************** Envia email a todos os hóspedes responsáveis por estadas a começar dentro de x temp ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'SendEmails')
	DROP PROCEDURE dbo.SendEmails;
GO
CREATE PROCEDURE dbo.SendEmails @periodoTemporal INT AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
    BEGIN TRY
	DECLARE @NIF INT
	DECLARE @email NVARCHAR(30)
	DECLARE @emailText VARCHAR(255)
	
	DECLARE @Notificações TABLE(
		mensagem TEXT NOT NULL
	)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.Hóspede AS Hosp JOIN dbo.HóspedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.hóspede = 'true' AND Est.dataInício > GETDATE() AND Est.dataInício <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.', @emailText OUTPUT
			INSERT INTO @Notificações(mensagem) VALUES(@emailText)
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
		
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	SELECT mensagem FROM @Notificações
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
END CATCH 

/*************************************** FUNÇÂO PARA LISTAR ACTIVIDADES ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'listAtividades')
	DROP FUNCTION dbo.listAtividades;
GO
CREATE FUNCTION dbo.listAtividades(@dataInicio DATETIME2, @dataFim DATETIME2)
RETURNS  @rtnTable TABLE (
    -- columns returned by the function
    nome NVARCHAR(30) NOT NULL,
    descrição NVARCHAR(30) NOT NULL
) AS

BEGIN
	INSERT INTO @rtnTable(nome, descrição)
		
SELECT nome, descrição FROM dbo.Actividades INNER JOIN (
			SELECT Actividades.númeroSequencial, Actividades.ano, count(Actividades.númeroSequencial) AS participantes FROM dbo.Actividades 
			LEFT JOIN dbo.Paga AS P ON P.númeroSequencial = Actividades.númeroSequencial AND P.ano = Actividades.ano
			GROUP BY Actividades.númeroSequencial, Actividades.ano) AS A 
			ON A.númeroSequencial = Actividades.númeroSequencial AND A.ano = Actividades.ano AND lotaçãoMáxima > participantes 
				AND dataRealização BETWEEN @dataInicio AND @dataFim
	RETURN
END

/*************************************** Apresenta todas as actividades com lugares disponiveis para um intervalo de datas ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE_DESC = 'SQL_STORED_PROCEDURE' AND NAME = 'listarAtividades')
	DROP PROCEDURE dbo.listarAtividades;
GO
CREATE PROCEDURE dbo.listarAtividades @dataInicio DATETIME2, @dataFim DATETIME2 AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

			SELECT * FROM dbo.listAtividades(@dataInicio, @dataFim)
			IF @@ROWCOUNT = 0 
				THROW 51000, 'As actividades encotram-se lotadas ou fora do intervalo especificado', 1
		COMMIT

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH 

/******************************* Parque de Campismo ************************************/
GO
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')