using System;
using Glampinho.model;
using Glampinho.mapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Glampinho.concrete {
    class FaturaMapper : AbstractMapper<Factura, int, List<Factura>>, IFacturaMapper {
        public FaturaMapper(IContext ctx) : base(ctx){ }

        public void finishEstadaWithFactura(Factura factura) {
            EnsureContext();

            using (IDbCommand command = context.createCommand()) {
                command.CommandText = "dbo.finishEstadaWithFactura";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter id = new SqlParameter("@idEstada", factura.id);
                command.Parameters.Add(id);
                command.ExecuteNonQuery();
            }
        }

        protected override string SelectAllCommandText => "SELECT id, ano, nomeHóspede, NIFHóspede, preçoTotal FROM Factura";

        protected override string SelectCommandText => String.Format("{0} WHERE id = @id", SelectAllCommandText);

        protected override void DeleteParameters(IDbCommand command, Factura e) {
            throw new NotImplementedException();
        }

        protected override void InsertParameters(IDbCommand command, Factura e) {
            throw new NotImplementedException();
        }

        protected override Factura Map(IDataRecord record) {
            Factura factura = new Factura();
            factura.id = record.GetInt32(0);
            factura.ano = record.GetInt32(1);
            factura.nomeHóspede = record.GetString(2);
            factura.NIFHóspede = record.GetInt32(3);
            factura.preçoTotal = record.GetInt32(4);

            return factura;
        }

        protected override void SelectParameters(IDbCommand command, int k) {
            throw new NotImplementedException();
        }

        protected override Factura UpdateEntityID(IDbCommand command, Factura e) {
            throw new NotImplementedException();
        }

        protected override void UpdateParameters(IDbCommand command, Factura e) {
            throw new NotImplementedException();
        }

        protected override string UpdateCommandText {
            get {
                throw new NotImplementedException();
            }
        }

        protected override string DeleteCommandText {
            get {
                throw new NotImplementedException();
            }
        }

        protected override string InsertCommandText {
            get {
                throw new NotImplementedException();
            }
        }
        public void CalcularDespesasHospede(IEnumerable<Factura> facturas, int NIF)
        {

            if (facturas.Count() == 0) Console.WriteLine("Cliente não tem despesas a apresentar.");
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