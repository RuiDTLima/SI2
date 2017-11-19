/*******************************************************************************
**	Nome               alineaN
**	
**	Objectivo          O objectivo deste script � o de criar a vista bungalow
**						que permita executar as instru��es SQL SELECT, INSERT,
**						DELETE e UPDATE apenas sobre os alojamentos do tipo 
**						bungalow
**
**	Criado por         Grupo 4 
**	Data de Cria��o    18/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Cria��o da vista de bungalow ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.views WHERE NAME = 'Bungalows')
	DROP VIEW dbo.Bungalows
GO
CREATE VIEW dbo.Bungalows AS 
	SELECT ParqueCampismo.nome, ParqueCampismo.email, ParqueCampismo.estrelas, ParqueCampismo.morada, B.descri��o, B.localiza��o, B.nome AS nomeAlojamento, n�meroM�ximoPessoas, B.pre�oBase, B.tipoAlojamento, B.tipologia FROM 
	ParqueCampismo 
	INNER JOIN (
			SELECT Alojamento.descri��o, Alojamento.localiza��o, Alojamento.nome, Alojamento.nomeParque, Alojamento.n�meroM�ximoPessoas, Alojamento.pre�oBase, Alojamento.tipoAlojamento, A.tipologia FROM 
			Alojamento  
			INNER JOIN 
			(SELECT * FROM Bungalow) AS A
			 ON Alojamento.localiza��o = A.localiza��o AND Alojamento.nomeParque = A.nomeParque AND tipoAlojamento = 'bungalow'
			 ) AS B
			  ON B.nomeParque = ParqueCampismo.nome

/******************* TRIGGER DE INSERT ***************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.triggers WHERE NAME = 'trgBungalowInsert')
	DROP TRIGGER dbo.trgBungalowInsert
GO
CREATE TRIGGER dbo.trgBungalowInsert ON dbo.Bungalows INSTEAD OF INSERT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @num INT
			DECLARE @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), @descri��o NVARCHAR(30), @pre�oBase INT,
				@n�meroM�ximoPessoas INT, @tipologia CHAR(2)

			SELECT @num = count(*) FROM inserted
			--Diferentes formas de inserir, dependendo do n� de inser��es
			IF (@num = 0)
				RETURN 

			IF (@num = 1)
			BEGIN
				SELECT @nomeParque = nome, @nome = nomeAlojamento, @localiza��o = localiza��o, @descri��o = descri��o, @pre�oBase = pre�oBase, @n�meroM�ximoPessoas = n�meroM�ximoPessoas, @tipologia = tipologia  FROM inserted
				EXEC dbo.InsertAlojamentoBungalow @nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, @tipologia
			END		

			ELSE
			BEGIN
				DECLARE acursor CURSOR LOCAL
					FOR SELECT nome, nomeAlojamento, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipologia FROM inserted
			
				OPEN acursor
				FETCH NEXT FROM acursor INTO @nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, @tipologia

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					EXEC dbo.InsertAlojamentoBungalow @nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, @tipologia
					FETCH NEXT FROM acursor INTO @nomeParque, @nome, @localiza��o, @descri��o, @pre�oBase, @n�meroM�ximoPessoas, @tipologia
				END
			END
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************** TRIGGER DE DELETE ***************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.triggers WHERE NAME = 'trgBungalowDelete')
	DROP TRIGGER dbo.trgBungalowDelete
GO
CREATE TRIGGER dbo.trgBungalowDelete ON dbo.Bungalows INSTEAD OF DELETE AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @num INT
		DECLARE @nomeParque NVARCHAR(30), @localiza��o NVARCHAR(30)

		SELECT @num = count(*) FROM deleted

		--Diferentes formas de inserir, dependendo do n� de inser��es
		IF (@num = 0)
			RETURN 

		IF (@num = 1)
		BEGIN
			select @nomeParque = nome, @localiza��o = localiza��o FROM deleted
			EXEC dbo.deleteAlojamento @localiza��o, @nomeParque
		END		

		ELSE
			BEGIN
				DECLARE eliminaBungalows CURSOR LOCAL
					FOR SELECT nome, localiza��o FROM deleted
			
				OPEN eliminaBungalows
				FETCH NEXT FROM eliminaBungalows INTO @nomeParque, @localiza��o

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					EXEC dbo.deleteAlojamento @localiza��o, @nomeParque
					FETCH NEXT FROM eliminaBungalows INTO @nomeParque, @localiza��o
				END
			END
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/*************** TRIGGER DE UPDATE ***************************************************************/		
GO
IF EXISTS (SELECT 1 FROM sys.triggers WHERE NAME = 'trgBungalowUpdate')
	DROP TRIGGER dbo.trgBungalowUpdate
GO
CREATE TRIGGER dbo.trgBungalowUpdate ON dbo.Bungalows INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @num INT
		DECLARE @nomeParqueDeleted NVARCHAR(30), @localiza��oDeleted NVARCHAR(30)
		DECLARE @nomeParque NVARCHAR(30), @localiza��o NVARCHAR(30), @tipologia CHAR(2)
		DECLARE @nome NVARCHAR(30), @descri��o NVARCHAR(30), @pre�o INT, @n�meroM�ximoPessoas TINYINT
   
		SELECT @num = count(*) FROM deleted

		IF (@num = 0)
			RETURN 

		IF (@num = 1)
		BEGIN
			SELECT @nomeParqueDeleted = nome, @localiza��oDeleted = localiza��o FROM deleted
			SELECT @nomeParque = nome, @localiza��o = localiza��o, @tipologia = tipologia, 
				@nome = nome, @descri��o = descri��o, @pre�o = pre�oBase, @n�meroM�ximoPessoas = n�meroM�ximoPessoas FROM inserted

			UPDATE dbo.Bungalow SET localiza��o = @localiza��o, tipologia = @tipologia WHERE nomeParque = @nomeParqueDeleted AND localiza��o = @localiza��oDeleted
			UPDATE dbo.Alojamento SET localiza��o = @localiza��o, descri��o = @descri��o, pre�oBase = @pre�o, n�meroM�ximoPessoas = @n�meroM�ximoPessoas WHERE nomeParque = @nomeParqueDeleted AND localiza��o = @localiza��oDeleted	
		END		

		ELSE
			BEGIN
				DECLARE actualizaBungalowsDelete CURSOR LOCAL
					FOR SELECT nome, localiza��o FROM deleted

				DECLARE actualizaBungalowsInsert CURSOR LOCAL 
					FOR SELECT nome, localiza��o, tipologia, nomeAlojamento, descri��o, pre�oBase, n�meroM�ximoPessoas FROM inserted
			
				OPEN actualizaBungalowsDelete
				OPEN actualizaBungalowsInsert
				FETCH NEXT FROM actualizaBungalowsDelete INTO @nomeParqueDeleted, @localiza��oDeleted

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					FETCH NEXT FROM actualizaBungalowsInsert INTO @nomeParque, @localiza��o, @tipologia, 
						@nome, @descri��o, @pre�o, @n�meroM�ximoPessoas 

					UPDATE dbo.Bungalow SET localiza��o = @localiza��o, tipologia = @tipologia WHERE nomeParque = @nomeParqueDeleted AND localiza��o = @localiza��oDeleted
					UPDATE dbo.Alojamento SET localiza��o = @localiza��o, descri��o = @descri��o, pre�oBase = @pre�o, n�meroM�ximoPessoas = @n�meroM�ximoPessoas WHERE nomeParque = @nomeParqueDeleted AND localiza��o = @localiza��oDeleted
					
					FETCH NEXT FROM actualizaBungalowsDelete INTO @nomeParqueDeleted, @localiza��oDeleted
				END

				CLOSE actualizaBungalowsDelete
				DEALLOCATE actualizaBungalowsDelete
				CLOSE actualizaBungalowsInsert
				DEALLOCATE actualizaBungalowsInsert
			END
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/*************************************** Teste ************************************************************************/
DELETE FROM dbo.Bungalows

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

SELECT * FROM dbo.Bungalows
SELECT * FROM Alojamento									 
SELECT * FROM dbo.Bungalow

UPDATE BUNGALOWS SET pre�oBase = 100 WHERE localiza��o = 'Rua 6' 

UPDATE dbo.Bungalow SET localiza��o = 'Rua 6', tipologia = 'T3' WHERE nomeParque = 'Glampinho' AND localiza��o = 'Rua 6'