USE Glampinho


drop function dbo.listAtividades
drop proc listarAtividades
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
DECLARE @partipantes int
DECLARE @TempTable table (nome nvarchar(30),descri��o nvarchar(255))

insert into @TempTable 
SELECT nome,descri��o FROM Actividades INNER JOIN (
	SELECT ano,n�meroSequencial,count(n�meroSequencial) as participantes FROM Paga 
	GROUP BY n�meroSequencial,ano ) as A ON A.n�meroSequencial=Actividades.n�meroSequencial and A.ano=Actividades.ano and lota��oM�xima>participantes and dataRealiza��o between @dataInicio and @dataFim 

--This select returns data
insert into @rtnTable
SELECT nome,descri��o FROM @TempTable 
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


