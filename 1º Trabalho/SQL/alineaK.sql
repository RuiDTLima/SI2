USE Glampinho

drop proc sendEmail
GO
CREATE PROC SendEmail @NIF int ,@email nvarchar(30),@text nvarchar(255)
as 
/*
DECLARE @emailTable table (NIF int,email nvarchar(30), Texto text)
INSERT INTO @emailTable VALUES(@NIF,@email ,@text)*/
print 'De: Ger�ncia Glampinho'
print 'Para: '+@email
print 'Cliente com o NIF: '+CAST(@NIF as VARCHAR)
print 'Mensagem: '+@text
print ''


GO
CREATE PROC SendEmails @periodoTemporal int
as

declare  iterate_nifs cursor LOCAL FORWARD_ONLY 
for SELECT DISTINCT H�spede.NIF,email FROM H�spede INNER JOIN (
SELECT A.id,h�spede,NIF FROM H�spedeEstada INNER JOIN (
SELECT id From Estada WHERE dataIn�cio<=DATEADD(DAY,@periodoTemporal,'2017-11-15')) AS A  ON A.id=H�spedeEstada.id )AS B ON B.NIF=H�spede.NIF and h�spede='true'
open iterate_nifs

declare @curNumber int
declare @email nvarchar(30)
FETCH NEXT FROM iterate_nifs 
into @curNumber,@email
while @@FETCH_STATUS = 0
BEGIN
	exec SendEmail @curNumber,@email,'A sua estada no Parque Glampinho est� � sua espera! Para mais informa��es contacte-nos para glampinho@email.com.' 
	FETCH NEXT FROM iterate_nifs 
	into @curNumber,@email
END
close iterate_nifs
deallocate iterate_nifs



exec SendEmails 7






SELECT * FROM Estada
SELECT * FROM H�spede
SELECT * FROM H�spedeEstada

INSERT INTO Estada
	VALUES	(2,'2017-11-20','2017-11-27'),
			(3,'2017-11-20','2017-11-27'),
			(4,'2017-11-26','2017-11-30')


INSERT INTO H�spedeEstada 
	VALUES	(112233445,2,'true'),
			(566778899,2,'false'),
			(2,3,'true')