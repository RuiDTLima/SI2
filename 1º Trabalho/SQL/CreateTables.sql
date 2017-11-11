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

CREATE TABLE dbo.ParqueCampismo(
	nome NVARCHAR(30) NOT NULL PRIMARY KEY,
	morada NVARCHAR(50),
	estrelas TINYINT NOT NULL CHECK(estrelas IN(1, 2, 3, 4, 5)),
	telefones INT,
	email NVARCHAR(30)
)

/*****************************************************************************/
CREATE TABLE dbo.Extra(
	id INT NOT NULL PRIMARY KEY,
	descri��o NVARCHAR(30),
	pre�oDia INT,
	associado VARCHAR(10) NOT NULL CHECK(associado IN('alojamento', 'pessoa'))
)

/*****************************************************************************/
CREATE TABLE dbo.H�spede(
	NIF INT NOT NULL PRIMARY KEY,
	nome NVARCHAR(30) NOT NULL,
	morada NVARCHAR(50),
	email NVARCHAR(30),
	n�meroIdentifica��o INT 
)

/*****************************************************************************/
CREATE TABLE dbo.Estada(
	id INT PRIMARY KEY,
	dataIn�cio DATETIME,
	dataFim DATETIME,
	CONSTRAINT checkDate CHECK(dataIn�cio < dataFim)
)

/*****************************************************************************/
CREATE TABLE dbo.Alojamento(
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
CREATE TABLE dbo.Bungalow(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	tipologia CHAR(2),
	CONSTRAINT pk_Bungalow PRIMARY KEY(nome,nomeParque, localiza��o),
	CONSTRAINT fk_Bungalow FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE dbo.Tenda(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	�rea int, 
	CONSTRAINT pk_Tenda PRIMARY KEY(nome,nomeParque, localiza��o),
	CONSTRAINT fk_Tenda FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE dbo.Actividades(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	n�meroSequencial NVARCHAR(30),
	nome NVARCHAR(30),
	descri��o NVARCHAR(30),
	lota��oM�xima INT,
	pre�oParticipante INT,
	dataRealiza��o DATETIME,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, n�meroSequencial)
)

/*****************************************************************************/
CREATE TABLE dbo.Factura(
	identificadorEstada INT FOREIGN KEY REFERENCES dbo.Estada(id), 
	identificador INT,
	nomeH�spede NVARCHAR(30),
	NIFH�spede INT FOREIGN KEY REFERENCES dbo.H�spede(NIF), 
	descri��oAlojamentos NVARCHAR(50),
	extras INT,
	actividades INT, 
	pre�os INT,
	CONSTRAINT pk_Factura PRIMARY KEY(identificadorEstada, identificador)
)

/*****************************************************************************/
CREATE TABLE dbo.Paga(
	nomeParque NVARCHAR(30),
	n�meroSequencial INT,
	NIF INT FOREIGN KEY REFERENCES dbo.H�spede(NIF),
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, n�meroSequencial, NIF)
)

/*****************************************************************************/
CREATE TABLE dbo.H�spedeEstada(
	NIF INT FOREIGN KEY REFERENCES dbo.H�spede(NIF),
	id INT FOREIGN KEY REFERENCES dbo.Estada(id),
	h�spede VARCHAR(5) NOT NULL CHECK(h�spede IN('true', 'false')),
	CONSTRAINT pk_H�spedeEstada PRIMARY KEY(NIF, id)
)

/*****************************************************************************/
CREATE TABLE dbo.EstadaExtra(
	estadaId INT FOREIGN KEY REFERENCES dbo.Estada(id),
	extraId INT FOREIGN KEY REFERENCES dbo.Extra(id),
	CONSTRAINT pk_EstadaExtra PRIMARY KEY(estadaId, ExtraId)
)

/*****************************************************************************/

CREATE TABLE AlojamentoEstada(
	nome NVARCHAR(30),
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nome,nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoEstada FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoExtra(
	nome NVARCHAR(30), 
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nome,nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoExtra FOREIGN KEY(nome,nomeParque, localiza��o) REFERENCES Alojamento(nome,nomeParque, localiza��o)
)