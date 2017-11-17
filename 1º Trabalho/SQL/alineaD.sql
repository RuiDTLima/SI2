/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Cria��o    06/11/17
**
******************************************************************************/
USE Glampinho

/******************************* INSERTS ***********************************************************/
/******************************* INSERT Bungalow ***************************************************/
GO
CREATE PROCEDURE dbo.InsertAlojamentoBungalow @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
											  @descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @tipologia CHAR(2) AS
BEGIN TRY
	BEGIN TRANSACTION
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
CREATE PROCEDURE dbo.InsertAlojamentoTenda @nomeParque NVARCHAR(30), @nome NVARCHAR(30), @localiza��o NVARCHAR(30), 
										   @descri��o NVARCHAR(30), @pre�oBase INT, @n�meroM�ximoPessoas TINYINT, @�rea INT AS
BEGIN TRY
	BEGIN TRANSACTION
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

UPDATE dbo.Alojamento SET pre�oBase = 80 WHERE nome = 'Parque 1' and localiza��o = 'Lote 1'

/****************************** DELETE ***********************************************************/
GO
CREATE PROCEDURE dbo.deleteAlojamento @localiza��o NVARCHAR(30), @nomeParque NVARCHAR(30) AS
BEGIN TRY
    BEGIN TRANSACTION
		DELETE FROM dbo.AlojamentoEstada WHERE localiza��o=@localiza��o and nomeParque=@nomeParque
		DELETE FROM dbo.AlojamentoExtra WHERE localiza��o=@localiza��o and nomeParque=@nomeParque
		DELETE FROM dbo.Alojamento WHERE localiza��o=@localiza��o and nomeParque=@nomeParque
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

INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim)
	VALUES(1, '2017-11-09 13:00:00', '2017-11-11 13:00:00')

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES(1, 'descricao', 12, 'pessoa')
	
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', '12EA1', 'bonito', 12, 4, 50

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES('Glampinho', '12EA1', 1, 12) 

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES('Glampinho', '12EA1', 1)

SELECT * FROM dbo.Estada
SELECT * FROM dbo.Extra
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Bungalow
SELECT * FROM dbo.Tenda