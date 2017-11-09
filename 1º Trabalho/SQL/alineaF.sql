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

/**************INSERT *******************************************************/

INSERT INTO Extra(id, descrição, preçoDia, associado)
	VALUES(3, 'descricao', 12, 'pessoa')

/**************UPDATE *******************************************************/

UPDATE Extra SET preçoDia = preçoDia - 2 WHERE id = 2

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

INSERT INTO Extra(id, descrição, preçoDia, associado)
	VALUES(1,'descricao',12,'pessoa')

INSERT INTO Alojamento(nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
	VALUES('Glampinho','verde','12EA1','bonito',12,4,'tenda')

INSERT INTO Estada(id, dataInício, dataFim)
	VALUES(1,'03-15-17 10:30',null)

INSERT INTO AlojamentoExtra(nome, nomeParque, localização, id)
	VALUES('verde','Glampinho','12EA1',1)

INSERT INTO EstadaExtra(estadaId, ExtraId)
	VALUES(1,1)