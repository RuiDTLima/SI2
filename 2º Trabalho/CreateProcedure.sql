/*******************************************************************************
**	Nome               createProc
**	
**	Objectivo          O objectivo deste script � o de criar os scripts necess�rios
**						a correr a aplica��o
**
**	Criado por         Grupo 4 
**	Data de Cria��o    22/12/17
**
******************************************************************************/
USE Glampinho

/********************************** DELETE H�SPEDES ASSOCIADOS ************************************************************/
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'eliminaH�spedesAssociados')
	DROP PROCEDURE dbo.eliminaH�spedesAssociados;
GO
CREATE PROCEDURE dbo.eliminaH�spedesAssociados @idEstada INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 	-- evita as anomalias dirty read e nonrepeatable read
		DECLARE @NIFH�spede INT
		DECLARE @count INT

		DECLARE h�spedesAssociados CURSOR FOR SELECT NIF FROM dbo.H�spedeEstada WHERE id = @idEstada

		OPEN h�spedesAssociados
		FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede AND id = @idEstada

			SELECT @count = COUNT(id) FROM dbo.H�spedeEstada WHERE NIF = @NIFH�spede

			IF @count = 0
			BEGIN
				DELETE FROM dbo.H�spede WHERE NIF = @NIFH�spede
			END
			
			FETCH NEXT FROM h�spedesAssociados INTO @NIFH�spede
		END

		CLOSE h�spedesAssociados
		DEALLOCATE h�spedesAssociados
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** DELETE H�SPEDE ************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteHospede')
	DROP PROCEDURE dbo.deleteHospede;
GO
CREATE PROCEDURE dbo.deleteHospede @NIFHospede INT AS 
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- para evitar lost updates
		DECLARE @h�spede VARCHAR(5)
		DECLARE @idEstada INT

		DECLARE eliminaEstadaInfo CURSOR FOR SELECT id, h�spede FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede

		OPEN eliminaEstadaInfo
		FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @h�spede

		WHILE @@FETCH_STATUS = 0
			BEGIN
				if @h�spede = 'true'	-- significa que deve ser elimina a estada e todas as entidades associativas associadas a ela
					BEGIN
						DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada

						EXEC dbo.eliminaH�spedesAssociados @idEstada	-- verifica se a estada � a unica dos seus h�spede, em caso afirmativo elimina esses h�spedes

						DELETE FROM dbo.Estada WHERE id = @idEstada
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				ELSE
					BEGIN
						DELETE FROM dbo.H�spedeEstada WHERE NIF = @NIFHospede
						DELETE FROM dbo.H�spede WHERE NIF = @NIFHospede
					END
				
				FETCH NEXT FROM eliminaEstadaInfo INTO @idEstada, @h�spede
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
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
												@descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @tipologia CHAR(2) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, 'bungalow')

		INSERT INTO dbo.Bungalow(nomeParque, localiza��o, tipologia)
			VALUES(@nomeParque, @localiza��o, @tipologia)
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
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
										   @descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @�rea INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		INSERT INTO dbo.Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
			VALUES(@nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, 'tenda')

		INSERT INTO dbo.Tenda(nomeParque, localiza��o, �rea)
			VALUES(@nomeParque, @localiza��o, @�rea)
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
CREATE PROCEDURE dbo.UpdateAlojamento @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @descri��o NVARCHAR(30), @nomeParque NVARCHAR(30), @localiza��o NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		UPDATE dbo.Alojamento SET pre�oBase = @pre�oBase, n�meroM�ximoPessoas = @n�meroM�ximoPessoas, descri��o = @descri��o WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
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
CREATE PROCEDURE dbo.deleteAlojamento @localiza��o NVARCHAR(30), @nomeParque NVARCHAR(30) AS
SET NOCOUNT ON
BEGIN TRY
    BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DECLARE @idEstada INT
		DECLARE eliminaAlojamentoInfo CURSOR FOR SELECT id FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o

		OPEN eliminaAlojamentoInfo
		FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(id) FROM dbo.AlojamentoEstada WHERE id = @idEstada) = 1
				BEGIN
					EXEC dbo.eliminaH�spedesAssociados @idEstada
					DELETE FROM dbo.AlojamentoEstada WHERE id = @idEstada
					DELETE FROM dbo.EstadaExtra WHERE estadaId = @idEstada
					DELETE FROM dbo.Estada WHERE id = @idEstada

				END
				ELSE
					DELETE FROM dbo.AlojamentoEstada WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
				FETCH NEXT FROM eliminaAlojamentoInfo INTO @idEstada
		END

		CLOSE eliminaAlojamentoInfo
		DEALLOCATE eliminaAlojamentoInfo

		DELETE FROM dbo.AlojamentoExtra WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
		DELETE FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localiza��o = @localiza��o
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
CREATE PROCEDURE dbo.deleteAtividades @nomeParque NVARCHAR(30), @n�meroSequencial INT, @ano INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DELETE FROM dbo.Paga WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano
		DELETE FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano
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

			SELECT @nomeParque = Aloj.nomeParque, @localiza��o = Aloj.localiza��o, @pre�oBase = Aloj.pre�oBase FROM dbo.Alojamento AS Aloj LEFT JOIN dbo.AlojamentoEstada AS AlojEst 
				ON Aloj.nomeParque = AlojEst.nomeParque AND Aloj.localiza��o = AlojEst.localiza��o 
				LEFT JOIN dbo.Estada as Est ON Est.id = AlojEst.id
				WHERE Aloj.tipoAlojamento = @tipoAlojamento AND Aloj.n�meroM�ximoPessoas >= @lota��o AND (Est.dataFim < GETDATE() OR Est.id IS NULL)

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
			EXEC dbo.createEstada @NIFRespons�vel, @tempoEstada, @id OUTPUT
			
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

/*************************************** Inscrever h�spede a actividade  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'inscreverH�spede')
	DROP PROCEDURE dbo.inscreverH�spede;
GO 
CREATE PROCEDURE dbo.inscreverH�spede @NIFH�spede INT, @n�meroSequencial INT, @nomeParque NVARCHAR(30), @ano INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ	-- para nao perdermos uma atualiza��o
			DECLARE @dataRealiza��o DATETIME2
			SELECT @dataRealiza��o = dataRealiza��o FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano

			IF NOT EXISTS (SELECT 1 FROM dbo.H�spedeEstada as hosEst INNER JOIN dbo.Estada as Est ON hosEst.id = Est.id JOIN dbo.AlojamentoEstada as AlojEst ON AlojEst.id = Est.id
							WHERE hosEst.NIF = @NIFH�spede AND Est.dataFim > @dataRealiza��o AND Est.dataIn�cio < @dataRealiza��o AND AlojEst.nomeParque = @nomeParque AND Est.dataFim > GETDATE())
				THROW 51000, 'H�spede � inv�lido', 1 

			INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
				SELECT @nomeParque, @n�meroSequencial, @ano, @NIFH�spede, pre�oParticipante FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

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

/*************************************** Estrutura do email a enviar  ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'sendEmail')
	DROP PROCEDURE dbo.sendEmail;
GO
CREATE PROCEDURE dbo.sendEmail @NIF INT, @email NVARCHAR(30), @text VARCHAR(255), @mail TEXT OUTPUT AS
	SET @mail=CONCAT('De: Ger�ncia Glampinho ' + char(10) + 'Para: ' + @email + char(10) + 'Cliente com o NIF: ' + CAST(@NIF AS VARCHAR) + char(10) + 'Mensagem: ' + @text, char(10), char(10)) 
	RETURN 

/*************************************** Envia email a todos os h�spedes respons�veis por estadas a come�ar dentro de x temp ************************************************************************/
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
	
	DECLARE @Notifica��es TABLE(
		mensagem TEXT NOT NULL
	)

	DECLARE iterate_NIFs CURSOR LOCAL FORWARD_ONLY FOR 
		SELECT Hosp.NIF, Hosp.email FROM dbo.H�spede AS Hosp JOIN dbo.H�spedeEstada AS HospEst ON Hosp.NIF = HospEst.NIF 
			JOIN dbo.Estada AS Est ON HospEst.id = Est.id WHERE HospEst.h�spede = 'true' AND Est.dataIn�cio > GETDATE() AND Est.dataIn�cio <= DATEADD(DAY, @periodoTemporal, GETDATE())
	
	OPEN iterate_NIFs
	FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC dbo.SendEmail @NIF, @email, 'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.', @emailText OUTPUT
			INSERT INTO @Notifica��es(mensagem) VALUES(@emailText)
			FETCH NEXT FROM iterate_NIFs INTO @NIF, @email
		END
		
	CLOSE iterate_NIFs
	DEALLOCATE iterate_NIFs
	SELECT mensagem FROM @Notifica��es
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
END CATCH 

/*************************************** FUN��O PARA LISTAR ACTIVIDADES ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'listAtividades')
	DROP FUNCTION dbo.listAtividades;
GO
CREATE FUNCTION dbo.listAtividades(@dataInicio DATETIME2, @dataFim DATETIME2)
RETURNS  @rtnTable TABLE (
    -- columns returned by the function
    nome NVARCHAR(30) NOT NULL,
    descri��o NVARCHAR(30) NOT NULL
) AS

BEGIN
	INSERT INTO @rtnTable(nome, descri��o)
		
SELECT nome, descri��o FROM dbo.Actividades INNER JOIN (
			SELECT Actividades.n�meroSequencial, Actividades.ano, count(Actividades.n�meroSequencial) AS participantes FROM dbo.Actividades 
			LEFT JOIN dbo.Paga AS P ON P.n�meroSequencial = Actividades.n�meroSequencial AND P.ano = Actividades.ano
			GROUP BY Actividades.n�meroSequencial, Actividades.ano) AS A 
			ON A.n�meroSequencial = Actividades.n�meroSequencial AND A.ano = Actividades.ano AND lota��oM�xima > participantes 
				AND dataRealiza��o BETWEEN @dataInicio AND @dataFim
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