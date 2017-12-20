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

/******************************************* INSERT *******************************************************/
INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '03-15-17 10:30')

/******************************************* UPDATE *******************************************************/
UPDATE dbo.Actividades SET pre�oParticipante = pre�oParticipante - 2 WHERE nomeParque = 'Glampinho' AND n�meroSequencial = 1 AND ano = 17

/******************************************* DELETE *******************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name = 'deleteAtividades')
	DROP PROCEDURE dbo.deleteAtividades;
GO
CREATE PROCEDURE dbo.deleteAtividades @nomeParque NVARCHAR(30), @n�meroSequencial INT, @ano INT AS
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		DELETE FROM dbo.Paga WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano
		DELETE FROM dbo.Actividades WHERE nomeParque = @nomeParque AND n�meroSequencial = @n�meroSequencial AND ano = @ano
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

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344)

/*---- Inserir actividade -----*/
INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES('Glampinho', 1, 2017, 112233445, 3)

exec dbo.deleteAtividades 'Glampinho', 1, 2017 

SELECT * FROM dbo.ParqueCampismo
SELECT * FROM dbo.H�spede
SELECT * FROM dbo.Paga
SELECT * FROM dbo.Actividades

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
VALUES(@nomeParque, @n�meroSequencial, @nome, @descri��o, @lota��oM�xima, @pre�oParticipante, @dataRealiza��o)