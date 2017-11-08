/*******************************************************************************
**	Nome               alineaG
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de uma atividade
**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/

USE Glampinho

/**************INSERT *******************************************************/

INSERT INTO Actividades (nomeParque,n�meroSequencial, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES('Glampinho',1,'FUT7','Jogo de futebol 7vs7','14',3,'03-15-17 10:30')

/**************UPDATE *******************************************************/

UPDATE Actividades SET pre�oParticipante=pre�oParticipante-2 WHERE nomeParque='Glampinho' and n�meroSequencial=1

/**************DELETE *******************************************************/

GO
CREATE PROC deleteAtividades @nomeParque nvarchar(30), @n�meroSequencial int 
AS
BEGIN TRANSACTION
BEGIN TRY
	DELETE FROM Paga WHERE nomeParque=@nomeParque and n�meroSequencial=@n�meroSequencial
	DELETE FROM Actividades WHERE nomeParque=@nomeParque and n�meroSequencial=@n�meroSequencial
	COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH



/***************** TESTE *******************************************************************/

INSERT INTO Paga(nomeParque, n�meroSequencial)
	VALUES('Glampinho',1)


exec dbo.deleteAtividades 'Glampinho',1