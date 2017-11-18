use Glampinho

EXEC testeAlineaC
EXEC testeAlineaD_INSERT
EXEC testeAlineaD_DELETE
EXEC testeAlineaI
EXEC testeAlineaJ
EXEC testeAlineaK 
EXEC testeAlineaL
EXEC testeAlineaM

/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaC 
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (1, 'Teste1', 'Rua 1', 'jose@gmail.com', 11223344),
	       (2, 'Teste2', 'Rua 2', 'maria@gmail.com', 55667788)

EXEC dbo.InsertAlojamentoTenda	  'Glampinho', 'tenda vazia','Rua 4', 'vazia',15, 10, 50		  

INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (1, 1, 'false'),
		   (2, 1, 'true' )

SELECT * FROM H�spede
SELECT * FROM H�spedeEstada

EXEC dbo.deleteHospede 1
EXEC dbo.deleteHospede 2

SELECT * FROM H�spede
SELECT * FROM H�spedeEstada

EXEC deleteALL
/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaD_DELETE
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
	       (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788),
		   (123456789, 'Manel', 'Rua 3', 'manel@gmail.com', 99112233),
		   (123243546, 'Ant�nio', 'Rua 4', 'antonio@gmail.com', 44556677)

EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', 'Lote 2', 'bonito', 12, 4, 50

INSERT INTO	dbo.Estada(id, dataIn�cio, dataFim, idFactura, ano)
	VALUES (1, '2017-11-09 13:00:00', '2017-11-11 13:00:00', null, null),
		   (2, '2017-11-17 10:00:00', '2017-11-18 13:00:00', null, null)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 1, 'false'),
		   (566778899, 1, 'true' ),
		   (123456789, 2, 'true' ),
		   (123243546, 2, 'false'),
		   (112233445, 2, 'false')

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 12, 'pessoa')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Lote 1', 1, 60),
		   ('Glampinho', 'Lote 2', 2, 12) 

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Lote 1', 1)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (1, 1, 12),
		   (2, 1, 12)

SELECT * FROM Alojamento
SELECT * FROM Tenda
SELECT * FROM Bungalow

EXEC dbo.deleteAlojamento 'Lote 1','Glampinho'
EXEC dbo.deleteAlojamento 'Lote 2','Glampinho'

SELECT * FROM Alojamento
SELECT * FROM Tenda
SELECT * FROM Bungalow
EXEC deleteALL

GO
CREATE PROC testeAlineaD_INSERT
AS
SET NOCOUNT ON

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'T3'
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'verde', 'Lote 2', 'bonito', 12, 4, 50

SELECT * FROM Alojamento
SELECT * FROM Tenda
SELECT * FROM Bungalow

EXEC deleteALL

/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaI 
AS
SET NOCOUNT ON

INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (1, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)
	       
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-10-15 13:00:00', '2018-03-16 13:00:00')
		

INSERT INTO AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12)
		
INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (1, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00')

SELECT * FROM Paga
EXEC dbo.inscreverH�spede 1, 1,'Glampinho', 2017
SELECT * FROM Paga

EXEC deleteAll
		
/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaJ
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')
	
INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES(112233445, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)
	      

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00')
		 

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12)
		  
INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')

INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 1', 1),
		   ('Glampinho', 'Rua 1', 2),
		   ('Glampinho', 'Rua 1', 3)

INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (1, 1, 10),
		   (1, 2, 15),
		   (1, 3, 20)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 1, 'true')
		   

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00')
		   
INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3)


SELECT* FROM Factura

EXEC dbo.finishEstadaWithFactura 1

SELECT* FROM Factura

EXEC deleteALL
		  

/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaK
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES	(2, '2017-11-20', '2017-11-27'),
			(3, '2017-11-20', '2017-11-27')
			

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (1, 'Teste1', 'Rua teste', 'teste@teste.com', 11223344),
		   (2, 'Teste2', 'Rua teste', 'teste@teste.com', 11223344),
		   (3, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344)

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES	(1, 2, 'true'),
			(2, 2, 'false'),
			(3, 3, 'true')

EXEC dbo.sendEmails 7

EXEC deleteALL

/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaL
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
	VALUES ('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (1, 'Teste', 'Rua teste', 'teste@teste.com', 11223344)	       
	
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-10-15 13:00:00', '2018-03-16 13:00:00')
		

INSERT INTO AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12)
		
INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (1, 1, 'true')

INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-11-15 10:30:00')

INSERT INTO Paga(ano,NIF,nomeParque,n�meroSequencial,pre�oParticipante)
	VALUES (2017,1,'Glampinho',1,3)

EXEC listarAtividades '2017-11-15' ,'2017-11-16' 

EXEC deleteALL
/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC testeAlineaM
AS
SET NOCOUNT ON
INSERT INTO dbo.ParqueCampismo(nome, morada, estrelas, email)
VALUES('Glampinho', 'campo dos parques', 3, 'parque1@email.com')

EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda pequena', 'Rua 1', 'bonito', 12, 4, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda grande', 'Rua 2', 'grande', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda tempo', 'Rua 3', 'tempo', 15, 11, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda vazia', 'Rua 4', 'vazia', 15, 10, 50
EXEC dbo.InsertAlojamentoTenda 'Glampinho', 'tenda nova', 'Rua 5', 'por estrear', 15, 10, 50
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow hoje', 'Rua 6', 'primeiro bungalow', 15, 10, 'T3'
EXEC dbo.InsertAlojamentoBungalow 'Glampinho', 'Bungalow ontem', 'Rua 7', 'segundo bungalow', 15, 9, 'T3'

INSERT INTO dbo.Estada(id, dataIn�cio, dataFim)
	VALUES (1, '2017-03-15 13:00:00', '2017-03-16 13:00:00'),
		   (2, '2017-11-12 13:00:00', '2018-11-14 13:00:00'),
		   (3, '2017-10-05 10:00:00', '2017-11-12 13:00:00'),
		   (4, '2017-09-12 10:00:00', '2017-09-13 13:00:00'),
		   (5, '2017-08-10 10:00:00', '2017-09-11 10:00:00')

INSERT INTO dbo.AlojamentoEstada(nomeParque, localiza��o, id, pre�oBase)
	VALUES ('Glampinho', 'Rua 1', 1, 12),
		   ('Glampinho', 'Rua 2', 1, 15),
		   ('Glampinho', 'Rua 4', 3, 15),
		   ('Glampinho', 'Rua 5', 2, 11),
		   ('Glampinho', 'Rua 6', 4, 70),
		   ('Glampinho', 'Rua 7', 5, 22)

INSERT INTO dbo.Extra(id, descri��o, pre�oDia, associado)
	VALUES (1, 'descricao', 10, 'alojamento'), 
		   (2, 'teste', 15, 'pessoa'), 
		   (3, 'metodo', 20, 'alojamento')
		  


INSERT INTO dbo.AlojamentoExtra(nomeParque, localiza��o, id)
	VALUES ('Glampinho', 'Rua 4', 1),
		   ('Glampinho', 'Rua 4', 2),
		   ('Glampinho', 'Rua 5', 3),
		   ('Glampinho', 'Rua 6', 3),
		   ('Glampinho', 'Rua 7', 3)


INSERT INTO dbo.EstadaExtra(estadaId, extraId, pre�oDia)
	VALUES (3, 1, 10),
		   (3, 2, 15),
		   (1, 3, 20),
		   (2, 3, 20),
		   (4, 3, 12),
		   (5, 3, 34)

INSERT INTO dbo.H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES  (4, 'Teste1', 'Rua teste', 'teste@teste.com', 11223344),
		    (2, 'Teste2', 'Rua teste', 'teste@teste.com', 11223344),
		    (3, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),
		    (123456789, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),	
		    (566778899, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344),	
			(112233445, 'Teste3', 'Rua teste', 'teste@teste.com', 11223344)			

INSERT INTO dbo.H�spedeEstada(NIF, id, h�spede)
	VALUES (112233445, 3, 'true'),
		   (566778899, 3, 'false'),
		   (123456789, 1, 'true'),
		   (2, 2, 'true'),
		   (3, 4, 'true'),
		   (4, 5, 'true')


INSERT INTO dbo.Actividades(nomeParque, n�meroSequencial, ano, nome, descri��o, lota��oM�xima, pre�oParticipante, dataRealiza��o)
	VALUES ('Glampinho', 1, 2017, 'FUT7', 'Jogo de futebol 7vs7', '14', 3, '2017-03-15 10:30:00'),
		   ('Glampinho', 2, 2017, 'FUT5', 'Jogo de futebol 5vs5', '10', 2, '2017-10-07 10:00:00')

INSERT INTO dbo.Paga(nomeParque, n�meroSequencial, ano, NIF, pre�oParticipante)
	VALUES ('Glampinho', 1, 2017, 112233445, 3),
		   ('Glampinho', 1, 2017, 566778899, 3),
		   ('Glampinho', 1, 2017, 123456789, 3),
		   ('Glampinho', 2, 2017, 112233445, 2),
		   ('Glampinho', 2, 2017, 566778899, 2),
		   ('Glampinho', 2, 2017, 4, 2),
		   ('Glampinho', 2, 2017, 3, 2),
		   ('Glampinho', 2, 2017, 2, 2)

EXEC dbo.finishEstadaWithFactura 1
EXEC dbo.finishEstadaWithFactura 2
EXEC dbo.finishEstadaWithFactura 3
EXEC dbo.finishEstadaWithFactura 4
EXEC dbo.finishEstadaWithFactura 5

SELECT pre�oTotal FROM Factura

EXEC dbo.mediaPagamentos 2

EXEC deleteALL
/** ------------------------------------------------------------------------------------------ **/
/** ------------------------------------------------------------------------------------------ **/
GO
CREATE PROC dbo.deleteAll
AS
DELETE FROM dbo.Tenda
DELETE FROM dbo.Bungalow
DELETE FROM dbo.Paga
DELETE FROM dbo.Actividades
DELETE FROM dbo.AlojamentoExtra
DELETE FROM dbo.Telefones
DELETE FROM dbo.Item
DELETE FROM dbo.EstadaExtra
DELETE FROM dbo.Extra
DELETE FROM dbo.H�spedeEstada
DELETE FROM dbo.AlojamentoEstada
DELETE FROM dbo.Estada 
DELETE FROM dbo.Factura
DELETE FROM dbo.H�spede
DELETE FROM dbo.Alojamento
DELETE FROM dbo.ParqueCampismo









