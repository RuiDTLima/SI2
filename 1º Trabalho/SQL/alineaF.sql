/*******************************************************************************
**	Nome               alineaF
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um extra pessoal
**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/
USE Glampinho

/**************INSERT *******************************************************/

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(3, 'descricao', 12, 'pessoa')

/**************UPDATE *******************************************************/

UPDATE Extra SET pre�oDia = pre�oDia - 2 WHERE id = 2

/**************DELETE *******************************************************/

GO 
CREATE PROC dbo.deleteExtraPessoa @id INT
AS
BEGIN TRY
    BEGIN TRANSACTION
		DELETE FROM AlojamentoExtra WHERE id=@id
		DELETE FROM EstadaExtra WHERE estadaId=@id
		DELETE FROM Extra WHERE id=@id
    COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH

/*************** TESTE ******************************************************/

EXEC dbo.deleteExtraAlojamento 1,'verde','Glampinho','12EA1',1

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(1,'descricao',12,'pessoa')

INSERT INTO Alojamento(nomeParque, nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
	VALUES('Glampinho','verde','12EA1','bonito',12,4,'tenda')

INSERT INTO Estada(id, dataIn�cio, dataFim)
	VALUES(1,'03-15-17 10:30',null)

INSERT INTO AlojamentoExtra(nome, nomeParque, localiza��o, id)
	VALUES('verde','Glampinho','12EA1',1)

INSERT INTO EstadaExtra(estadaId, ExtraId)
	VALUES(1,1)