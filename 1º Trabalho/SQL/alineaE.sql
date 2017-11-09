/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um extra de alojamento 
**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/
USE Glampinho

/**************INSERT *******************************************************/

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(2, 'descricao', 10, 'alojamento')

/**************UPDATE *******************************************************/

UPDATE Extra SET pre�oDia = pre�oDia - 2 WHERE id = 2

/**************DELETE *******************************************************/

GO 
CREATE PROC dbo.deleteExtra @id INT
AS
BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM dbo.AlojamentoExtra WHERE id=@id 
		DELETE FROM dbo.EstadaExtra WHERE estadaId=@id
		DELETE FROM dbo.Extra WHERE id=@id
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH

/*************** TESTE ******************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(1,'descricao',12,'alojamento')

INSERT INTO Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
	VALUES('Glampinho', 'vermelho', '12EA1', 'bonito', 12, 4, 'tenda')

INSERT INTO Estada(id, dataIn�cio, dataFim)
	VALUES(1, '03-15-17 10:30', null)

INSERT INTO AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES('Glampinho', '12EA1', 1)

INSERT INTO EstadaExtra(estadaId, ExtraId)
	VALUES(1,1)

EXEC dbo.deleteExtra 1

SELECT * FROM dbo.Extra
SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoExtra
SELECT * FROM dbo.EstadaExtra