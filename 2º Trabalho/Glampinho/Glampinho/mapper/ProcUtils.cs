using Glampinho.model;
using System;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.mapper {
    class ProcUtils {
        private IContext context;

        private string createEstadaCommandText = "dbo.createEstadaInTime";
        private CommandType createEstadaCommandType = CommandType.StoredProcedure;

        public ProcUtils(IContext ctx) {
            context = ctx;
        }

        protected void EnsureContext() {
            if (context == null)
                throw new InvalidOperationException("Data Context not set.");
        }

        public void SendEmails(int intervalo) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                string emailsText;

                command.CommandText = "select dbo.enviarEmails(@periodoTemporal)";
                SqlParameter param = new SqlParameter("@periodoTemporal",intervalo);
                command.Parameters.Add(param);
                emailsText = (string)command.ExecuteScalar();

                Console.WriteLine(emailsText);
            }
        }

        private void FillParameters(IDbCommand command, Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extra) {
            SqlParameter NIFResponsável = new SqlParameter("@NIFResponsável", responsável.NIF);
            SqlParameter NIFHóspede = new SqlParameter("@NIFHóspede", hóspede.NIF);
            TimeSpan tempo = estada.dataFim.Subtract(estada.dataInício);
            SqlParameter tempoEstada = new SqlParameter("@tempoEstada", tempo)
        }

        public void createEstadaInTime(Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extra) {
            EnsureContext();

            using(IDbCommand command = context.createCommand()) {
                command.CommandText = createEstadaCommandText;
                command.CommandType = createEstadaCommandType;


            }
        }
    }
}