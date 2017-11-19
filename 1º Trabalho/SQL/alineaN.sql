USE Glampinho


GO
CREATE VIEW Bungalows AS 

SELECT ParqueCampismo.nome,ParqueCampismo.email,ParqueCampismo.estrelas,ParqueCampismo.morada,B.descri��o,B.localiza��o,B.nome as nomeAlojamento,n�meroM�ximoPessoas,B.pre�oBase,B.tipoAlojamento,B.tipologia FROM 
ParqueCampismo 
INNER JOIN (
		SELECT Alojamento.descri��o,Alojamento.localiza��o,Alojamento.nome,Alojamento.nomeParque,Alojamento.n�meroM�ximoPessoas,Alojamento.pre�oBase,Alojamento.tipoAlojamento,A.tipologia FROM 
		Alojamento  
		INNER JOIN 
		(SELECT * FROM Bungalow)AS A
		 ON Alojamento.localiza��o=A.localiza��o AND Alojamento.nomeParque=A.nomeParque AND tipoAlojamento='bungalow'
		 ) AS B
		  ON B.nomeParque=ParqueCampismo.nome

DROP TRIGGER trgBungalowInsert

/*************** TRIGGER DE INSERT ***************************************************************/
GO
CREATE TRIGGER trgBungalowInsert
ON Bungalows
INSTEAD OF INSERT
AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY
	SET nocount ON
		DECLARE @num int
		DECLARE @nomeParque NVARCHAR(30),@nome NVARCHAR(30),@localiza��o NVARCHAR(30),@descri��o NVARCHAR(30),@pre�oBase INT,
	    @n�meroM�ximoPessoas INT,@tipologia CHAR(2)
    SELECT @num=count(*) FROM inserted
    --Diferentes formas de inserir, dependendo do n� de inser��es
    IF (@num = 0)
        RETURN 
    IF (@num = 1)
    BEGIN
		select @nomeParque=nome,@nome=nomeAlojamento,@localiza��o=localiza��o,@descri��o=descri��o,@pre�oBase=pre�oBase,@n�meroM�ximoPessoas=n�meroM�ximoPessoas,@tipologia=tipologia  from inserted
		exec dbo.InsertAlojamentoBungalow @nomeParque,@nome,@localiza��o,@descri��o,@pre�oBase,@n�meroM�ximoPessoas,@tipologia
	END		

    ELSE
    BEGIN
        declare acursor cursor local
        for select nome,nomeAlojamento,localiza��o,descri��o,pre�oBase,n�meroM�ximoPessoas,tipologia  from inserted
        open acursor
        fetch next from acursor into @nomeParque,@nome,@localiza��o,@descri��o,@pre�oBase,@n�meroM�ximoPessoas,@tipologia
        while (@@FETCH_STATUS = 0 )
        BEGIN
        exec dbo.InsertAlojamentoBungalow @nomeParque,@nome,@localiza��o,@descri��o,@pre�oBase,@n�meroM�ximoPessoas,@tipologia
        fetch next from acursor into @nomeParque,@nome,@localiza��o,@descri��o,@pre�oBase,@n�meroM�ximoPessoas,@tipologia
		END
	END
	COMMIT
	
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH

exec dbo.InsertAlojamentoBungalow 'Glampinho','Teste2','12E1','Testte',2,2,'bungalow'
INSERT INTO Bungalows(nome,nomeAlojamento,localiza��o,descri��o,pre�oBase,n�meroM�ximoPessoas,tipologia) VALUES ('Glampinho','BOAS','12','Testte',2,2,'T0')

/*************** TRIGGER DE DELETE ***************************************************************/

DROP TRIGGER trgBungalowDelete
GO
CREATE TRIGGER trgBungalowDelete
ON Bungalows
INSTEAD OF DELETE
AS
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY
	SET nocount ON
		DECLARE @num int
		DECLARE @nomeParque NVARCHAR(30),@localiza��o NVARCHAR(30)
    SELECT @num=count(*) FROM deleted
    --Diferentes formas de inserir, dependendo do n� de inser��es
    IF (@num = 0)
        RETURN 
    IF (@num = 1)
    BEGIN
		select @nomeParque=nome,@localiza��o=localiza��o from deleted
		exec dbo.deleteAlojamento @localiza��o,@nomeParque
	END		
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH


DELETE FROM Bungalows WHERE nome='Glampinho' and nomeAlojamento='Teste4'


/*************** TRIGGER DE UPDATE ***************************************************************/		

DROP TRIGGER trgBungalowUpdate
/*
GO
CREATE TRIGGER trgBungalowUpdate
ON Bungalows
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION
BEGIN TRY
	SET nocount ON
		DECLARE @num int
		DECLARE @nomeParqueDeleted NVARCHAR(30),@localiza��oDeleted NVARCHAR(30)
		DECLARE @nomeParque NVARCHAR(30),@localiza��o NVARCHAR(30),@tipologia VARCHAR(2)
    SELECT @num=count(*) FROM inserted
   
    IF (@num = 0)
        RETURN 
    IF (@num = 1)
    BEGIN
	SELECT @nomeParqueDeleted=nome,@localiza��oDeleted=localiza��o FROM deleted
	SELECT @nomeParque=nome,@localiza��o=localiza��o,@tipologia=tipologia from inserted

	UPDATE Bungalow SET localiza��o=@localiza��o,tipologia=@tipologia WHERE nomeParque=@nomeParqueDeleted AND localiza��o=@localiza��oDeleted
	UPDATE Alojamento SET localiza��o=@localiza��o WHERE nomeParque=@nomeParqueDeleted AND localiza��o=@localiza��oDeleted	
	END		
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH





SELECT * FROM Bungalows

SELECT * FROM Alojamento
SELECT * FROM Bungalow*/

UPDATE Bungalows SET localiza��o='121' WHERE nome='Glampinho' and nomeAlojamento='LOL'

																	 
																										 