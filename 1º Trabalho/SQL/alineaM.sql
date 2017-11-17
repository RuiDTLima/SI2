USE Glampinho



	GO
	CREATE PROC dbo.mediaPagamentos AS
	BEGIN TRANSACTION
		BEGIN TRY
		DECLARE @valorPagamento NVARCHAR(30)
		DECLARE iterate_estada SCROLL CURSOR FOR 
		
		SELECT  FROM Factura
		
			
		OPEN iterate_estada
		FETCH NEXT FROM iterate_estada INTO @descrição
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT(@descrição)
			FETCH RELATIVE 10 FROM iterate_estada INTO @descrição
		END
		CLOSE iterate_estada
		DEALLOCATE iterate_estada
			
					
		
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW
	END CATCH	 




		

		SELECT * FROM Item
		SELECT descrição FROM ITEM
		ORDER BY descrição DESC
		OFFSET 10 ROWS
		



