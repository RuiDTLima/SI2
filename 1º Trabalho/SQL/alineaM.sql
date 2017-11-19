/*******************************************************************************
**	Nome               alineaM
**	
**	Objectivo          O objectivo deste script é o de obter a média dos 
**						pagamentos realizados num dado ano.
**
**	Criado por         Grupo 4 
**	Data de Criação    18/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** FUNÇÂO PARA CALCULAR A MÉDIA DOS PAGAMENTOS ************************************************************************/
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'media')
	DROP FUNCTION dbo.media;
GO
CREATE FUNCTION	dbo.media(@preço INT, @amostras INT) RETURNS INT AS
BEGIN
	DECLARE @MEDIA INT

	SET @MEDIA = @preço/@amostras

	RETURN @MEDIA
END

/*************************************** CALCULA A MÉDIA DOS PAGAMENTOS REALIZADOS NUM DADO ANO ************************************************************************/
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE_DESC = 'SQL_STORED_PROCEDURE' AND NAME = 'mediaPagamentos')
	DROP PROCEDURE dbo.mediaPagamentos;
GO
CREATE PROCEDURE dbo.mediaPagamentos @n INT AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
	
			DECLARE @valorTotal INT = 0
			DECLARE @num INT = 0
			DECLARE @valorPagamento INT

			DECLARE iterate_estada CURSOR LOCAL SCROLL FOR SELECT preçoTotal FROM Factura
		
			OPEN iterate_estada
			FETCH NEXT FROM iterate_estada INTO @valorPagamento

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @valorTotal = @valorPagamento + @valorTotal
				SET @num = @num + 1

				FETCH RELATIVE @n FROM iterate_estada INTO @valorPagamento
			END

			DECLARE @media INT = dbo.media (@valorTotal, @num)

			PRINT 'Média de pagamentos: ' + CAST(@media as VARCHAR(30))

			CLOSE iterate_estada
			DEALLOCATE iterate_estada
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT !=0
			ROLLBACK;
		THROW
	END CATCH

/*************************************** Teste ************************************************************************/	
GO
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua Manel', 'manel@test.com', 99001122)

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id, preçoBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 1, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 5', 2, 11),
		   ('Glampinho', 'Rua 6', 4, 70),
		   ('Glampinho', 'Rua 7', 5, 22)

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 5', 3),
		   ('Glampinho', 'Rua 6', 3),
		   ('Glampinho', 'Rua 7', 3)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, preçoDia)
	VALUES (3, 1, 10),
		   (3, 2, 15),
		   (1, 3, 20),
		   (2, 3, 20),
		   (4, 3, 20),
		   (5, 3, 20)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (112233445, 3, 'true'),
		   (566778899, 3, 'false'),
		   (123456789, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, ano, NIF, preçoParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3),
		   ('Glampinho', 2, 2017, 112233445, 2),
		   ('Glampinho', 2, 2017, 566778899, 2)
		
SELECT * FROM Item
SELECT descrição FROM ITEM
ORDER BY descrição DESC
OFFSET 10 ROWS

EXEC dbo.mediaPagamentos 5