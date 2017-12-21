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

        public void InscreverHospede(Actividades actividade, Hóspede hóspede)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.inscreverHóspede";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter nifHosp = new SqlParameter("@NIFHóspede", hóspede.NIF);
                SqlParameter numSeq = new SqlParameter("@númeroSequencial", actividade.númeroSequencial);
                SqlParameter nomeParq = new SqlParameter("@nomeParque", actividade.nomeParque);
                SqlParameter year = new SqlParameter("@ano", actividade.ano);

                command.Parameters.Add(nifHosp);
                command.Parameters.Add(numSeq);
                command.Parameters.Add(nomeParq);
                command.Parameters.Add(year);


                command.ExecuteNonQuery();
            }
        }
            public void SendEmails(int intervalo) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) { 
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

        public void ListActividades(DateTime dataInicio, DateTime dataFim) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = "dbo.listarAtividades";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter dtInicio = new SqlParameter("@dataInicio", dataInicio);
                SqlParameter dtFim = new SqlParameter("@dataFim", dataFim);

                command.Parameters.Add(dtInicio);
                command.Parameters.Add(dtFim);
                IDataReader reader = command.ExecuteReader();
                String nome, dataRealização;
                String output = "";
                
                while (reader.Read()) {
                    nome = reader.GetString(0);
                    dataRealização = reader.GetString(1);
                    output += "Nome: " + nome + "|| Data Realização: " + dataRealização+ "\n";
                }

                Console.WriteLine(output);
            }
        }
        
        private void FillParametersEstadaInTime(IDbCommand command, Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extraPessoal, Extra extraAlojamento) {
            SqlParameter NIFResponsável = new SqlParameter("@NIFResponsável", responsável.NIF);
            SqlParameter NIFHóspede = new SqlParameter("@NIFHóspede", hóspede.NIF);
            TimeSpan tempo = estada.dataFim.Subtract(estada.dataInício);
            SqlParameter tempoEstada = new SqlParameter("@tempoEstada", tempo.TotalDays);
            SqlParameter tipoAlojamento = new SqlParameter("@tipoAlojamento", alojamento.tipoAlojamento);
            SqlParameter lotação = new SqlParameter("@lotação", alojamento.númeroMáximoPessoas);
            SqlParameter idExtraPessoal = new SqlParameter("@idExtraPessoal", extraPessoal.id);
            SqlParameter idExtraAlojamento = new SqlParameter("@idExtraAlojamento", extraAlojamento.id);

            command.Parameters.Add(NIFResponsável);
            command.Parameters.Add(NIFHóspede);
            command.Parameters.Add(tempoEstada);
            command.Parameters.Add(tipoAlojamento);
            command.Parameters.Add(lotação);
            command.Parameters.Add(idExtraPessoal);
            command.Parameters.Add(idExtraAlojamento);
        }

        public void createEstadaInTime(Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extraPessoal, Extra extraAlojamento) {
            if (extraAlojamento.associado != "alojamento" || extraPessoal.associado != "pessoa")
                throw new ArgumentException("Extra is not valid");

            EnsureContext();

            using(IDbCommand command = context.createCommand()) {
                command.CommandText = createEstadaCommandText;
                command.CommandType = createEstadaCommandType;
                FillParametersEstadaInTime(command, responsável, hóspede, estada, alojamento, extraPessoal, extraAlojamento);
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
        }

        public void MediaPagamentos(int n) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
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