using Glampinho.model;
using System;
using Glampinho.mapper;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete
{
    class FaturaMapper : AbstracMapper<Factura, int, List<Factura>>, IFacturaMapper
    {
        public FaturaMapper(IContext ctx) : base(ctx){}
       
        public void finishEstadaWithFactura(Factura factura)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.finishEstadaWithFactura";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter id = new SqlParameter("@idEstada", factura.id);
                command.Parameters.Add(id);
                command.ExecuteNonQuery();
            }
        }
        protected override string SelectAllCommandText => "SELECT id, ano, nomeHóspede, NIFHóspede, preçoTotal FROM Factura";

        protected override string SelectCommandText => String.Format("{0} WHERE id = @id", SelectAllCommandText);



        protected override void DeleteParameters(IDbCommand command, Factura e)
        {
            throw new NotImplementedException();
        }

        protected override void InsertParameters(IDbCommand command, Factura e)
        {
            throw new NotImplementedException();
        }

        protected override Factura Map(IDataRecord record)
        {
            Factura factura = new Factura();
            factura.id = record.GetInt32(0);
            factura.ano = record.GetInt32(1);
            factura.nomeHóspede = record.GetString(2);
            factura.NIFHóspede = record.GetInt32(3);
            factura.preçoTotal = record.GetInt32(4);

            return factura;

        }

        protected override void SelectParameters(IDbCommand command, int k)
        {
            throw new NotImplementedException();
        }

        protected override Factura UpdateEntityID(IDbCommand command, Factura e)
        {
            throw new NotImplementedException();
        }

        protected override void UpdateParameters(IDbCommand command, Factura e)
        {
            throw new NotImplementedException();
        }
        protected override string UpdateCommandText => throw new NotImplementedException();

        protected override string DeleteCommandText => throw new NotImplementedException();

        protected override string InsertCommandText => throw new NotImplementedException();

    }
}
