	use master
	go
	drop database wms
	go

	CREATE DATABASE WMS
	GO
 
	 USE wms
	 GO 
	-- Tabela: DIM_USUARIO
	CREATE TABLE DimUsuario (
		IDUsuario int primary key identity,
		EMAIL NVARCHAR(255) not null,
		NOME NVARCHAR(255) NOT NULL,
		SENHA NVARCHAR(255) NOT NULL,
		DATANASC DATE,
		DATAENTRADA DATE
	);

	-- Tabela: FACT_ADICIONAR
	CREATE TABLE FactAdicionar (
		IDAdicionar BIGINT PRIMARY KEY IDENTITY(1,1),
		IDUsuario int NOT NULL,
		SN BIGINT NOT NULL
	);

	-- Tabela: DIM_PROFESSOR
	CREATE TABLE DimProfessor (
		SN BIGINT PRIMARY KEY,
		NOME NVARCHAR(255) NOT NULL,
		SENHA NVARCHAR(255) NOT NULL
	);



	-- Tabela: DIM_PRODUTO
	CREATE TABLE DimProduto (
		CODIGO BIGINT PRIMARY KEY,
		NOME_BASICO NVARCHAR(255) NOT NULL,
		NOME_MODIFICADOR NVARCHAR(255),
		DESCRICAO_TECNICA NVARCHAR(MAX),
		PRECO_DE_AQUISICAO DECIMAL(10, 2),
		FABRICANTE NVARCHAR(255),
		FORNECEDOR NVARCHAR(255),
		ENDERECAMENTO NVARCHAR(255),
		VALIDADE DATE,
		OBSERVACOES_ADICIONAL NVARCHAR(MAX),
		IMAGEM VARBINARY(MAX),
		UNIDADE NVARCHAR(50),
		PRECO_DE_VENDA DECIMAL(10, 2),
		FRAGILIDADE BIT,
		inserido_por nvarchar(255) not null
	);

	-- Tabela: FACT_CATEGORIA
	CREATE TABLE FactCategoria (
		IDCategoriaProduto BIGINT PRIMARY KEY IDENTITY(1,1),
		CODIGO BIGINT NOT NULL,
		IDCategoria BIGINT NOT NULL
	);

	CREATE TABLE DimCategoria (
		IDCategoria BIGINT PRIMARY KEY IDENTITY(1,1),
		CATEGORIA NVARCHAR(255) NOT NULL
	);

	-- Tabela: RECEBIMENTO
	CREATE TABLE FactRecebimento (
		IDRecebimento BIGINT PRIMARY KEY IDENTITY(1,1),
		DATA_RECEB DATE NOT NULL,
		QUANT BIGINT NOT NULL,
		CODIGO BIGINT NOT NULL
	);

	go 
	CREATE TABLE LoginsAtivos (
		id INT PRIMARY KEY IDENTITY(1,1),
		usuarioEmail NVARCHAR(255) NOT NULL,
		loginTimestamp DATETIME NOT NULL DEFAULT GETDATE(),
		logoutTimestamp DATETIME NULL
	);
	go

	ALTER TABLE FactAdicionar
	ADD CONSTRAINT FK_Adicionar_Usuario FOREIGN KEY (SN)
	REFERENCES DimProfessor(SN);
	go 

	ALTER TABLE FactAdicionar
	ADD CONSTRAINT FK2_Adicionar_Usuario FOREIGN KEY (IDUsuario)
	REFERENCES DimUsuario(IDUsuario);
	go 

	-----PRODUTO E SUA CATEGORIA



	ALTER TABLE FactCategoria
	ADD CONSTRAINT FK_Categoria_Produto  FOREIGN KEY (CODIGO)
	REFERENCES DimProduto(CODIGO);
	go 
	ALTER TABLE FactCategoria
	ADD CONSTRAINT FK2_Categoria_Produto  FOREIGN KEY (IDCategoria)
	REFERENCES DimCategoria(IDCategoria);
	go

	--Recebimento de prod

	ALTER TABLE FactRecebimento
	ADD CONSTRAINT FK_Recebimento_Produto  FOREIGN KEY (CODIGO)
	REFERENCES DimProduto(CODIGO);

	go

	ALTER TABLE DimProduto
	DROP COLUMN VALIDADE;

	go
	-- Ajuste na tabela de recebimento
	ALTER TABLE FactRecebimento
	ADD VALIDADE DATE NOT NULL;

	ALTER TABLE DimProduto
	DROP COLUMN PRECO_DE_AQUISICAO;

	go
	-- Ajuste na tabela de recebimento
	ALTER TABLE FactRecebimento
	ADD PRECO_DE_AQUISICAO DECIMAL(10, 2) not null;
	go

	ALTER TABLE FactRecebimento
	ADD LOTE Nvarchar(30) not null;
	go
	ALTER TABLE DimProfessor
	ADD EMAIL nvarchar(255) not null;
	go
	insert into DimProfessor(SN,NOME,SENHA,EMAIL)
	values(222,'carlos','1234','carlos@professor.com')
	go 

	select * from DimCategoria
	insert into DimCategoria(CATEGORIA)
	values ('escritorio'),
	('armazem')
	go

	-- Ajustando a Tabela dos Produtos
 
	ALTER TABLE DimProduto
	DROP COLUMN ENDERECAMENTO
	GO

	ALTER TABLE DimProduto
	ADD RUA INT, COLUNA INT, ANDAR INT, ALTURA FLOAT, LARGURA FLOAT, PROFUNDIDADE FLOAT, PESO FLOAT
	GO

	-- Trocando a coluna fornecedor de DimProduto para 

	ALTER TABLE DimProduto
	DROP COLUMN FORNECEDOR
	GO

	ALTER TABLE FactRecebimento
	ADD FORNECEDOR VARCHAR(255)
	GO

	--Inserindo dados a tabela DimProduto

	INSERT INTO DimProduto (
    CODIGO, 
    NOME_BASICO, 
    NOME_MODIFICADOR, 
    DESCRICAO_TECNICA, 
    FABRICANTE, 
    OBSERVACOES_ADICIONAL, 
    IMAGEM, 
    UNIDADE, 
    PRECO_DE_VENDA, 
    FRAGILIDADE, 
    inserido_por, 
    RUA, 
    COLUNA, 
    ANDAR, 
    ALTURA, 
    LARGURA, 
    PROFUNDIDADE, 
    PESO
)
VALUES
(1, 'Produto A', 'Modificador X', 'Descri��o T�cnica 1', 'Fabricante 1', 'Observa��o 1', NULL, 'Unidade A', 10.50, 1, 'Usuario1', 1, 1, 1, 10, 20, 15, 10.5),
(2, 'Produto B', 'Modificador Y', 'Descri��o T�cnica 2', 'Fabricante 2', 'Observa��o 2', NULL, 'Unidade B', 20.99, 0, 'Usuario2', 2, 2, 2, 15, 25, 10, 2.4),
(3, 'Produto C', 'Modificador Z', 'Descri��o T�cnica 3', 'Fabricante 3', 'Observa��o 3', NULL, 'Unidade C', 30.00, 1, 'Usuario3', 3, 3, 3, 20, 30, 20, 0.3),
(4, 'Produto D', 'Modificador W', 'Descri��o T�cnica 4', 'Fabricante 4', 'Observa��o 4', NULL, 'Unidade D', 40.50, 1, 'Usuario4', 4, 4, 2, 25, 35, 25, 0.8),
(5, 'Produto E', 'Modificador V', 'Descri��o T�cnica 5', 'Fabricante 5', 'Observa��o 5', NULL, 'Unidade E', 50.99, 0, 'Usuario5', 1, 1, 5, 30, 40, 30, 20);

GO

INSERT INTO FactRecebimento (DATA_RECEB, QUANT, CODIGO, VALIDADE, PRECO_DE_AQUISICAO, LOTE, FORNECEDOR)
VALUES 
(GETDATE(), 20, 1, DATEADD(YEAR, 1, GETDATE()), 5.00, 'Lote001', 'Fornecedor A'),
(GETDATE(), 20, 2, DATEADD(YEAR, 1, GETDATE()), 10.00, 'Lote002', 'Fornecedor B'),
(GETDATE(), 20, 3, DATEADD(YEAR, 1, GETDATE()), 15.00, 'Lote003', 'Fornecedor C'),
(GETDATE(), 20, 4, DATEADD(YEAR, 1, GETDATE()), 20.00, 'Lote004', 'Fornecedor D'),
(GETDATE(), 20, 5, DATEADD(YEAR, 1, GETDATE()), 25.00, 'Lote005', 'Fornecedor E');

-- Verificar a soma das quantidades de cada produto
SELECT 
    dp.NOME_BASICO AS Produto, 
    SUM(fr.QUANT) AS Quantidade
FROM DimProduto dp
JOIN FactRecebimento fr ON dp.CODIGO = fr.CODIGO
GROUP BY dp.NOME_BASICO
ORDER BY dp.NOME_BASICO;
GO

-- VIEW ESTOQUE REAL E INVENTARIO

CREATE VIEW vw_EstoqueReal AS
WITH CTE_RecebimentosAgrupados AS (
    SELECT 
        CODIGO,
        DATA_RECEB,
        SUM(QUANT) AS TOTAL_QUANT -- Soma as quantidades recebidas no mesmo dia
    FROM 
        FactRecebimento
    GROUP BY 
        CODIGO, DATA_RECEB
),
CTE_QuantidadesMaisRecentes AS (
    SELECT 
        CODIGO,
        DATA_RECEB,
        TOTAL_QUANT,
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY DATA_RECEB DESC) AS RowNum
    FROM 
        CTE_RecebimentosAgrupados
)
SELECT 
    dp.CODIGO,
    dp.NOME_BASICO AS NOME_BASICO,
    ISNULL(SUM(fr.QUANT), 0) AS QUANTIDADE, -- Soma total das quantidades do produto
    ISNULL(qmr.TOTAL_QUANT, 0) AS QUANT_RECENTE -- Quantidade mais recente recebida
FROM 
    DimProduto dp
LEFT JOIN 
    FactRecebimento fr ON dp.CODIGO = fr.CODIGO -- Soma total de produtos recebidos
LEFT JOIN 
    CTE_QuantidadesMaisRecentes qmr ON dp.CODIGO = qmr.CODIGO AND qmr.RowNum = 1 -- Quantidade mais recente
GROUP BY 
    dp.CODIGO, dp.NOME_BASICO, qmr.TOTAL_QUANT;

GO

-- TABELA SAIDAS RECEBIMENTO

CREATE TABLE FactSaidas (
        IDRecebimento BIGINT PRIMARY KEY IDENTITY(1,1),
        DATA_SAIDA DATE NOT NULL,
        QUANT BIGINT NOT NULL,
        LOTE Nvarchar(30) not null,
        CODIGO BIGINT NOT NULL,
        FORNECEDOR VARCHAR(255)
����);