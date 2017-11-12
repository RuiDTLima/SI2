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
CREATE PROC dbo.addExtraPessoa @idExtra int,@idEstada int 
AS
BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO EstadaExtra VALUES(@idEstada,@idExtra)
    COMMIT
END TRY
BEGIN CATCH
RAISERROR('ERRO add Extra Pessoa',20,1)
 ROLLBACK
END CATCH 

GO
CREATE PROC dbo.createEstada @NIF int, @periodoTemporal int, @idEstada int,@lota��o int, @idExtraAlojamento int,@idExtraPessoa int,@tipo varchar(9)
AS
BEGIN TRY
    BEGIN TRANSACTION

	DECLARE @actualDate DATETIME = GETDATE()
	DECLARE @endDate DATE = DATEADD(DAY,@periodoTemporal,@actualDate)
	DECLARE @nomeAlojamento nvarchar(30)
	DECLARE @nomeParque nvarchar(30)
	DECLARE @localiza��o nvarchar(30)

	INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(@idEstada,@actualDate,@endDate)
	INSERT INTO H�spedeEstada(NIF,id,h�spede) VALUES (@NIF,@idEstada,'true')

		IF NOT EXISTS (SELECT tipoAlojamento,n�meroM�ximoPessoas FROM Alojamento WHERE tipoAlojamento=@tipo and n�meroM�ximoPessoas=@lota��o )
		RAISERROR ('N�o h� alojamentos nessas condi��es',20,1) 
		ELSE 
		BEGIN
		SELECT @nomeParque=A.nomeParque,@localiza��o=A.localiza��o FROM AlojamentoEstada INNER JOIN (
		SELECT nomeParque,localiza��o FROM Alojamento WHERE n�meroM�ximoPessoas=@lota��o and tipoAlojamento=@tipo) as A ON AlojamentoEstada.nomeParque=A.nomeParque and AlojamentoEstada.localiza��o=A.localiza��o
		IF @@ROWCOUNT = 0 
		BEGIN
		SELECT  TOP 1 @nomeParque=nomeParque,@localiza��o=localiza��o FROM Alojamento WHERE tipoAlojamento=@tipo and n�meroM�ximoPessoas=@lota��o
		INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id) VALUES (@nomeParque,@localiza��o,@idEstada)
		END
		ELSE
		BEGIN
		SELECT TOP 1 @nomeParque=A.nomeParque,@localiza��o=A.localiza��o FROM ( 
		(SELECT nomeParque,localiza��o FROM Alojamento WHERE n�meroM�ximoPessoas=@lota��o and tipoAlojamento=@tipo) as A
		INNER JOIN (SELECT nomeParque,localiza��o,AlojamentoEstada.id FROM AlojamentoEstada INNER JOIN 
		(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON  A.localiza��o=B.localiza��o and A.nomeParque=B.nomeParque)
		IF @nomeAlojamento is null /* impossivel ter um a null e os outros nao ? */
		RAISERROR('N�o h� alojamentos nessas condi��es',20,1)
		INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id) VALUES (@nomeParque,@localiza��o,@idEstada)
		END
		END
		
		COMMIT

		exec dbo.addExtraPessoa @idExtraPessoa,@idEstada
		exec dbo.addExtraPessoa @idExtraAlojamento,@idEstada

		
   
END TRY
BEGIN CATCH
 IF @@TRANCOUNT > 0 ROLLBACK; 
END CATCH 


/*************** TESTE ********************************************************************************************/

exec dbo.createEstada 112233445,7,1,4,2,3,'tenda'

SELECT * FROM H�spede
SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo
SELECT * FROM Extra
SELECT * FROM Tenda
SELECT * FROM Estada
SELECT * FROM EstadaExtra
SELECT * FROM AlojamentoEstada
SELECT * FROM H�spedeEstada

exec dbo.InsertAlojamentoTenda 'Glampinho','Preto', '12E2','boa qualidade',12,4,25

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
INSERT INTO Actividades (nomeParque,n�meroSequencial, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES('Glampinho',1,'FUT7','Jogo de futebol 7vs7','14',3,'03-15-17 10:30')

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(3, 'descricao', 12, 'pessoa')
INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(2, 'descricao', 10, 'alojamento')


drop proc createEstada
drop proc addExtraPessoa
drop proc addHospede


INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id) VALUES ('Glampinho','12E2',2)
INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id) VALUES ('Glampinho','12E2',3)
INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(2,'2017-02-02','2017-02-03')
INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(3,'2017-02-02','2017-02-03')