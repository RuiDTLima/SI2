USE Glampinho


drop function dbo.listAtividades
drop proc listarAtividades
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
DECLARE @partipantes int
DECLARE @TempTable table (nome nvarchar(30),descrição nvarchar(255))

insert into @TempTable 
SELECT nome,descrição FROM Actividades INNER JOIN (
	SELECT ano,númeroSequencial,count(númeroSequencial) as participantes FROM Paga 
	GROUP BY númeroSequencial,ano ) as A ON A.númeroSequencial=Actividades.númeroSequencial and A.ano=Actividades.ano and lotaçãoMáxima>participantes and dataRealização between @dataInicio and @dataFim 

--This select returns data
insert into @rtnTable
SELECT nome,descrição FROM @TempTable 
return
END
GO

GO
CREATE PROC listarAtividades @dataInicio date,@dataFim date
AS	
BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRY
	select * from dbo.listAtividades(@dataInicio ,@dataFim)
	IF @@ROWCOUNT = 0 RAISERROR('As atividades encontram-se lotadas ou fora do intervalo especificado',20,1)
	COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 


