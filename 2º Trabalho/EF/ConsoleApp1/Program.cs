using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            using (var db = new Model1())
            {


                var query1 = from b in db.ParqueCampismo
                            select b;
                //var q2 = db.ParqueCampismo.SqlQuery("select * from ParqueCampismo");
               
                foreach (var item in query1)
                {
                    Console.WriteLine(item.nome);
                }

            }
            using (var db = new Model1())
            {


                var parq = new ParqueCampismo
                {
                    nome = "Glampinho"
                };

                   
                var act = new Actividades
                {
                    ano = 2017,
                    númeroSequencial = 3,
                    nome = "Teste",
                    nomeParque = "Glampinho"
                };
                db.Actividades.Add(act);
                db.SaveChanges();



              
                var query = from b in db.Actividades
                            orderby b.ano
                            select b;

               
                foreach (var item in query)
                {
                    Console.WriteLine(item.nome);
                }

                Console.WriteLine("Press any key to exit...");
                Console.ReadKey();
            }
            
        }
    }
}
