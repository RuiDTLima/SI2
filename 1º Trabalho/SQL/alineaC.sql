/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script é o de inserir, remover e actualizar
**					   informação de um hóspede
**
**	Criado por         Grupo 4 
**	Data de Criação    05/11/17
**
******************************************************************************/
USE Glampinho

INSERT INTO Hóspede(NIF, nome, morada, email, númeroIdentificação)
	VALUES (112233445, 'José', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

DELETE FROM Hóspede WHERE NIF = 112233445

UPDATE Hóspede SET morada = 'Rua Teste' WHERE NIF = 112233445

SELECT * FROM Hóspede 