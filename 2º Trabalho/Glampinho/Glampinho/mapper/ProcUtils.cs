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
                
                string emailsText;

                command.CommandText = "select dbo.enviarEmails(@periodoTemporal)";
                SqlParameter param = new SqlParameter("@periodoTemporal",intervalo);
                command.Parameters.Add(param);
                emailsText = (string)command.ExecuteScalar();

                Console.WriteLine(emailsText);
            }
        }

    }
}
