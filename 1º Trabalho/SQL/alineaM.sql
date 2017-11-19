USE Glampinho

	GO
	CREATE FUNCTION	dbo.media (@pre�o INT,@amostras INT)
	RETURNS INT
	AS
	BEGIN
	DECLARE @MEDIA INT

	SET @MEDIA = @pre�o/@amostras

	RETURN @MEDIA
	END

	GO
	CREATE PROC dbo.mediaPagamentos @n INT
	AS
	BEGIN TRANSACTION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRY
		DECLARE @valorTotal INT = 0
		DECLARE @num INT = 0
		DECLARE iterate_estada CURSOR LOCAL SCROLL FOR 
		SELECT pre�oTotal FROM Factura
		
		OPEN iterate_estada
		DECLARE @valorPagamento INT
		
		FETCH NEXT FROM iterate_estada INTO @valorPagamento
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @valorTotal=@valorPagamento+@valorTotal
			SET @num=@num+1
			FETCH RELATIVE @n FROM iterate_estada INTO @valorPagamento
		END
		DECLARE @media INT = dbo.media (@valorTotal,@num)
		PRINT 'M�dia de pagamentos: '+CAST(@media as VARCHAR(30))
		CLOSE iterate_estada
		DEALLOCATE iterate_estada
		COMMIT
	END TRY
	BEGIN CATCH
			ROLLBACK;
		THROW
	END CATCH


	



