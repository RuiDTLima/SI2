using Glampinho.dal;
using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho.concrete
{
   
        class FaturaRepository : IFaturaRepository
        {
            private IContext context;
            public FaturaRepository(IContext ctx)
            {
                context = ctx;
            }

            public IEnumerable<Factura> Find(System.Func<Factura, bool> criteria)
            {
               
                return FindAll().Where(criteria);
            }

            public IEnumerable<Factura> FindAll()
            {
                return new FaturaMapper(context).ReadAll();
            }

        public void CalcularDespesasHospede(IEnumerable<Factura> facturas, int NIF)
        {
           
            if (facturas.Count() == 0 ) Console.WriteLine("Cliente não tem despesas a apresentar.");
            else
            {
                int total = 0;
                foreach (Factura f in facturas)
                {
                    total += f.preçoTotal;
                }
                Console.WriteLine("Despedas totais do hóspede com NIF: " + NIF + " - " + total + " Euros.");

            }
        }

            public IEnumerable<Factura> FindFacturas(int NIF, DateTime dataInicio, DateTime dataFim, string parqueCampismo)
            {
            LinkedList<Factura> facturas = new LinkedList<Factura>();
            using (IDbCommand command = context.createCommand())
                {
                    command.CommandText = "SELECT preçoTotal,idFactura FROM Factura INNER JOIN (\n" +
                    "SELECT idFactura FROM Estada INNER JOIN(\n" +
                    "SELECT A.id FROM HóspedeEstada INNER JOIN(\n" +
                    "SELECT Distinct id FROM ParqueCampismo INNER JOIN AlojamentoEstada ON ParqueCampismo.nome=@parqueCampismo )AS A ON HóspedeEstada.id=A.id and HóspedeEstada.NIF=@NIF ) AS B ON B.id=Estada.id and Estada.dataInício between @dataInicio and @dataFim)AS C ON Factura.id = C.idFactura";
                    command.CommandType = CommandType.Text;
                    SqlParameter nifHospede = new SqlParameter("@NIF", NIF);
                    SqlParameter dtInicio = new SqlParameter("@dataInicio", dataInicio);
                    SqlParameter dtFim = new SqlParameter("@dataFim", dataFim);
                    SqlParameter parqCamp = new SqlParameter("@parqueCampismo", parqueCampismo);

                    command.Parameters.Add(nifHospede);
                    command.Parameters.Add(dtInicio);
                    command.Parameters.Add(dtFim);
                    command.Parameters.Add(parqCamp);

                    IDataReader reader = command.ExecuteReader();
                    
                    while (reader.Read())
                    {
                    Factura f = new Factura();
                    f.id = reader.GetInt32(1);
                    f.preçoTotal = reader.GetInt32(0);
                    facturas.AddLast(f);
                    }
                }
            return facturas;
            }

       


        }
    
}
