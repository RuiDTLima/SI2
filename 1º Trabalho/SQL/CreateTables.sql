/*******************************************************************************
**	Nome               Create Tables
**	
**	Objectivo          The purpose of this script is the creation of tables for the
**					   information system to support academic activities.
**
**	Criado por         Grupo 4 
**	Data de Cria��o    05/11/17
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
	descri��o NVARCHAR(30),
	pre�oDia INT,
	associado VARCHAR(10) NOT NULL CHECK(associado IN('alojamento', 'pessoa'))
)

/*****************************************************************************/
CREATE TABLE H�spede(
	NIF INT NOT NULL PRIMARY KEY,
	nome NVARCHAR(30) NOT NULL,
	morada NVARCHAR(50),
	email NVARCHAR(30),
	n�meroIdentifica��o INT 
)

/*****************************************************************************/
CREATE TABLE Estada(
	id INT PRIMARY KEY,
	dataIn�cio DATETIME,
	dataFim DATETIME,
	CONSTRAINT checkDate CHECK(dataIn�cio < dataFim)
)

/*****************************************************************************/
CREATE TABLE Alojamento(
	nomeParque NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES ParqueCampismo(nome),
	nome NVARCHAR(30),
	localiza��o NVARCHAR(30),
	descri��o NVARCHAR(30),
	pre�oBase INT,
	n�meroM�ximoPessoas tinyInt,
	tipoAlojamento VARCHAR(8) NOT NULL CHECK(tipoAlojamento in('bungalow', 'tenda')),
	CONSTRAINT pk_Alojamento PRIMARY KEY(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE Bungalow(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	tipologia CHAR(2),
	CONSTRAINT pk_Bungalow PRIMARY KEY(nome,nomeParque, localiza��o),
	CONSTRAINT fk_Bungalow FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE Tenda(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	�rea int, 
	CONSTRAINT pk_Tenda PRIMARY KEY(nome,nomeParque, localiza��o),
	CONSTRAINT fk_Tenda FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE Actividades(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES ParqueCampismo(nome),
	n�meroSequencial INT,
	nome NVARCHAR(30),
	descri��o NVARCHAR(30),
	lota��oM�xima INT,
	pre�oParticipante INT,
	dataRealiza��o DATETIME,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, n�meroSequencial)
)

/*****************************************************************************/
CREATE TABLE Factura(
	identificadorEstada INT FOREIGN KEY REFERENCES Estada(id), 
	identificador INT,
	nomeH�spede NVARCHAR(30),
	NIFH�spede INT FOREIGN KEY REFERENCES H�spede(NIF), 
	descri��oAlojamentos NVARCHAR(50),
	extras INT,
	actividades INT, 
	pre�os INT
)

/*****************************************************************************/
CREATE TABLE Paga(
	nomeParque NVARCHAR(30),
	n�meroSequencial INT,
	NIF INT FOREIGN KEY REFERENCES H�spede(NIF),
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, n�meroSequencial)
)

/*****************************************************************************/
CREATE TABLE H�spedeEstada(
	NIF INT FOREIGN KEY REFERENCES H�spede(NIF),
	id INT FOREIGN KEY REFERENCES Estada(id),
	h�spede VARCHAR(5) NOT NULL CHECK(h�spede IN('true', 'false')),
	CONSTRAINT pk_H�spedeEstada PRIMARY KEY(NIF, id)
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
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nome,nomeParque, localiza��o, id)
)

/*****************************************************************************/
CREATE TABLE AlojamentoExtra(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nome,nomeParque, localiza��o, id)
)

