/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script � inserir, remover e actualizar 
**					  informa��o de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Cria��o    06/11/17
**
******************************************************************************/
USE Glampinho

SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo

INSERT INTO ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Glampinho', 'campo dos parques', 3, 964587235, 'parque1@email.com')


/******** INSERT ***********************************************************/

INSERT INTO Alojamento(nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
	VALUES('Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'bungalow')

/******** UPDATE ***********************************************************/

UPDATE Alojamento SET pre�oBase = 80 WHERE nome='Parque 1' and localiza��o='Lote 1'

/******** DELETE ***********************************************************/

GO
CREATE PROC dbo.deleteAlojamento @nome nvarchar(30), @localiza��o nvarchar(30), @nomeParque nvarchar(30)
as
DELETE FROM AlojamentoEstada WHERE nome=@nome and localiza��o=@localiza��o and nomeParque=@nomeParque
DELETE FROM AlojamentoExtra WHERE nome=@nome and localiza��o=@localiza��o and nomeParque=@nomeParque
DELETE FROM Alojamento WHERE nome=@nome and localiza��o=@localiza��o and nomeParque=@nomeParque

/******** Teste ********************************************/

INSERT INTO Extra(id, descri��o, pre�oDia, associado)
	VALUES(1,'descricao',12,'pessoa')
INSERT INTO Alojamento(nomeParque,nome, localiza��o, descri��o, pre�oBase, n�meroM�ximoPessoas, tipoAlojamento)
	VALUES('Glampinho','verde','12EA1','bonito',12,4,'tenda')
INSERT INTO AlojamentoEstada(nome,nomeParque, localiza��o, id)
	VALUES('verde','Glampinho','12EA1',1)
INSERT INTO AlojamentoExtra(nome,nomeParque, localiza��o, id)
	VALUES('verde','Glampinho','12EA1',1)

exec dbo.deleteAlojamento 'verde','12EA1','Glampinho'


/*
-- fazer trigger introduzir na tabela bungalow ou tenda conforme o atributo tipoAlojamento, e colocar a funcionar o trigger para deletes e updates relacionados com as tabelas extras
CREATE TRIGGER triggerAlojamento ON DBO.Alojamento AFTER INSERT AS
	INSERT INTO (SELECT tipoAlojamento FROM inserted)

*/