USE Glampinho

GO
CREATE PROC addHospedeAtividade @hospede int, @nomeParque nvarchar(30), @númeroSequencial nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
    exec verificarHospedeParque @hospede,@nomeParque
	INSERT INTO Paga(nomeParque, númeroSequencial, NIF) VALUES (@nomeParque, @númeroSequencial,@hospede)
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


GO
CREATE PROC verificarHospedeParque @hospede int, @nomeParque nvarchar(30) 
AS
BEGIN TRY
    BEGIN TRANSACTION
    DECLARE @actualDate DATETIME = GETDATE()
	DECLARE @idEstada int

	SELECT @idEstada=id FROM AlojamentoEstada INNER JOIN (
	SELECT nomeParque,localização FROM Alojamento WHERE nomeParque=@nomeParque) AS A ON A.nomeParque=AlojamentoEstada.nomeParque and AlojamentoEstada.localização=A.localização
	IF @@ROWCOUNT = 0 RAISERROR('Não existe nenhuma Estada no Parque referido',20,1) 

	SELECT @idEstada FROM Estada INNER JOIN (
	SELECT HóspedeEstada.id FROM HóspedeEstada WHERE NIF=@hospede) as A  ON A.id=@idEstada
	IF @@ROWCOUNT = 0 RAISERROR('Hóspede não instalado em nenhuma Estada neste Parque',20,1) 

	SELECT * FROM Estada WHERE id=@idEstada and dataFim>@actualDate
	IF @@ROWCOUNT = 0 RAISERROR('Hóspede já não está instalado na estada',20,1) 
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


SELECT * FROM Actividades
SELECT * FROM Hóspede
SELECT * FROM HóspedeEstada
SELECT * FROM AlojamentoEstada
SELECT * FROM Paga

exec addHospedeAtividade 112233445,'Glampinho',1

/* DÚVIDA -  A Data de realização da atividade deveria estar na tabela Paga??? - DESSA FORMA A ENTIDADE Atividade não tinha o atributo data, tinha apenas
a indicação de quantas atividades estão disponiveis, e a entidade Paga ficava com a info da data de realização */