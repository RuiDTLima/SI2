/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Criação    06/11/17
**
******************************************************************************/
USE Glampinho

/******************************* INSERTS ***********************************************************/
/******************************* INSERT Bungalow ***************************************************/
GO
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
											  @descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @tipologia CHAR(2) AS
BEGIN TRY
	BEGIN TRANSACTION
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
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localização NVARCHAR(30), 
										   @descrição NVARCHAR(30), @preçoBase INT, @númeroMáximoPessoas TINYINT, @área INT AS
BEGIN TRY
	BEGIN TRANSACTION
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

UPDATE dbo.Alojamento SET preçoBase = 80 WHERE nome = 'Parque 1' and localização = 'Lote 1'

/****************************** DELETE ***********************************************************/
GO
CREATE PROCEDURE dbo.deleteAlojamento @localização NVARCHAR(30), @nomeParque NVARCHAR(30) AS
BEGIN TRY
    BEGIN TRANSACTION
		DELETE FROM dbo.AlojamentoEstada WHERE localização=@localização and nomeParque=@nomeParque
		DELETE FROM dbo.AlojamentoExtra WHERE localização=@localização and nomeParque=@nomeParque
		DELETE FROM dbo.Alojamento WHERE localização=@localização and nomeParque=@nomeParque
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/********************************** Teste ********************************************/

EXEC dbo.deleteAlojamento 'Lote 1','Glampinho'

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO	dbo.Estada(id, dataInício, dataFim)
	VALUES(1, '2017-11-09 13:00:00', '2017-11-11 13:00:00')

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES(1, 'descricao', 12, 'pessoa')
	
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', '12EA1', 'bonito', 12, 4, 50

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES('Glampinho', '12EA1', 1, 12) 

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES('Glampinho', '12EA1', 1)

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Tenda