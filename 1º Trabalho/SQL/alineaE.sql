/*******************************************************************************
**	Nome               alineaE
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de um extra de alojamento 
**
**	Criado por         Grupo 4 
**	Data de Criação    08/11/17
**
******************************************************************************/
USE Glampinho

/********************************** INSERT *******************************************************/

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES(2, 'descricao', 10, 'alojamento')

/********************************** UPDATE *******************************************************/

UPDATE dbo.Extra SET preçoDia = preçoDia - 2 WHERE id = 2

/********************************** DELETE *******************************************************/
GO 
CREATE PROCEDURE dbo.deleteExtra @id INT AS
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
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

/********************************* TESTE ******************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES(1,'descricao', 12, 'alojamento')

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'vermelho', '12EA1', 'bonito', 12, 4, 50

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES(1, '2017-03-15 10:03:00', '2017-03-20 13:00:00')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES('Glampinho', '12EA1', 1)

INSERT INTO dbo.EstadaExtra(estadaId, ExtraId, preçoDia)
	VALUES(1, 1, 12)

EXEC dbo.deleteExtra 1

SELECT * FROM dbo.Extra
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra