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
CREATE PROC dbo.createEstada @NIF int, @periodoTemporal int, @idEstada int,@lotação int, @idExtraAlojamento int,@idExtraPessoa int,@tipo varchar(9)
AS
BEGIN TRY
    BEGIN TRANSACTION

	DECLARE @actualDate DATETIME = GETDATE()
	DECLARE @endDate DATE = DATEADD(DAY,@periodoTemporal,@actualDate)
	DECLARE @nomeAlojamento nvarchar(30)
	DECLARE @nomeParque nvarchar(30)
	DECLARE @localização nvarchar(30)

	INSERT INTO Estada(id,dataInício,dataFim) VALUES(@idEstada,@actualDate,@endDate)
	INSERT INTO HóspedeEstada(NIF,id,hóspede) VALUES (@NIF,@idEstada,'true')

		IF NOT EXISTS (SELECT tipoAlojamento,númeroMáximoPessoas FROM Alojamento WHERE tipoAlojamento=@tipo and númeroMáximoPessoas=@lotação )
		RAISERROR ('Não há alojamentos nessas condições',20,1) 
		ELSE 
		BEGIN
		SELECT @nomeParque=A.nomeParque,@localização=A.localização FROM AlojamentoEstada INNER JOIN (
		SELECT nomeParque,localização FROM Alojamento WHERE númeroMáximoPessoas=@lotação and tipoAlojamento=@tipo) as A ON AlojamentoEstada.nomeParque=A.nomeParque and AlojamentoEstada.localização=A.localização
		IF @@ROWCOUNT = 0 
		BEGIN
		SELECT  TOP 1 @nomeParque=nomeParque,@localização=localização FROM Alojamento WHERE tipoAlojamento=@tipo and númeroMáximoPessoas=@lotação
		INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id) VALUES (@nomeParque,@localização,@idEstada)
		END
		ELSE
		BEGIN
		SELECT TOP 1 @nomeParque=A.nomeParque,@localização=A.localização FROM ( 
		(SELECT nomeParque,localização FROM Alojamento WHERE númeroMáximoPessoas=@lotação and tipoAlojamento=@tipo) as A
		INNER JOIN (SELECT nomeParque,localização,AlojamentoEstada.id FROM AlojamentoEstada INNER JOIN 
		(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON  A.localização=B.localização and A.nomeParque=B.nomeParque)
		IF @nomeAlojamento is null /* impossivel ter um a null e os outros nao ? */
		RAISERROR('Não há alojamentos nessas condições',20,1)
		INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id) VALUES (@nomeParque,@localização,@idEstada)
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

SELECT * FROM Hóspede
SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo
SELECT * FROM Extra
SELECT * FROM Tenda
SELECT * FROM Estada
SELECT * FROM EstadaExtra
SELECT * FROM AlojamentoEstada
SELECT * FROM HóspedeEstada

exec dbo.InsertAlojamentoTenda 'Glampinho','Preto', '12E2','boa qualidade',12,4,25

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')
INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)
INSERT INTO Actividades (nomeParque,númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES('Glampinho',1,'FUT7','Jogo de futebol 7vs7','14',3,'03-15-17 10:30')

INSERT INTO Extra(id, descrição, preçoDia, associado)
	VALUES(3, 'descricao', 12, 'pessoa')
INSERT INTO Extra(id, descrição, preçoDia, associado)
	VALUES(2, 'descricao', 10, 'alojamento')


drop proc createEstada
drop proc addExtraPessoa
drop proc addHospede


INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id) VALUES ('Glampinho','12E2',2)
INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id) VALUES ('Glampinho','12E2',3)
INSERT INTO Estada(id,dataInício,dataFim) VALUES(2,'2017-02-02','2017-02-03')
INSERT INTO Estada(id,dataInício,dataFim) VALUES(3,'2017-02-02','2017-02-03')