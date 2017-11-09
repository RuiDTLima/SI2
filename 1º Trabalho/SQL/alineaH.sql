/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script � o de criar uma estada com todas as RI correspondentes

1. Criar uma estada dado o NIF do h�spede respons�vel e o per�odo temporal
pretendido;
2. Adicionar um alojamento de um dado tipo com uma determinada lota��o a
uma estada;
3. Adicionar um h�spede a uma estada;
4. Adicionar um extra a um alojamento de uma estada;
5. Adicionar um extra pessoal a uma estada; 

**
**	Criado por         Grupo 4 
**	Data de Cria��o    08/11/17
**
******************************************************************************/
USE Glampinho



GO
CREATE PROC dbo.addAlojamento @lota��o int, @tipo VARCHAR(8),@idEstada int
AS

DECLARE @actualDate DATETIME = GETDATE()
DECLARE @localiza��o NVARCHAR(30)
DECLARE @nomeParque NVARCHAR(30)
DECLARE @nome NVARCHAR(30)

SELECT TOP 1 @nome=A.nome,@nomeParque=A.nomeParque,@localiza��o=A.localiza��o FROM ( 
(SELECT nome,nomeParque,localiza��o FROM Alojamento WHERE n�meroM�ximoPessoas=@lota��o and tipoAlojamento=@tipo) as A
INNER JOIN (SELECT nome,nomeParque,localiza��o FROM AlojamentoEstada INNER JOIN 
(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON A.nome=B.nome and A.localiza��o=B.localiza��o and A.nomeParque=B.nomeParque)

if @nome=null or @nomeParque=null or @localiza��o=null /* impossivel ver um a null e os outros nao ? */
RAISERROR('N�o h� alojamentos nessas condi��es',5,1)

INSERT INTO AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES (@nome,@nomeParque,@localiza��o,@idEstada)


GO
CREATE PROC dbo.addHospede @NIF int, @id int
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO H�spedeEstada(NIF,id,h�spede) VALUES (@NIF,@id,'true')
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH  

GO
CREATE PROC dbo.addExtraAlojamento @idExtra int,@nomeAlojamento nvarchar(30),@nomeParque nvarchar(30), @localiza��o nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES(@nomeAlojamento,@nomeParque,@localiza��o,@idExtra)
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 

GO
CREATE PROC dbo.addExtraPessoa @idExtra int,@idEstada int 
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO EstadaExtra VALUES(@idEstada,@idExtra)
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH 

GO
CREATE PROC dbo.createEstada @NIF int, @periodoTemporal int, @idEstada int,@lota��o int, @idExtraAlojamento int,@idExtraPessoa int, @tipo VARCHAR(8),@nomeAlojamento nvarchar(30),@nomeParque nvarchar(30), @localiza��o nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
	DECLARE @actualDate DATETIME = GETDATE()
	DECLARE @endDate DATE = DATEADD(DAY,@periodoTemporal,@actualDate)
    INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(@idEstada,@actualDate,@endDate)
	INSERT INTO H�spedeEstada(NIF,id,h�spede) VALUES (@NIF,@idEstada,'true')

	exec dbo.addAlojamento @lota��o,@tipo,@idEstada
	exec dbo.addHospede  @NIF,@idEstada
	exec dbo.addExtraAlojamento  @idExtraAlojamento,@nomeAlojamento,@nomeParque, @localiza��o
	exec dbo.addExtraPessoa @idExtraPessoa,@idEstada

    COMMIT
END TRY
BEGIN CATCH
 
 ROLLBACK
END CATCH 


/*************** TESTE ********************************************************************************************/

exec dbo.createEstada 112233445,7,1,4,1,3,'tenda','verde','Glampinho','12EA1'

SELECT * FROM H�spede
SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo
SELECT * FROM Extra
SELECT * FROM ESTADA
