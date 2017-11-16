USE Glampinho



GO
CREATE FUNCTION dbo.listAtividades(@dataInicio date,@dataFim date)
RETURNS  @rtnTable TABLE 
(
    -- columns returned by the function
    nome nvarchar(30) NOT NULL,
    descri��o nvarchar(255) NOT NULL
)
AS
BEGIN
DECLARE @n�meroAtividade int
DECLARE @lota��o int
DECLARE @partipantes int
DECLARE @TempTable table (nome nvarchar(30),descri��o nvarchar(255))

insert into @TempTable 
SELECT nome,descri��o FROM Actividades INNER JOIN (
	SELECT n�meroSequencial,count(n�meroSequencial) as participantes FROM Paga 
	GROUP BY n�meroSequencial ) as A ON A.n�meroSequencial=Actividades.n�meroSequencial and lota��oM�xima>participantes and dataRealiza��o between @dataInicio and @dataFim 

--This select returns data
insert into @rtnTable
SELECT nome,descri��o FROM @TempTable 
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
	SELECT @n�meroAtividade=n�meroSequencial FROM Actividades WHERE dataRealiza��o between @dataInicio and @dataFim 
	IF @@ROWCOUNT = 0 RAISERROR('N�o existem atividade dentro do intervalo especificado',20,1) */
   

END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


exec listarAtividades '2017-03-12' ,'2017-03-16' 

INSERT INTO Paga 
	VALUES ('Glampinho', 2,2)
	

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (2, 'Jos�', 'Rua 1', 'OI@gmail.com', 11223344)

UPDATE Actividades SET lota��oM�xima=4 WHERE n�meroSequencial=1
UPDATE Actividades SET lota��oM�xima=2 WHERE n�meroSequencial=2

INSERT INTO Actividades (nomeParque,n�meroSequencial, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES('Glampinho',2,'Yoga','Relaxing',2,3,'04-15-17 10:30')

SELECT * FROM Paga
SELECT * FROM Actividades