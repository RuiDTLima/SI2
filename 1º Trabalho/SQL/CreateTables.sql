/*******************************************************************************
**	Nome               Create Tables
**	
**	Objectivo          The purpose of this script is the creation of tables for the
**					   information system to support academic activities.
**
**	Criado por         Grupo 4 
**	Data de Criação    05/11/17
**
******************************************************************************/
USE Glampinho

CREATE TABLE ParqueCampismo(
	nome NVARCHAR(30) NOT NULL PRIMARY KEY,
	morada NVARCHAR(50),
	estrelas TINYINT NOT NULL CHECK(estrelas IN(1, 2, 3, 4, 5)),
	telefones INT,
	email NVARCHAR(30)
)

/*****************************************************************************/
CREATE TABLE Extra(
	id INT NOT NULL PRIMARY KEY,
	descrição NVARCHAR(30),
	preçoDia INT,
	associado VARCHAR(10) NOT NULL CHECK(associado IN('alojamento', 'pessoa'))
)

/*****************************************************************************/
CREATE TABLE Hóspede(
	NIF INT NOT NULL PRIMARY KEY,
	nome NVARCHAR(30) NOT NULL,
	morada NVARCHAR(50),
	email NVARCHAR(30),
	númeroIdentificação INT 
)

/*****************************************************************************/
CREATE TABLE Estada(
	id INT PRIMARY KEY,
	dataInício DATETIME,
	dataFim DATETIME,
	CONSTRAINT checkDate CHECK(dataInício < dataFim)
)

/*****************************************************************************/
CREATE TABLE Alojamento(
	nomeParque NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES ParqueCampismo(nome),
	nome NVARCHAR(30),
	localização NVARCHAR(30),
	descrição NVARCHAR(30),
	preçoBase INT,
	númeroMáximoPessoas tinyInt,
	tipoAlojamento VARCHAR(8) NOT NULL CHECK(tipoAlojamento in('bungalow', 'tenda')),
	CONSTRAINT pk_Alojamento PRIMARY KEY(nome,nomeParque, localização)
)

/*****************************************************************************/
CREATE TABLE Bungalow(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	tipologia CHAR(2),
	CONSTRAINT pk_Bungalow PRIMARY KEY(nome,nomeParque, localização),
	CONSTRAINT fk_Bungalow FOREIGN KEY(nome,nomeParque, localização) REFERENCES Alojamento(nome,nomeParque, localização)
)

/*****************************************************************************/
CREATE TABLE Tenda(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	área int, 
	CONSTRAINT pk_Tenda PRIMARY KEY(nome,nomeParque, localização),
	CONSTRAINT fk_Tenda FOREIGN KEY(nome,nomeParque, localização) REFERENCES Alojamento(nome,nomeParque, localização)
)

/*****************************************************************************/
CREATE TABLE Actividades(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES ParqueCampismo(nome),
	númeroSequencial INT,
	nome NVARCHAR(30),
	descrição NVARCHAR(30),
	lotaçãoMáxima INT,
	preçoParticipante INT,
	dataRealização DATETIME,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, númeroSequencial)
)

/*****************************************************************************/
CREATE TABLE Factura(
	identificadorEstada INT FOREIGN KEY REFERENCES Estada(id), 
	identificador INT,
	nomeHóspede NVARCHAR(30),
	NIFHóspede INT FOREIGN KEY REFERENCES Hóspede(NIF), 
	descriçãoAlojamentos NVARCHAR(50),
	extras INT,
	actividades INT, 
	preços INT
)

/*****************************************************************************/
CREATE TABLE Paga(
	nomeParque NVARCHAR(30),
	númeroSequencial INT,
	NIF INT FOREIGN KEY REFERENCES Hóspede(NIF),
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, númeroSequencial)
)

/*****************************************************************************/
CREATE TABLE HóspedeEstada(
	NIF INT FOREIGN KEY REFERENCES Hóspede(NIF),
	id INT FOREIGN KEY REFERENCES Estada(id),
	hóspede VARCHAR(5) NOT NULL CHECK(hóspede IN('true', 'false')),
	CONSTRAINT pk_HóspedeEstada PRIMARY KEY(NIF, id)
)

/*****************************************************************************/
CREATE TABLE EstadaExtra(
	estadaId INT FOREIGN KEY REFERENCES Estada(id),
	extraId INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_EstadaExtra PRIMARY KEY(estadaId, ExtraId)
)

/*****************************************************************************/
CREATE TABLE AlojamentoEstada(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nome,nomeParque, localização, id)
)

/*****************************************************************************/
CREATE TABLE AlojamentoExtra(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nome,nomeParque, localização, id)
)

