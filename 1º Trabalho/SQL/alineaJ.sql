/*******************************************************************************
**	Nome               alineaJ
**	
**	Objectivo          O objectivo deste script é o de proceder ao pagamento 
**						devido por uma estada, emitindo a respectiva factura.
**					   Para isso, deve-se calcular o valor a pagar pelo 
**						alojamento, as actividades e os extras.
**
**	Criado por         Grupo 4 
**	Data de Criação    14/11/17
**
******************************************************************************/
USE Glampinho

/*************************************** Actualizar estada  ************************************************************************/
UPDATE dbo.Estada SET dataFim = GETDATE() WHERE id = 'valor'	--alterar

/*************************************** Retirar preço base  ************************************************************************/
GO
CREATE PROCEDURE dbo.getAlojamentoPreço @idEstada INT, @custo INT OUTPUT AS--output de preço base
	BEGIN TRY
		SELECT @custo = SUM(Aloj.preçoBase) FROM dbo.AlojamentoEstada AS AlojEst JOIN  dbo.Alojamento As Aloj 
			ON AlojEst.localização = Aloj.localização AND AlojEst.nomeParque = Aloj.nomeParque WHERE id = @idEstada
	END TRY
	BEGIN CATCH
		RAISERROR('Erro no calculo do preço do alojamento', 5, 1)
	END CATCH
	
/*************************************** Retirar preço total dos extras de alojamento ************************************************************************/
GO
CREATE PROCEDURE dbo.getEstadaExtrasPreço @idEstada INT, @custo INT OUTPUT AS	-- vai buscar o total a pagar de acordo com os extras para estada
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @custo = SUM(Ext.preçoDia) * @totalDias FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext 
				ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'alojamento'
		COMMiT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro no calculo do preço dos extras de alojamento da estada', 5, 2)
	END CATCH

/*************************************** Retirar preço total dos extras de alojamento ************************************************************************/
GO
CREATE PROCEDURE dbo.getPessoalExtrasPreço @idEstada INT, @custo INT OUTPUT AS  -- vai buscar o total a pagar de acordo com os extras para pessoal
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @totalDias INT
			DECLARE @totalHóspedes INT

			SELECT @totalDias = DATEDIFF(DAY, dataInício, dataFim) FROM dbo.Estada WHERE id = @idEstada

			SELECT @totalHóspedes = COUNT(NIF) FROM dbo.HóspedeEstada WHERE id = @idEstada

			SELECT @custo = SUM(Ext.preçoDia) * @totalDias * @totalHóspedes FROM dbo.EstadaExtra AS EstExt JOIN dbo.Extra Ext 
				ON EstExt.extraId = Ext.id WHERE EstExt.estadaId = @idEstada AND Ext.associado = 'pessoa'
		COMMIT
	END TRY
	BEGIN CATCH
		RAISERROR('Erro no calculo do preço dos extras de pessoal da estada', 5, 3)
	END CATCH

/*************************************** Retirar preço total dos extras de alojamento ************************************************************************/
GO
CREATE PROCEDURE dbo.getCustoTotalActividades @idEstada INT, @custo INT OUTPUT AS	-- vai buscar o custo total das actividades
	BEGIN TRY
		SELECT @custo = SUM(Act.preçoParticipante) FROM dbo.HóspedeEstada AS HosEst JOIN dbo.Paga 
			ON HosEst.NIF = Paga.NIF JOIN dbo.Actividades as Act 
				ON Paga.nomeParque = Act.nomeParque AND Paga.númeroSequencial = Act.númeroSequencial WHERE HosEst.id = @idEstada
	END TRY
	BEGIN CATCH
		RAISERROR('Erro no calculo do preço das actividades realizadas pelos hóspedes', 5, 4)
	END CATCH

/*************************************** Teste ************************************************************************/

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')
	
INSERT INTO dbo.Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344),
	      (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		  (123456789, 'Manel', 'Rua Manel', 'manel@test.com', 99001122)

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T5'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T5'

INSERT INTO dbo.Estada(id, dataInício, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 1', 1),
		   ('Glampinho', 'Rua 2', 1),
		   ('Glampinho', 'Rua 4', 3),
		   ('Glampinho', 'Rua 7', 1)

INSERT INTO dbo.Extra(id, descrição, preçoDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localização, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 4', 3)

INSERT INTO dbo.EstadaExtra(estadaId, extraId)
	VALUES (3, 1),
		   (3, 2),
		   (3, 3)

INSERT INTO dbo.HóspedeEstada(NIF, id, hóspede)
	VALUES (112233445, 3, 'true'),
		   (566778899, 3, 'false'),
		   (123456789, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)
	VALUES ('Glampinho', 1, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '03-15-17 10:30')

INSERT INTO dbo.Paga(nomeParque, númeroSequencial, NIF)
	VALUES ('Glampinho', 1, 112233445),
		   ('Glampinho', 1, 566778899),
		   ('Glampinho', 1, 123456789)

SELECT * FROM dbo.Alojamento
SELECT * FROM dbo.Estada
SELECT * FROM dbo.AlojamentoEstada
SELECT * FROM dbo.Estada
SELECT * FROM dbo.EstadaExtra
SELECT * FROM dbo.HóspedeEstada
SELECT * FROM dbo.Actividades
SELECT * FROM dbo.Paga