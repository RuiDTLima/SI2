/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script é o de criar uma estada com todas as RI correspondentes

1. Criar uma estada dado o NIF do hóspede responsável e o período temporal
pretendido;
2. Adicionar um alojamento de um dado tipo com uma determinada lotação a
uma estada;
3. Adicionar um hóspede a uma estada;
4. Adicionar um extra a um alojamento de uma estada;
5. Adicionar um extra pessoal a uma estada; 

**
**	Criado por         Grupo 4 
**	Data de Criação    08/11/17
**
******************************************************************************/
USE Glampinho



GO
CREATE PROC dbo.addAlojamento @lotação int, @tipo VARCHAR(8),@idEstada int
AS

DECLARE @actualDate DATETIME = GETDATE()
DECLARE @localização NVARCHAR(30)
DECLARE @nomeParque NVARCHAR(30)
DECLARE @nome NVARCHAR(30)

SELECT TOP 1 @nome=A.nome,@nomeParque=A.nomeParque,@localização=A.localização FROM ( 
(SELECT nome,nomeParque,localização FROM Alojamento WHERE númeroMáximoPessoas=@lotação and tipoAlojamento=@tipo) as A
INNER JOIN (SELECT nome,nomeParque,localização FROM AlojamentoEstada INNER JOIN 
(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON A.nome=B.nome and A.localização=B.localização and A.nomeParque=B.nomeParque)

if @nome=null or @nomeParque=null or @localização=null /* impossivel ver um a null e os outros nao ? */
RAISERROR('Não há alojamentos nessas condições',5,1)

INSERT INTO AlojamentoEstada(nome,nomeParque, localização, id) VALUES (@nome,@nomeParque,@localização,@idEstada)


GO
CREATE PROC dbo.addHospede @NIF int, @id int
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO HóspedeEstada(NIF,id,hóspede) VALUES (@NIF,@id,'true')
    COMMIT
END TRY
BEGIN CATCH
 ROLLBACK
END CATCH  

GO
CREATE PROC dbo.addExtraAlojamento @idExtra int,@nomeAlojamento nvarchar(30),@nomeParque nvarchar(30), @localização nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO AlojamentoEstada(nome,nomeParque, localização, id) VALUES(@nomeAlojamento,@nomeParque,@localização,@idExtra)
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
CREATE PROC dbo.createEstada @NIF int, @periodoTemporal int, @idEstada int,@lotação int, @idExtraAlojamento int,@idExtraPessoa int, @tipo VARCHAR(8),@nomeAlojamento nvarchar(30),@nomeParque nvarchar(30), @localização nvarchar(30)
AS
BEGIN TRY
    BEGIN TRANSACTION
	DECLARE @actualDate DATETIME = GETDATE()
	DECLARE @endDate DATE = DATEADD(DAY,@periodoTemporal,@actualDate)
    INSERT INTO Estada(id,dataInício,dataFim) VALUES(@idEstada,@actualDate,@endDate)
	INSERT INTO HóspedeEstada(NIF,id,hóspede) VALUES (@NIF,@idEstada,'true')

	exec dbo.addAlojamento @lotação,@tipo,@idEstada
	exec dbo.addHospede  @NIF,@idEstada
	exec dbo.addExtraAlojamento  @idExtraAlojamento,@nomeAlojamento,@nomeParque, @localização
	exec dbo.addExtraPessoa @idExtraPessoa,@idEstada

    COMMIT
END TRY
BEGIN CATCH
 
 ROLLBACK
END CATCH 


/*************** TESTE ********************************************************************************************/

exec dbo.createEstada 112233445,7,1,4,1,3,'tenda','verde','Glampinho','12EA1'

SELECT * FROM Hóspede
SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo
SELECT * FROM Extra
SELECT * FROM ESTADA
