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
            using (var db = new ParqueCampismoContext())
            {


                var query1 = from b in db.Parques
                            select b;
                var q2 = db.Parques.SqlQuery("select * from ParqueCampismo");
               
                foreach (var item in q2)
                {
                    Console.WriteLine(item.nome);
                }

            }
            using (var db = new ActividadesContext())
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
