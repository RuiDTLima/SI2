/*******************************************************************************
**	Nome               alineaD
**	
**	Objectivo         O objectivo deste script é inserir, remover e actualizar 
**					  informação de um alojamento num parque
**
**	Criado por         Grupo 4 
**	Data de Criação    06/11/17
**
******************************************************************************/
USE Glampinho

SELECT * FROM Alojamento
SELECT * FROM ParqueCampismo

INSERT INTO ParqueCampismo(nome, morada, estrelas, telefones, email)
	VALUES('Parque 1', 'campo dos parques', 3, 964587235, 'parque1@email.com')

INSERT INTO Alojamento(nome, localização, descrição, preçoBase, númeroMáximoPessoas, tipoAlojamento)
	VALUES('Parque 1', 'Lote 1', 'primeira tenda do parque', 60, 12, 'bungalow')

UPDATE Alojamento SET preçoBase = 80 WHERE nome='Parque 1' and localização='Lote 1'

DELETE FROM Alojamento WHERE nome = 'Parque 1' and localização = 'Lote 1'

-- fazer trigger introduzir na tabela bungalow ou tenda conforme o atributo tipoAlojamento, e colocar a funcionar o trigger para deletes e updates relacionados com as tabelas extras
CREATE TRIGGER triggerAlojamento ON DBO.Alojamento AFTER INSERT AS
	INSERT INTO (SELECT tipoAlojamento FROM inserted)