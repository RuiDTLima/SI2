USE Glampinho


GO
CREATE VIEW Bungalows AS 

SELECT ParqueCampismo.nome,ParqueCampismo.email,ParqueCampismo.estrelas,ParqueCampismo.morada,ParqueCampismo.telefones,B.descrição,B.localização,B.nome as nomeAlojamento,númeroMáximoPessoas,B.preçoBase,B.tipoAlojamento,B.tipologia FROM 
ParqueCampismo 
INNER JOIN (
		SELECT Alojamento.descrição,Alojamento.localização,Alojamento.nome,Alojamento.nomeParque,Alojamento.númeroMáximoPessoas,Alojamento.preçoBase,Alojamento.tipoAlojamento,A.tipologia FROM 
		Alojamento  
		INNER JOIN 
		(SELECT * FROM Bungalow)AS A
		 ON Alojamento.localização=A.localização AND Alojamento.nomeParque=A.nomeParque AND tipoAlojamento='bungalow'
		 ) AS B
		  ON B.nomeParque=ParqueCampismo.nome

DROP TRIGGER trgBungalowInsert

/*************** TRIGGER DE INSERT ***************************************************************/
GO
CREATE TRIGGER trgBungalowInsert
ON Bungalows
INSTEAD OF INSERT
AS
BEGIN TRANSACTION
BEGIN TRY
	SET nocount ON
		DECLARE @num int
		DECLARE @nomeParque NVARCHAR(30),@nome NVARCHAR(30),@localização NVARCHAR(30),@descrição NVARCHAR(30),@preçoBase INT,
	    @númeroMáximoPessoas INT,@tipologia CHAR(2)
    SELECT @num=count(*) FROM inserted
    --Diferentes formas de inserir, dependendo do nº de inserções
    IF (@num = 0)
        RETURN 
    IF (@num = 1)
    BEGIN
		select @nomeParque=nome,@nome=nomeAlojamento,@localização=localização,@descrição=descrição,@preçoBase=preçoBase,@númeroMáximoPessoas=númeroMáximoPessoas,@tipologia=tipoAlojamento  from inserted
		exec dbo.InsertAlojamentoBungalow @nomeParque,@nome,@localização,@descrição,@preçoBase,@númeroMáximoPessoas,@tipologia
	END		

    ELSE
    BEGIN
        declare acursor cursor local
        for select nome,nomeAlojamento,localização,descrição,preçoBase,númeroMáximoPessoas,tipoAlojamento  from inserted
        open acursor
        fetch next from acursor into @nomeParque,@nome,@localização,@descrição,@preçoBase,@númeroMáximoPessoas,@tipologia
        while (@@FETCH_STATUS = 0 )
        BEGIN
        exec dbo.InsertAlojamentoBungalow @nomeParque,@nome,@localização,@descrição,@preçoBase,@númeroMáximoPessoas,@tipologia
        fetch next from acursor into @nomeParque,@nome,@localização,@descrição,@preçoBase,@númeroMáximoPessoas,@tipologia
		END
	END
	COMMIT
	
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH

exec dbo.InsertAlojamentoBungalow 'Glampinho','Teste2','12E1','Testte',2,2,'bungalow'
INSERT INTO Bungalows(nome,nomeAlojamento,localização,descrição,preçoBase,númeroMáximoPessoas,tipoAlojamento) VALUES ('Glampinho','BOAS','12','Testte',2,2,'T0')

/*************** TRIGGER DE DELETE ***************************************************************/

DROP TRIGGER trgBungalowDelete
GO
CREATE TRIGGER trgBungalowDelete
ON Bungalows
INSTEAD OF DELETE
AS
BEGIN TRANSACTION
BEGIN TRY
	SET nocount ON
		DECLARE @num int
		DECLARE @nomeParque NVARCHAR(30),@localização NVARCHAR(30)
    SELECT @num=count(*) FROM deleted
    --Diferentes formas de inserir, dependendo do nº de inserções
    IF (@num = 0)
        RETURN 
    IF (@num = 1)
    BEGIN
		select @nomeParque=nome,@localização=localização from deleted
		exec dbo.deleteAlojamento @localização,@nomeParque
	END		
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH


DELETE FROM Bungalows WHERE nome='Glampinho' and nomeAlojamento='Teste4'


/*************** TRIGGER DE UPDATE ***************************************************************/		



																	 
																										 