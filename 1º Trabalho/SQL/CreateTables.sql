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

CREATE TABLE dbo.ParqueCampismo(
	nome NVARCHAR(30) NOT NULL PRIMARY KEY,
	morada NVARCHAR(50),
	estrelas TINYINT NOT NULL CHECK(estrelas IN(1, 2, 3, 4, 5)),
	email NVARCHAR(30)
)

/*****************************************************************************/
CREATE TABLE dbo.Extra(
	id INT NOT NULL PRIMARY KEY,
	descrição NVARCHAR(30),
	preçoDia INT,
	associado VARCHAR(10) NOT NULL CHECK(associado IN('alojamento', 'pessoa'))
)

/*****************************************************************************/
CREATE TABLE dbo.Hóspede(
	NIF INT NOT NULL PRIMARY KEY,
	nome NVARCHAR(30) NOT NULL,
	morada NVARCHAR(50),
	email NVARCHAR(30),
	númeroIdentificação INT 
)

/*****************************************************************************/
CREATE TABLE dbo.Estada(
	id INT PRIMARY KEY,
	dataInício DATETIME,
	dataFim DATETIME,
	CONSTRAINT checkDate CHECK(dataInício < dataFim)
)

/*****************************************************************************/
CREATE TABLE dbo.Alojamento(
	nomeParque NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	nome NVARCHAR(30) NOT NULL UNIQUE,
	localização NVARCHAR(30),
	descrição NVARCHAR(30),
	preçoBase INT,
	númeroMáximoPessoas TINYINT,
	tipoAlojamento VARCHAR(8) NOT NULL CHECK(tipoAlojamento in('bungalow', 'tenda')),
	CONSTRAINT pk_Alojamento PRIMARY KEY(nomeParque, localização)
)

/*****************************************************************************/
CREATE TABLE dbo.Bungalow(
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	tipologia CHAR(2),
	CONSTRAINT pk_Bungalow PRIMARY KEY(nomeParque, localização),
	CONSTRAINT fk_Bungalow FOREIGN KEY(nomeParque, localização) REFERENCES dbo.Alojamento(nomeParque, localização) ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.Tenda(
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	área INT, 
	CONSTRAINT pk_Tenda PRIMARY KEY(nomeParque, localização),
	CONSTRAINT fk_Tenda FOREIGN KEY(nomeParque, localização) REFERENCES dbo.Alojamento(nomeParque, localização) ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.Actividades(
	nomeParque NVARCHAR(30) FOREIGN KEY REFERENCES dbo.ParqueCampismo(nome) ON DELETE CASCADE,
	númeroSequencial INT,
	nome NVARCHAR(30),
	descrição NVARCHAR(30),
	lotaçãoMáxima INT,
	preçoParticipante INT,
	dataRealização DATETIME,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, númeroSequencial)
)

/*****************************************************************************/
CREATE TABLE dbo.Factura(
	idEstada INT FOREIGN KEY REFERENCES dbo.Estada(id), 
	id INT,
	nomeHóspede NVARCHAR(30),
	NIFHóspede INT FOREIGN KEY REFERENCES dbo.Hóspede(NIF),
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
	preço INT NOT NULL,
	descrição NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_Item PRIMARY KEY(idEstada, idFactura, linha),
	CONSTRAINT fk_item FOREIGN KEY(idEstada, idFactura) REFERENCES dbo.Factura(idEstada, id)
)

/*****************************************************************************/
CREATE TABLE dbo.Paga(
	nomeParque NVARCHAR(30),
	númeroSequencial INT,
	NIF INT FOREIGN KEY REFERENCES dbo.Hóspede(NIF),
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, númeroSequencial, NIF),
	CONSTRAINT fk_Paga FOREIGN KEY(nomeParque, númeroSequencial) REFERENCES dbo.Actividades(nomeParque, númeroSequencial)
)

/*****************************************************************************/
CREATE TABLE dbo.HóspedeEstada(
	NIF INT FOREIGN KEY REFERENCES dbo.Hóspede(NIF),
	id INT FOREIGN KEY REFERENCES dbo.Estada(id),
	hóspede VARCHAR(5) NOT NULL CHECK(hóspede IN('true', 'false')),
	CONSTRAINT pk_HóspedeEstada PRIMARY KEY(NIF, id)
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
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nomeParque, localização, id),
	CONSTRAINT fk_AlojamentoEstada FOREIGN KEY(nomeParque, localização) REFERENCES Alojamento(nomeParque, localização)
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoExtra(
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nomeParque, localização, id),
	CONSTRAINT fk_AlojamentoExtra FOREIGN KEY(nomeParque, localização) REFERENCES Alojamento(nomeParque, localização)
)