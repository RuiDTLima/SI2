/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um extra pessoal
**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/
USE Glampinho

/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um extra alojamento 
**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/
USE Glampinho


/**************INSERT *******************************************************/

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(3,'descricao',12,'pessoa')

/**************UPDATE *******************************************************/

UPDATE Extra SET pre�oDia=pre�oDia-2 WHERE id=2

/**************DELETE *******************************************************/

GO 
CREATE PROC dbo.deleteExtraPessoa @identi int,@nome nvarchar(30),@nomeParque nvarchar(30), @localiza��o nvarchar(30), @idEstada int 
AS
BEGIN TRY
    BEGIN TRANSACTION
    DELETE FROM AlojamentoExtra WHERE id=@identi and nome=@nome and nomeParque=@nomeParque and localiza��o=@localiza��o
	DELETE FROM EstadaExtra WHERE estadaId=@identi and estadaId=@idEstada
	DELETE FROM Extra WHERE id=@identi
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH

/*************** TESTE ******************************************************/

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(1,'descricao',12,'pessoa')
INSERT INTO Alojamento(nomeParque,nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
	VALUES('Glampinho','verde','12EA1','bonito',12,4,'tenda')
INSERT INTO Estada(id, dataIn�cio, dataFim)
	VALUES(1,'03-15-17 10:30',null)

INSERT INTO AlojamentoExtra(nome,nomeParque, localiza��o, id)
	VALUES('verde','Glampinho','12EA1',1)
INSERT INTO EstadaExtra(estadaId, ExtraId)
	VALUES(1,1)


exec dbo.deleteExtraAlojamento 1,'verde','Glampinho','12EA1',1