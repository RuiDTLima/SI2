using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho.mapper
{
    class ProcUtils
    {
        private IContext context;

        public ProcUtils(IContext ctx)
        {
            context = ctx;
        }
        protected void EnsureContext()
        {
            if (context == null)
                throw new InvalidOperationException("Data Context not set.");
        }
        public void SendEmails(int intervalo)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
          
                command.CommandText = "dbo.SendEmails";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter param = new SqlParameter("@periodoTemporal", intervalo);
                SqlParameter output = new SqlParameter("@text", SqlDbType.VarChar)

                {
                    Direction = ParameterDirection.Output
                };
                output.Size = 4000;
                command.Parameters.Add(param);
                command.Parameters.Add(output);

                command.ExecuteNonQuery();
                Console.WriteLine((string)output.Value);
                
                
            }
        }
        public void ListActividades(DateTime dataInicio, DateTime dataFim)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.listarAtividades";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter dtInicio = new SqlParameter("@dataInicio", dataInicio);
                SqlParameter dtFim = new SqlParameter("@dataFim", dataFim);

                command.Parameters.Add(dtInicio);
                command.Parameters.Add(dtFim);
                IDataReader reader = command.ExecuteReader();
                String nome, dataRealização;
                String output = "";
                
                while (reader.Read())
                {
                    nome = reader.GetString(0);
                    dataRealização = reader.GetString(1);
                    output += "Nome: " + nome + "|| Data Realização: " + dataRealização+ "\n";
                }
                Console.WriteLine(output);
            }
        }

        public void MediaPagamentos(int n)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.mediaPagamentos";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter interval = new SqlParameter("@n", n);
                SqlParameter output = new SqlParameter("@pagamento", SqlDbType.VarChar)
              
                {
                    Direction = ParameterDirection.Output
                };
                output.Size = 30;

                command.Parameters.Add(interval);
                command.Parameters.Add(output);

                command.ExecuteNonQuery();

                Console.WriteLine((string)output.Value);
            }
        }


    }
}
