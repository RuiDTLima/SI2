using System;
using System.Collections.Generic;
using Glampinho.mapper;
using Glampinho.model;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete
{
    class ParqueCampismoMapper : AbstracMapper<ParqueCampismo, int, List<ParqueCampismo>>, IParqueCampismoMapper
    {
        public ParqueCampismoMapper(IContext ctx) : base(ctx) { }

        public override ParqueCampismo Delete(ParqueCampismo entity)
        {
            if (entity == null)
                throw new ArgumentException("The ParqueCampismo cannot be null to be deleted");

            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "SELECT DISTINCT NIF FROM HóspedeEstada \n" +
                 "EXCEPT\n" +
                 "SELECT DISTINCT NIF FROM HóspedeEstada JOIN ( SELECT id FROM Estada WHERE Estada.nomeParque<>@nomeParque) AS A on A.id=HóspedeEstada.id";
                command.CommandType = CommandType.Text;
                SqlParameter nomeParq = new SqlParameter("@nomeParque", entity.nome);

                command.Parameters.Add(nomeParq);

                IDataReader reader = command.ExecuteReader();
                List<Hóspede> hospedes = new List<Hóspede>();
                while (reader.Read())
                {
                    Hóspede h = new Hóspede();
                    h.NIF = reader.GetInt32(0);
                    hospedes.Add(h);
                }

                HóspedeMapper hospedeMapper = new HóspedeMapper(context);
                hospedes.ForEach(h => { hospedeMapper.Delete(h); });

                reader.Close();
                command.Parameters.Clear();

                command.CommandText = "DELETE FROM ParqueCampismo WHERE nome=@nome";
                command.CommandType = CommandType.Text;
                SqlParameter nome = new SqlParameter("@nome", entity.nome);

                command.Parameters.Add(nome);

                command.ExecuteNonQuery();

                return entity;
            }
        }

    protected override string SelectAllCommandText => throw new NotImplementedException();

        protected override string SelectCommandText => throw new NotImplementedException();

        protected override string UpdateCommandText => throw new NotImplementedException();

        protected override string DeleteCommandText => throw new NotImplementedException();

        protected override string InsertCommandText => throw new NotImplementedException();

        protected override void DeleteParameters(IDbCommand command, ParqueCampismo e)
        {
            throw new NotImplementedException();
        }

        protected override void InsertParameters(IDbCommand command, ParqueCampismo e)
        {
            throw new NotImplementedException();
        }

        protected override ParqueCampismo Map(IDataRecord record)
        {
            throw new NotImplementedException();
        }

        protected override void SelectParameters(IDbCommand command, int k)
        {
            throw new NotImplementedException();
        }

        protected override ParqueCampismo UpdateEntityID(IDbCommand command, ParqueCampismo e)
        {
            throw new NotImplementedException();
        }

        protected override void UpdateParameters(IDbCommand command, ParqueCampismo e)
        {
            throw new NotImplementedException();
        }
    }
}
