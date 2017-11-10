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

		SELECT nome,nomeParque,localização FROM AlojamentoEstada
		IF @@ROWCOUNT = 0 
		BEGIN
		SELECT númeroMáximoPessoas,tipoAlojamento FROM Alojamento WHERE númeroMáximoPessoas=@lotação and tipoAlojamento=@tipo
		IF @@ROWCOUNT > 0 
		INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localização, id) VALUES (@nomeAlojamento,@nomeParque,@localização,@idEstada)
		ELSE RAISERROR('Não há alojamentos nessas condições',5,1) 
		END
		ELSE 
		BEGIN 
		SELECT TOP 1 @nomeAlojamento=A.nome,@nomeParque=A.nomeParque,@localização=A.localização FROM ( 
		(SELECT nome,nomeParque,localização FROM Alojamento WHERE númeroMáximoPessoas=@lotação and tipoAlojamento=@tipo) as A
		INNER JOIN (SELECT nome,nomeParque,localização,AlojamentoEstada.id FROM AlojamentoEstada INNER JOIN 
		(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON A.nome=B.nome and A.localização=B.localização and A.nomeParque=B.nomeParque)
		if @nomeAlojamento is null /* impossivel ter um a null e os outros nao ? */
		RAISERROR('Não há alojamentos nessas condições',5,1)
		INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localização, id) VALUES (@nomeAlojamento,@nomeParque,@localização,@idEstada)
		END
		COMMIT

	exec dbo.addHospede @NIF,@idEstada
	exec dbo.addExtraPessoa @idExtraPessoa,@idEstada
	exec dbo.addExtraPessoa @idExtraAlojamento,@idEstada

   
END TRY
BEGIN CATCH
 IF @@TRANCOUNT > 0 ROLLBACK; 
END CATCH 


/*************** TESTE ********************************************************************************************/

exec dbo.createEstada 112233445,7,1,6,2,3,'bungalow','Preto','Glampinho','12E2'

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
drop proc addAlojamento
drop proc addExtraAlojamento
drop proc addExtraPessoa
drop proc addHospede


INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localização, id) VALUES ('Preto','Glampinho','12E2',2)
INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localização, id) VALUES ('Azul','Glampinho','12E2',3)
INSERT INTO Estada(id,dataInício,dataFim) VALUES(2,'2017-02-02','2017-02-03')
INSERT INTO Estada(id,dataInício,dataFim) VALUES(3,'2017-02-02','2017-02-03')