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
	nomeParque NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	nome NVARCHAR(30) NOT NULL UNIQUE,
	localiza��o NVARCHAR(30),
	descri��o NVARCHAR(30),
	pre�oBase INT,
	n�meroM�ximoPessoas TINYINT,
	tipoAlojamento VARCHAR(8) NOT NULL CHECK(tipoAlojamento in('bungalow', 'tenda')),
	CONSTRAINT pk_Alojamento PRIMARY KEY(nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE dbo.Bungalow(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	tipologia CHAR(2),
	CONSTRAINT pk_Bungalow PRIMARY KEY(nomeParque, localiza��o),
	CONSTRAINT fk_Bungalow FOREIGN KEY(nomeParque, localiza��o) REFERENCES dbo.Alojamento(nomeParque, localiza��o) ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.Tenda(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	�rea INT, 
	CONSTRAINT pk_Tenda PRIMARY KEY(nomeParque, localiza��o),
	CONSTRAINT fk_Tenda FOREIGN KEY(nomeParque, localiza��o) REFERENCES dbo.Alojamento(nomeParque, localiza��o) ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.Actividades(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	n�meroSequencial INT,
	nome NVARCHAR(30),
	descri��o NVARCHAR(30),
	lota��oM�xima INT,
	pre�oParticipante INT,
	dataRealiza��o DATETIME,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, n�meroSequencial)
)

/*****************************************************************************/
CREATE TABLE dbo.Factura(
	idEstada INT FOREIGN KEY REFERENCES dbo.Estada(id), 
	id INT,
	nomeH�spede NVARCHAR(30),
	NIFH�spede INT FOREIGN KEY REFERENCES dbo.H�spede(NIF),
	CONSTRAINT pk_Factura PRIMARY KEY(idEstada, id)
)

/*****************************************************************************/
CREATE TABLE dbo.Telefones(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	telefone INT,
	CONSTRAINT pk_Telefones PRIMARY KEY(nomeParque, telefone)
)

/*****************************************************************************/
CREATE TABLE dbo.Item(
	idEstada INT,
	idFactura INT,
	linha INT,
	quantidade INT NOT NULL,
	pre�o INT NOT NULL,
	descri��o NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_Item PRIMARY KEY(idEstada, idFactura, linha),
	CONSTRAINT fk_item FOREIGN KEY(idEstada, idFactura) REFERENCES dbo.Factura(idEstada, id)
)

/*****************************************************************************/
CREATE TABLE dbo.Paga(
	nomeParque NVARCHAR(30),
	n�meroSequencial INT,
	NIF INT FOREIGN KEY REFERENCES dbo.H�spede(NIF),
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, n�meroSequencial, NIF),
	CONSTRAINT fk_Paga FOREIGN KEY(nomeParque, n�meroSequencial) REFERENCES dbo.Actividades(nomeParque, n�meroSequencial)
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
CREATE TABLE dbo.AlojamentoEstada(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoEstada FOREIGN KEY(nomeParque, localiza��o) REFERENCES Alojamento(nomeParque, localiza��o)
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoExtra(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoExtra FOREIGN KEY(nomeParque, localiza��o) REFERENCES Alojamento(nomeParque, localiza��o)
)