/*******************************************************************************
**	Nome               alineaG
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de uma atividade
**
**	Criado por         Grupo 4 
**	Data de Criação    08/11/17
**
******************************************************************************/

USE Glampinho

/**************INSERT *******************************************************/

INSERT INTO Actividades (nomeParque,númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES('Glampinho',1,'FUT7','Jogo de futebol 7vs7','14',3,'03-15-17 10:30')

/**************UPDATE *******************************************************/

UPDATE Actividades SET preçoParticipante=preçoParticipante-2 WHERE nomeParque='Glampinho' and númeroSequencial=1

/**************DELETE *******************************************************/

GO
CREATE PROC deleteAtividades @nomeParque nvarchar(30), @númeroSequencial int 
AS
BEGIN TRANSACTION
BEGIN TRY
	DELETE FROM Paga WHERE nomeParque=@nomeParque and númeroSequencial=@númeroSequencial
	DELETE FROM Actividades WHERE nomeParque=@nomeParque and númeroSequencial=@númeroSequencial
	COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH



/***************** TESTE *******************************************************************/

INSERT INTO Paga(nomeParque, númeroSequencial)
	VALUES('Glampinho',1)


exec dbo.deleteAtividades 'Glampinho',1