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
CREATE TABLE dbo.Factura(
	id INT,
	ano INT, 
	nomeH�spede NVARCHAR(30),
	NIFH�spede INT,
	pre�oTotal INT,
	CONSTRAINT pk_Factura PRIMARY KEY(id, ano)
)

/*****************************************************************************/
CREATE TABLE dbo.Estada(
	id INT PRIMARY KEY,
	dataIn�cio DATETIME2 NOT NULL,
	dataFim DATETIME2 NOT NULL,
	idFactura INT,
	ano INT,
	CONSTRAINT fk_estada FOREIGN KEY(idFactura, ano) REFERENCES Factura(id, ano)ON DELETE CASCADE,
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
	tipologia CHAR(2) NOT NULL CHECK(tipologia in('T0', 'T1', 'T2', 'T3')),
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
	ano INT,
	nome NVARCHAR(30),
	descri��o NVARCHAR(30),
	lota��oM�xima INT,
	pre�oParticipante INT,
	dataRealiza��o DATETIME2,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, n�meroSequencial, ano)
)

/*****************************************************************************/
CREATE TABLE dbo.Telefones(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	telefone INT,
	CONSTRAINT pk_Telefones PRIMARY KEY(nomeParque, telefone)
)

/*****************************************************************************/
CREATE TABLE dbo.Item(
	idFactura INT,
	ano INT,
	linha INT,
	quantidade INT NOT NULL,
	pre�o INT NOT NULL,
	descri��o NVARCHAR(30) NOT NULL,
	tipo VARCHAR(10) NOT NULL CHECK(tipo in('actividade', 'alojamento', 'extra'))
	CONSTRAINT pk_Item PRIMARY KEY(idFactura, ano, linha),
	CONSTRAINT fk_item FOREIGN KEY(idFactura, ano) REFERENCES dbo.Factura(id, ano)
)

/*****************************************************************************/
CREATE TABLE dbo.Paga(
	nomeParque NVARCHAR(30),
	n�meroSequencial INT,
	ano INT,
	NIF INT FOREIGN KEY REFERENCES dbo.H�spede(NIF) ON DELETE CASCADE,
	pre�oParticipante INT,
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, n�meroSequencial, ano, NIF),
	CONSTRAINT fk_Paga FOREIGN KEY(nomeParque, n�meroSequencial, ano) REFERENCES dbo.Actividades(nomeParque, n�meroSequencial, ano)ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.H�spedeEstada(
	NIF INT FOREIGN KEY REFERENCES dbo.H�spede(NIF) ON DELETE CASCADE,
	id INT FOREIGN KEY REFERENCES dbo.Estada(id) ON DELETE CASCADE,
	h�spede VARCHAR(5) NOT NULL CHECK(h�spede IN('true', 'false')),
	CONSTRAINT pk_H�spedeEstada PRIMARY KEY(NIF, id)
)

/*****************************************************************************/
CREATE TABLE dbo.EstadaExtra(
	estadaId INT FOREIGN KEY REFERENCES dbo.Estada(id) ON DELETE CASCADE,
	extraId INT FOREIGN KEY REFERENCES dbo.Extra(id) ON DELETE CASCADE,
	pre�oDia INT,
	CONSTRAINT pk_EstadaExtra PRIMARY KEY(estadaId, ExtraId)
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoEstada(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	pre�oBase INT,
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoEstada FOREIGN KEY(nomeParque, localiza��o) REFERENCES Alojamento(nomeParque, localiza��o)ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoExtra(
	nomeParque NVARCHAR(30),
	localiza��o NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nomeParque, localiza��o, id),
	CONSTRAINT fk_AlojamentoExtra FOREIGN KEY(nomeParque, localiza��o) REFERENCES Alojamento(nomeParque, localiza��o)ON DELETE CASCADE
)