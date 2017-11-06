/*******************************************************************************
**	Nome               alineaC
**	
**	Objectivo          O objectivo deste script � o de inserir, remover e actualizar
**					   informa��o de um h�spede
**
**	Criado por         Grupo 4 
**	Data de Cria��o    05/11/17
**
******************************************************************************/
USE Glampinho

INSERT INTO H�spede(NIF, nome, morada, email, n�meroIdentifica��o)
	VALUES (112233445, 'Jos�', 'Rua 1', 'jose@gmail.com', 11223344),
		   (566778899, 'Maria', 'Rua 2', 'maria@gmail.com', 55667788)

DELETE FROM H�spede WHERE NIF = 112233445

UPDATE H�spede SET morada = 'Rua Teste' WHERE NIF = 112233445

SELECT * FROM H�spede 