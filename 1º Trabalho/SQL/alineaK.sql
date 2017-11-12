USE Glampinho

drop proc sendEmail
GO
CREATE PROC SendEmail @NIF int ,@email nvarchar(30),@text nvarchar(255)
as 
/*
DECLARE @emailTable table (NIF int,email nvarchar(30), Texto text)
INSERT INTO @emailTable VALUES(@NIF,@email ,@text)*/
print 'De: Gerência Glampinho'
print 'Para: '+@email
print 'Cliente com o NIF: '+CAST(@NIF as VARCHAR)
print 'Mensagem: '+@text
print ''


GO
CREATE PROC SendEmails @periodoTemporal int
as

declare  iterate_nifs cursor LOCAL FORWARD_ONLY 
for SELECT DISTINCT Hóspede.NIF,email FROM Hóspede INNER JOIN (
SELECT A.id,hóspede,NIF FROM HóspedeEstada INNER JOIN (
SELECT id From Estada WHERE dataInício<=DATEADD(DAY,@periodoTemporal,'2017-11-15')) AS A  ON A.id=HóspedeEstada.id )AS B ON B.NIF=Hóspede.NIF and hóspede='true'
open iterate_nifs

declare @curNumber int
declare @email nvarchar(30)
FETCH NEXT FROM iterate_nifs 
into @curNumber,@email
while @@FETCH_STATUS = 0
BEGIN
	exec SendEmail @curNumber,@email,'A sua estada no Parque Glampinho está à sua espera! Para mais informações contacte-nos para glampinho@email.com.' 
	FETCH NEXT FROM iterate_nifs 
	into @curNumber,@email
END
close iterate_nifs
deallocate iterate_nifs



exec SendEmails 7






SELECT * FROM Estada
SELECT * FROM Hóspede
SELECT * FROM HóspedeEstada

INSERT INTO Estada
	VALUES	(2,'2017-11-20','2017-11-27'),
			(3,'2017-11-20','2017-11-27'),
			(4,'2017-11-26','2017-11-30')


INSERT INTO HóspedeEstada 
	VALUES	(112233445,2,'true'),
			(566778899,2,'false'),
			(2,3,'true')