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
CREATE TABLE dbo.Factura(
	id INT,
	ano INT, 
	nomeHóspede NVARCHAR(30),
	NIFHóspede INT,
	preçoTotal INT,
	CONSTRAINT pk_Factura PRIMARY KEY(id, ano)
)

/*****************************************************************************/
CREATE TABLE dbo.Estada(
	id INT PRIMARY KEY,
	dataInício DATETIME2 NOT NULL,
	dataFim DATETIME2 NOT NULL,
	idFactura INT,
	ano INT,
	CONSTRAINT fk_estada FOREIGN KEY(idFactura, ano) REFERENCES Factura(id, ano)ON DELETE CASCADE,
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
	tipologia CHAR(2) NOT NULL CHECK(tipologia in('T0', 'T1', 'T2', 'T3')),
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
	ano INT,
	nome NVARCHAR(30),
	descrição NVARCHAR(30),
	lotaçãoMáxima INT,
	preçoParticipante INT,
	dataRealização DATETIME2,
	CONSTRAINT pk_Actividades PRIMARY KEY(nomeParque, númeroSequencial, ano)
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
	preço INT NOT NULL,
	descrição NVARCHAR(30) NOT NULL,
	tipo VARCHAR(10) NOT NULL CHECK(tipo in('actividade', 'alojamento', 'extra'))
	CONSTRAINT pk_Item PRIMARY KEY(idFactura, ano, linha),
	CONSTRAINT fk_item FOREIGN KEY(idFactura, ano) REFERENCES dbo.Factura(id, ano)
)

/*****************************************************************************/
CREATE TABLE dbo.Paga(
	nomeParque NVARCHAR(30),
	númeroSequencial INT,
	ano INT,
	NIF INT FOREIGN KEY REFERENCES dbo.Hóspede(NIF) ON DELETE CASCADE,
	preçoParticipante INT,
	CONSTRAINT pk_Paga PRIMARY KEY(nomeParque, númeroSequencial, ano, NIF),
	CONSTRAINT fk_Paga FOREIGN KEY(nomeParque, númeroSequencial, ano) REFERENCES dbo.Actividades(nomeParque, númeroSequencial, ano)ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.HóspedeEstada(
	NIF INT FOREIGN KEY REFERENCES dbo.Hóspede(NIF) ON DELETE CASCADE,
	id INT FOREIGN KEY REFERENCES dbo.Estada(id) ON DELETE CASCADE,
	hóspede VARCHAR(5) NOT NULL CHECK(hóspede IN('true', 'false')),
	CONSTRAINT pk_HóspedeEstada PRIMARY KEY(NIF, id)
)

/*****************************************************************************/
CREATE TABLE dbo.EstadaExtra(
	estadaId INT FOREIGN KEY REFERENCES dbo.Estada(id) ON DELETE CASCADE,
	extraId INT FOREIGN KEY REFERENCES dbo.Extra(id) ON DELETE CASCADE,
	preçoDia INT,
	CONSTRAINT pk_EstadaExtra PRIMARY KEY(estadaId, ExtraId)
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoEstada(
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Estada(id),
	preçoBase INT,
	CONSTRAINT pk_AlojamentoEstada PRIMARY KEY(nomeParque, localização, id),
	CONSTRAINT fk_AlojamentoEstada FOREIGN KEY(nomeParque, localização) REFERENCES Alojamento(nomeParque, localização)ON DELETE CASCADE
)

/*****************************************************************************/
CREATE TABLE dbo.AlojamentoExtra(
	nomeParque NVARCHAR(30),
	localização NVARCHAR(30),
	id INT FOREIGN KEY REFERENCES Extra(id),
	CONSTRAINT pk_AlojamentoExtra PRIMARY KEY(nomeParque, localização, id),
	CONSTRAINT fk_AlojamentoExtra FOREIGN KEY(nomeParque, localização) REFERENCES Alojamento(nomeParque, localização)ON DELETE CASCADE
)