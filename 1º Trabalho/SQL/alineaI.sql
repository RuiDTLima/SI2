USE Glampinho

GO
CREATE PROC addHospedeAtividade @hospede int, @nomeParque nvarchar(30), @n�meroSequencial nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
    exec verificarHospedeParque @hospede,@nomeParque
	INSERT INTO Paga(nomeParque, n�meroSequencial, NIF) VALUES (@nomeParque, @n�meroSequencial,@hospede)
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
	SELECT nomeParque,localiza��o FROM Alojamento WHERE nomeParque=@nomeParque) AS A ON A.nomeParque=AlojamentoEstada.nomeParque and AlojamentoEstada.localiza��o=A.localiza��o
	IF @@ROWCOUNT = 0 RAISERROR('N�o existe nenhuma Estada no Parque referido',20,1) 

	SELECT @idEstada FROM Estada INNER JOIN (
	SELECT H�spedeEstada.id FROM H�spedeEstada WHERE NIF=@hospede) as A  ON A.id=@idEstada
	IF @@ROWCOUNT = 0 RAISERROR('H�spede n�o instalado em nenhuma Estada neste Parque',20,1) 

	SELECT * FROM Estada WHERE id=@idEstada and dataFim>@actualDate
	IF @@ROWCOUNT = 0 RAISERROR('H�spede j� n�o est� instalado na estada',20,1) 
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


SELECT * FROM Actividades
SELECT * FROM H�spede
SELECT * FROM H�spedeEstada
SELECT * FROM AlojamentoEstada
SELECT * FROM Paga

exec addHospedeAtividade 112233445,'Glampinho',1

/* D�VIDA -  A Data de realiza��o da atividade deveria estar na tabela Paga??? - DESSA FORMA A ENTIDADE Atividade n�o tinha o atributo data, tinha apenas
a indica��o de quantas atividades est�o disponiveis, e a entidade Paga ficava com a info da data de realiza��o */