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

		SELECT nome,nomeParque,localiza��o FROM AlojamentoEstada
		IF @@ROWCOUNT = 0 
		BEGIN
		SELECT n�meroM�ximoPessoas,tipoAlojamento FROM Alojamento WHERE n�meroM�ximoPessoas=@lota��o and tipoAlojamento=@tipo
		IF @@ROWCOUNT > 0 
		INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES (@nomeAlojamento,@nomeParque,@localiza��o,@idEstada)
		ELSE RAISERROR('N�o h� alojamentos nessas condi��es',5,1) 
		END
		ELSE 
		BEGIN 
		SELECT TOP 1 @nomeAlojamento=A.nome,@nomeParque=A.nomeParque,@localiza��o=A.localiza��o FROM ( 
		(SELECT nome,nomeParque,localiza��o FROM Alojamento WHERE n�meroM�ximoPessoas=@lota��o and tipoAlojamento=@tipo) as A
		INNER JOIN (SELECT nome,nomeParque,localiza��o,AlojamentoEstada.id FROM AlojamentoEstada INNER JOIN 
		(SELECT id FROM Estada WHERE dataFim<@actualDate) AS EstadasDisponiveis ON EstadasDisponiveis.id=AlojamentoEstada.id ) as B ON A.nome=B.nome and A.localiza��o=B.localiza��o and A.nomeParque=B.nomeParque)
		if @nomeAlojamento is null /* impossivel ter um a null e os outros nao ? */
		RAISERROR('N�o h� alojamentos nessas condi��es',5,1)
		INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES (@nomeAlojamento,@nomeParque,@localiza��o,@idEstada)
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
drop proc addAlojamento
drop proc addExtraAlojamento
drop proc addExtraPessoa
drop proc addHospede


INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES ('Preto','Glampinho','12E2',2)
INSERT INTO dbo.AlojamentoEstada(nome,nomeParque, localiza��o, id) VALUES ('Azul','Glampinho','12E2',3)
INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(2,'2017-02-02','2017-02-03')
INSERT INTO Estada(id,dataIn�cio,dataFim) VALUES(3,'2017-02-02','2017-02-03')