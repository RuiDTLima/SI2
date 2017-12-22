using Glampinho.concrete;
using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Glampinho.mapper {
    class ProcUtils {
        private IContext context;

        private string CreateEstadaCommandText {
            get {
                return "dbo.createEstadaInTime";
            }
        }

        private string InscreverHóspedeCommandText {
            get {
                return "dbo.inscreverHóspede";
            }
        }

        private string FinishEstadaWithFacturaCommandText {
            get {
                return "dbo.finishEstadaWithFactura";
            }
        }

        private string SendEmailsCommandText {
            get {
                return "dbo.SendEmails";
            }
        }

        private string ListarActividadesCommandText {
            get {
                return "dbo.listarAtividades";
            }
        }

        private string FindFacturaCommandText {
            get {
                return "SELECT preçoTotal, idFactura FROM dbo.Factura INNER JOIN (\n" +
                        "SELECT idFactura FROM dbo.Estada INNER JOIN(\n" +
                        "SELECT A.id FROM dbo.HóspedeEstada INNER JOIN(\n" +
                        "SELECT Distinct id FROM dbo.ParqueCampismo INNER JOIN dbo.AlojamentoEstada ON dbo.ParqueCampismo.nome = @parqueCampismo) AS A \n" + 
                        "ON dbo.HóspedeEstada.id = A.id and dbo.HóspedeEstada.NIF = @NIF) AS B ON B.id = dbo.Estada.id and dbo.Estada.dataInício BETWEEN @dataInicio and @dataFim) AS C ON dbo.Factura.id = C.idFactura";
            }
        }

        private string DeleteParkFindHóspedesCommandText {
            get {
                return "SELECT DISTINCT NIF FROM dbo.HóspedeEstada \n" +
                        "EXCEPT\n" +
                        "SELECT DISTINCT NIF FROM dbo.HóspedeEstada INNER JOIN ( " + 
                        "SELECT id FROM dbo.AlojamentoEstada WHERE nomeParque <> @nomeParque ) AS A ON A.id = dbo.HóspedeEstada.id";
            }
        }

        private string DeleteParkCommandText {
            get {
                return "DELETE FROM dbo.ParqueCampismo WHERE nome=@nome";
            }
        }

        private CommandType CreateEstadaCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        private CommandType InscreverHóspedeCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        private CommandType FinishEstadaWithFacturaCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        private CommandType SendEmailsCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        private CommandType ListarActividadesCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        private CommandType FindFacturaCommandType {
            get {
                return CommandType.Text;
            }
        }

        private CommandType DeleteParkFindHóspedesCommandType {
            get {
                return CommandType.Text;
            }
        }

        private CommandType DeleteParkCommandType {
            get {
                return CommandType.Text;
            }
        }

        public ProcUtils(IContext ctx) {
            context = ctx;
        }

        protected void EnsureContext() {
            if (context == null)
                throw new InvalidOperationException("Data Context not set.");
        }

        private void FillParametersCreateEstadaInTime(IDbCommand command, Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extraPessoal, Extra extraAlojamento) {
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

        private void FillParametersInscreverHospede(IDbCommand command, Actividades actividade, Hóspede hóspede) {
            SqlParameter nifHosp = new SqlParameter("@NIFHóspede", hóspede.NIF);
            SqlParameter numSeq = new SqlParameter("@númeroSequencial", actividade.númeroSequencial);
            SqlParameter nomeParq = new SqlParameter("@nomeParque", actividade.nomeParque);
            SqlParameter year = new SqlParameter("@ano", actividade.ano);

            command.Parameters.Add(nifHosp);
            command.Parameters.Add(numSeq);
            command.Parameters.Add(nomeParq);
            command.Parameters.Add(year);
        }

        private void FillParametersFinishEstadaWithFactura(IDbCommand command, Estada estada) {
            SqlParameter id = new SqlParameter("@idEstada", estada.id);

            command.Parameters.Add(id);
        }

        private void FillParametersSendEmails(IDbCommand command, int intervalo) {
            SqlParameter periodoTemporal = new SqlParameter("@periodoTemporal", intervalo);

            command.Parameters.Add(periodoTemporal);
        }

        public void FillParametersListarActividades(IDbCommand command, DateTime dataInicio, DateTime dataFim) {
            SqlParameter dtInicio = new SqlParameter("@dataInicio", dataInicio);
            SqlParameter dtFim = new SqlParameter("@dataFim", dataFim);

            command.Parameters.Add(dtInicio);
            command.Parameters.Add(dtFim);
        }

        private void FillParametersFindFactura(IDbCommand command, Hóspede hóspede, DateTime dataInicio, DateTime dataFim, string parqueCampismo) {
            SqlParameter nifHospede = new SqlParameter("@NIF", hóspede.NIF);
            SqlParameter dtInicio = new SqlParameter("@dataInicio", dataInicio);
            SqlParameter dtFim = new SqlParameter("@dataFim", dataFim);
            SqlParameter parqCamp = new SqlParameter("@parqueCampismo", parqueCampismo);

            command.Parameters.Add(nifHospede);
            command.Parameters.Add(dtInicio);
            command.Parameters.Add(dtFim);
            command.Parameters.Add(parqCamp);
        }

        public void createEstadaInTime(Hóspede responsável, Hóspede hóspede, Estada estada, Alojamento alojamento, Extra extraPessoal, Extra extraAlojamento) {
            if (responsável == null || hóspede == null || estada == null || alojamento == null || extraPessoal == null || extraAlojamento == null)
                throw new ArgumentException("Non of the parameters can be null");

            if (extraAlojamento.associado != "alojamento" || extraPessoal.associado != "pessoa")
                throw new ArgumentException("Extra is not valid");

            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = CreateEstadaCommandText;
                command.CommandType = CreateEstadaCommandType;
                FillParametersCreateEstadaInTime(command, responsável, hóspede, estada, alojamento, extraPessoal, extraAlojamento);
                command.ExecuteNonQuery();
                command.Parameters.Clear();
            }
        }

        public void InscreverHospede(Actividades actividade, Hóspede hóspede) {
            if (actividade == null)
                throw new ArgumentException("The actividade cannot be null");
            if (hóspede == null)
                throw new ArgumentException("The hóspede cannot be null");

            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = InscreverHóspedeCommandText;
                command.CommandType = InscreverHóspedeCommandType;

                FillParametersInscreverHospede(command, actividade, hóspede);

                command.ExecuteNonQuery();
            }
        }

        public void finishEstadaWithFactura(Estada estada) {
            if (estada == null)
                throw new ArgumentException("The estada cannot be null");

            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = FinishEstadaWithFacturaCommandText;
                command.CommandType = FinishEstadaWithFacturaCommandType;

                FillParametersFinishEstadaWithFactura(command, estada);

                command.ExecuteNonQuery();
            }
        }

        public List<string> SendEmails(int intervalo) {
            EnsureContext();
            using (IDbCommand command = context.createCommand()) {
                command.CommandText = SendEmailsCommandText;
                command.CommandType = SendEmailsCommandType;

                FillParametersSendEmails(command, intervalo);

                IDataReader reader = command.ExecuteReader();

                List<string> messages = new List<string>();

                while (reader.Read()) {
                    messages.Add(reader.GetString(0));
                }

                return messages;
            }
        }

        public List<string> ListarActividades(DateTime dataInicio, DateTime dataFim) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = ListarActividadesCommandText;
                command.CommandType = ListarActividadesCommandType;

                FillParametersListarActividades(command, dataInicio, dataFim);

                IDataReader reader = command.ExecuteReader();
                String nome, dataRealização, output;

                List<string> actividades = new List<string>();

                while (reader.Read()) {
                    nome = reader.GetString(0);
                    dataRealização = reader.GetString(1);
                    output = "Nome: " + nome + " || Data Realização: " + dataRealização;
                    actividades.Add(output);
                }
                return actividades;
            }
        }

        private Tuple<int, int> CalcularDespesasHospede(IEnumerable<Factura> facturas, int NIF) {
            if (facturas.Count() == 0)
                return null;
            else {
                int total = 0;
                foreach (Factura f in facturas) {
                    total += f.preçoTotal;
                }
                return new Tuple<int, int>(NIF, total);
            }
        }

        public Tuple<int, int> FindFacturas(Hóspede hóspede, DateTime dataInicio, DateTime dataFim, string parqueCampismo) {
            if (hóspede == null)
                throw new ArgumentException("The hóspede cannot be null");

            LinkedList<Factura> facturas = new LinkedList<Factura>();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = FindFacturaCommandText;
                command.CommandType = FindFacturaCommandType;

                FillParametersFindFactura(command, hóspede, dataInicio, dataFim, parqueCampismo);

                IDataReader reader = command.ExecuteReader();

                while (reader.Read()) {
                    Factura f = new Factura();
                    f.id = reader.GetInt32(1);
                    f.preçoTotal = reader.GetInt32(0);
                    facturas.AddLast(f);
                }
            }
            return CalcularDespesasHospede(facturas, hóspede.NIF);
        }

        public void DeletePark(ParqueCampismo park) {
            if (park == null)
                throw new ArgumentException("The ParqueCampismo cannot be null to be deleted");

            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = DeleteParkFindHóspedesCommandText;
                command.CommandType = DeleteParkFindHóspedesCommandType;

                SqlParameter nomeParq = new SqlParameter("@nomeParque", park.nome);

                command.Parameters.Add(nomeParq);

                List<Hóspede> hospedes = new List<Hóspede>();
                IDataReader reader = command.ExecuteReader();

                while (reader.Read()) {
                    Hóspede h = new Hóspede();
                    h.NIF = reader.GetInt32(0);
                    hospedes.Add(h);
                }

                HóspedeMapper hospedeMapper = new HóspedeMapper(context);
                hospedes.ForEach(h => {
                    hospedeMapper.Delete(h);
                });

                reader.Close();
                command.Parameters.Clear();

                command.CommandText = DeleteParkCommandText;
                command.CommandType = DeleteParkCommandType;
                SqlParameter nome = new SqlParameter("@nome", park.nome);

                command.Parameters.Add(nome);

                command.ExecuteNonQuery();
            }
        }
    }
}