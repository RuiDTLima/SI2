/*******************************************************************************
**	Nome               alineaF
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de um extra pessoal
**
**	Criado por         Grupo 4 
**	Data de Criação    08/11/17
**
******************************************************************************/
USE Glampinho

/************************************** INSERT *******************************************************/

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES(3, 'descricao', 12, 'pessoa')

/************************************** UPDATE *******************************************************/

UPDATE dbo.Extra SET preçoDia = preçoDia - 2 WHERE id = 2

/************************************** DELETE *******************************************************/
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

/************************************** TESTE ******************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1,'descricao', 12, 'alojamento'),
		   (2, 'erro', 20, 'pessoa')

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'vermelho', '12EA1', 'bonito', 12, 4, 50

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 10:03:00', '2017-03-20 13:00:00')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', '12EA1', 1)

INSERT INTO dbo.EstadaExtra(estadaId, ExtraId, preçoDia)
	VALUES(1, 1, 12)

EXEC dbo.deleteExtraPessoa 2
EXEC dbo.deleteExtraPessoa 1

SELECT * FROM dbo.Extra
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra