USE Glampinho



GO
CREATE FUNCTION dbo.listAtividades(@dataInicio date,@dataFim date)
RETURNS  @rtnTable TABLE 
(
    -- columns returned by the function
    nome nvarchar(30) NOT NULL,
    descrição nvarchar(255) NOT NULL
)
AS
BEGIN
DECLARE @númeroAtividade int
DECLARE @lotação int
DECLARE @partipantes int
DECLARE @TempTable table (nome nvarchar(30),descrição nvarchar(255))

insert into @TempTable 
SELECT nome,descrição FROM Actividades INNER JOIN (
	SELECT númeroSequencial,count(númeroSequencial) as participantes FROM Paga 
	GROUP BY númeroSequencial ) as A ON A.númeroSequencial=Actividades.númeroSequencial and lotaçãoMáxima>participantes and dataRealização between @dataInicio and @dataFim 

--This select returns data
insert into @rtnTable
SELECT nome,descrição FROM @TempTable 
return
END
GO

GO
CREATE PROC listarAtividades @dataInicio date,@dataFim date
AS
BEGIN TRY
    BEGIN TRANSACTION

	select * from dbo.listAtividades(@dataInicio ,@dataFim)
	IF @@ROWCOUNT = 0 RAISERROR('As atividades encontram-se lotadas ou fora do intervalo especificado',20,1)
	COMMIT

	/*
	IF @@ROWCOUNT = 0 RAISERROR('As atividades encontram-se lotadas',20,1) 
	SELECT @númeroAtividade=númeroSequencial FROM Actividades WHERE dataRealização between @dataInicio and @dataFim 
	IF @@ROWCOUNT = 0 RAISERROR('Não existem atividade dentro do intervalo especificado',20,1) */
   

END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


exec listarAtividades '2017-03-12' ,'2017-03-16' 

INSERT INTO Paga 
	VALUES ('Glampinho', 2,2)
	

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (2, 'José', 'Rua 1', 'OI@gmail.com', 11223344)

UPDATE Actividades SET lotaçãoMáxima=4 WHERE númeroSequencial=1
UPDATE Actividades SET lotaçãoMáxima=2 WHERE númeroSequencial=2

INSERT INTO Actividades (nomeParque,númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES('Glampinho',2,'Yoga','Relaxing',2,3,'04-15-17 10:30')

SELECT * FROM Paga
SELECT * FROM Actividades