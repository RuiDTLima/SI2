/*******************************************************************************
**	Nome               alineaN
**	
**	Objectivo          O objectivo deste script é o de criar a vista bungalow
**						que permita executar as instruções SQL SELECT, INSERT,
**						DELETE e UPDATE apenas sobre os alojamentos do tipo 
**						bungalow
**
**	Criado por         Grupo 4 
**	Data de Criação    18/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Criação da vista de bungalow ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.views WHERE NAME = 'Bungalows')
	DROP VIEW dbo.Bungalows
GO
CREATE VIEW dbo.Bungalows AS 
	SELECT ParqueCampismo.nome, ParqueCampismo.email, ParqueCampismo.estrelas, ParqueCampismo.morada, B.descrição, B.localização, B.nome AS nomeAlojamento, númeroMáximoPessoas, B.preçoBase, B.tipoAlojamento, B.tipologia FROM 
	ParqueCampismo 
	INNER JOIN (
			SELECT Alojamento.descrição, Alojamento.localização, Alojamento.nome, Alojamento.nomeParque, Alojamento.númeroMáximoPessoas, Alojamento.preçoBase, Alojamento.tipoAlojamento, A.tipologia FROM 
			Alojamento  
			INNER JOIN 
			(SELECT * FROM Bungalow) AS A
			 ON Alojamento.localização = A.localização AND Alojamento.nomeParque = A.nomeParque AND tipoAlojamento = 'bungalow'
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
			DECLARE @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), @descrição NVARCHAR(30), @preçoBase INT,
				@númeroMáximoPessoas INT, @tipologia CHAR(2)

			SELECT @num = count(*) FROM inserted
			--Diferentes formas de inserir, dependendo do nº de inserções
			IF (@num = 0)
				RETURN 

			IF (@num = 1)
			BEGIN
				SELECT @nomeParque = nome, @nome = nomeAlojamento, @localização = localização, @descrição = descrição, @preçoBase = preçoBase, @númeroMáximoPessoas = númeroMáximoPessoas, @tipologia = tipologia  FROM inserted
				EXEC dbo.InsertAlojamentoBungalow @nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, @tipologia
			END		

			ELSE
			BEGIN
				DECLARE acursor CURSOR LOCAL
					FOR SELECT nome, nomeAlojamento, localização, descrição, preçoBase, númeroMáximoPessoas, tipologia FROM inserted
			
				OPEN acursor
				FETCH NEXT FROM acursor INTO @nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, @tipologia

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					EXEC dbo.InsertAlojamentoBungalow @nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, @tipologia
					FETCH NEXT FROM acursor INTO @nomeParque, @nome, @localização, @descrição, @preçoBase, @númeroMáximoPessoas, @tipologia
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
		DECLARE @nomeParque NVARCHAR(30), @localização NVARCHAR(30)

		SELECT @num = count(*) FROM deleted

		--Diferentes formas de inserir, dependendo do nº de inserções
		IF (@num = 0)
			RETURN 

		IF (@num = 1)
		BEGIN
			select @nomeParque = nome, @localização = localização FROM deleted
			EXEC dbo.deleteAlojamento @localização, @nomeParque
		END		

		ELSE
			BEGIN
				DECLARE eliminaBungalows CURSOR LOCAL
					FOR SELECT nome, localização FROM deleted
			
				OPEN eliminaBungalows
				FETCH NEXT FROM eliminaBungalows INTO @nomeParque, @localização

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					EXEC dbo.deleteAlojamento @localização, @nomeParque
					FETCH NEXT FROM eliminaBungalows INTO @nomeParque, @localização
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
		DECLARE @nomeParqueDeleted NVARCHAR(30), @localizaçãoDeleted NVARCHAR(30)
		DECLARE @nomeParque NVARCHAR(30), @localização NVARCHAR(30), @tipologia CHAR(2)
		DECLARE @nome NVARCHAR(30), @descrição NVARCHAR(30), @preço INT, @númeroMáximoPessoas TINYINT
   
		SELECT @num = count(*) FROM deleted

		IF (@num = 0)
			RETURN 

		IF (@num = 1)
		BEGIN
			SELECT @nomeParqueDeleted = nome, @localizaçãoDeleted = localização FROM deleted
			SELECT @nomeParque = nome, @localização = localização, @tipologia = tipologia, 
				@nome = nome, @descrição = descrição, @preço = preçoBase, @númeroMáximoPessoas = númeroMáximoPessoas FROM inserted

			UPDATE dbo.Bungalow SET localização = @localização, tipologia = @tipologia WHERE nomeParque = @nomeParqueDeleted AND localização = @localizaçãoDeleted
			UPDATE dbo.Alojamento SET localização = @localização, descrição = @descrição, preçoBase = @preço, númeroMáximoPessoas = @númeroMáximoPessoas WHERE nomeParque = @nomeParqueDeleted AND localização = @localizaçãoDeleted	
		END		

		ELSE
			BEGIN
				DECLARE actualizaBungalowsDelete CURSOR LOCAL
					FOR SELECT nome, localização FROM deleted

				DECLARE actualizaBungalowsInsert CURSOR LOCAL 
					FOR SELECT nome, localização, tipologia, nomeAlojamento, descrição, preçoBase, númeroMáximoPessoas FROM inserted
			
				OPEN actualizaBungalowsDelete
				OPEN actualizaBungalowsInsert
				FETCH NEXT FROM actualizaBungalowsDelete INTO @nomeParqueDeleted, @localizaçãoDeleted

				WHILE (@@FETCH_STATUS = 0 )
				BEGIN
					FETCH NEXT FROM actualizaBungalowsInsert INTO @nomeParque, @localização, @tipologia, 
						@nome, @descrição, @preço, @númeroMáximoPessoas 

					UPDATE dbo.Bungalow SET localização = @localização, tipologia = @tipologia WHERE nomeParque = @nomeParqueDeleted AND localização = @localizaçãoDeleted
					UPDATE dbo.Alojamento SET localização = @localização, descrição = @descrição, preçoBase = @preço, númeroMáximoPessoas = @númeroMáximoPessoas WHERE nomeParque = @nomeParqueDeleted AND localização = @localizaçãoDeleted
					
					FETCH NEXT FROM actualizaBungalowsDelete INTO @nomeParqueDeleted, @localizaçãoDeleted
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

UPDATE BUNGALOWS SET preçoBase = 100 WHERE localização = 'Rua 6' 

UPDATE dbo.Bungalow SET localização = 'Rua 6', tipologia = 'T3' WHERE nomeParque = 'Glampinho' AND localização = 'Rua 6'