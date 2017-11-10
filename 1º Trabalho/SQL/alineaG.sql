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

INSERT INTO Actividades(nomeParque, n�meroSequencial, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES('Glampinho', 1, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '03-15-17 10:30')

/**************UPDATE *******************************************************/

UPDATE Actividades SET pre�oParticipante = pre�oParticipante - 2 WHERE nomeParque = 'Glampinho' AND n�meroSequencial = 1

/**************DELETE *******************************************************/

GO
CREATE PROCEDURE dbo.deleteAtividades @nomeParque NVARCHAR(30), @n�meroSequencial INT 
AS
BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM Paga WHERE nomeParque = @nomeParque and n�meroSequencial = @n�meroSequencial
		DELETE FROM Actividades WHERE nomeParque = @nomeParque and n�meroSequencial = @n�meroSequencial
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH

/***************** TESTE *******************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344)

INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, NIF)
	VALUES('Glampinho', 1, 112233445)

exec dbo.deleteAtividades 'Glampinho', 1

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Actividades