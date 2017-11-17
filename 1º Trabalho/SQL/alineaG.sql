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

/******************************************* INSERT *******************************************************/
INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES('Glampinho', 1, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '03-15-17 10:30')

/******************************************* UPDATE *******************************************************/
UPDATE dbo.Actividades SET preçoParticipante = preçoParticipante - 2 WHERE nomeParque = 'Glampinho' AND númeroSequencial = 1

/******************************************* DELETE *******************************************************/
GO
CREATE PROCEDURE dbo.deleteAtividades @nomeParque NVARCHAR(30), @númeroSequencial INT AS
BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM dbo.Paga WHERE nomeParque = @nomeParque and númeroSequencial = @númeroSequencial
		DELETE FROM dbo.Actividades WHERE nomeParque = @nomeParque and númeroSequencial = @númeroSequencial
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT !=0
		ROLLBACK;
	THROW
END CATCH

/***************************************** TESTE ************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344)

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, NIF, preçoParticipante)
	VALUES('Glampinho', 1, 112233445, 3)

exec dbo.deleteAtividades 'Glampinho', 1

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.Hóspede
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Actividades