using System;
using System.Collections.Generic;
using Glampinho.mapper;
using Glampinho.model;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete
{
    class EstadaMapper : AbstractMapper<Estada, int, List<Estada>>, IEstadaMapper
    {
        public EstadaMapper(IContext ctx) : base(ctx) { }

        protected override string UpdateCommandText
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        protected override string DeleteCommandText
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        protected override string InsertCommandText
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        protected override void SelectParameters(IDbCommand command, int k)
        {
            SqlParameter param = new SqlParameter("@id", k);
            command.Parameters.Add(param);
        }

        protected override Estada Map(IDataRecord record)
        {
            Estada estada = new Estada();

            estada.id = record.GetInt32(0);
            estada.dataInício = record.GetDateTime(1);
            estada.dataFim = record.GetDateTime(2);
            estada.idFactura = record.GetInt32(3);
            estada.ano = record.GetInt32(4);

            return estada;
        }

        protected override Estada UpdateEntityID(IDbCommand command, Estada e)
        {
            throw new NotImplementedException();
        }

        protected override void UpdateParameters(IDbCommand command, Estada e)
        {
            throw new NotImplementedException();
        }

        protected override void DeleteParameters(IDbCommand command, Estada e)
        {
            throw new NotImplementedException();
        }

        protected override void InsertParameters(IDbCommand command, Estada e)
        {
            throw new NotImplementedException();
        }

        /************************************************ metodos para os procs *****************************************************/

        public int CreateEstada(Hóspede hóspede, int duração)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.createEstada";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter nif = new SqlParameter("@NIFResponsável", hóspede.NIF);
                SqlParameter tempoEstada = new SqlParameter("@tempoEstada", duração);
                SqlParameter returnParameter = new SqlParameter("@idNumber", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                command.Parameters.Add(nif);
                command.Parameters.Add(tempoEstada);
                command.Parameters.Add(returnParameter);

                command.ExecuteNonQuery();

                return (int)returnParameter.Value;
            }
        }

        public void AddAlojamento(Alojamento alojamento, int id)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.addAlojamento";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter tipoAlojamento = new SqlParameter("@tipoAlojamento", alojamento.tipoAlojamento);
                SqlParameter lot = new SqlParameter("@lotação", alojamento.númeroMáximoPessoas);
                SqlParameter iden = new SqlParameter("@idEstada", id);

                command.Parameters.Add(tipoAlojamento);
                command.Parameters.Add(lot);
                command.Parameters.Add(iden);

                command.ExecuteNonQuery();
            }
        }

        public void AddHospede(Hóspede hóspede, int id)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.addHóspede";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter nifHosp = new SqlParameter("@NIF", hóspede.NIF);
                SqlParameter iden = new SqlParameter("@id", id);
                
                command.Parameters.Add(nifHosp);
                command.Parameters.Add(iden);

                command.ExecuteNonQuery();
            }
        }

        public void AddExtraAlojamento(Extra extra, int id)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.addExtraToAlojamento";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter idExtr = new SqlParameter("@idExtra", extra.id);
                SqlParameter iden = new SqlParameter("@idEstada", id);

                command.Parameters.Add(idExtr);
                command.Parameters.Add(iden);

                command.ExecuteNonQuery();
            }
        }

        public void AddExtraEstada(Extra extra, int id)
        {
            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = "dbo.addExtraToEstada";
                command.CommandType = CommandType.StoredProcedure;
                SqlParameter idExtr = new SqlParameter("@idExtra", extra.id);
                SqlParameter iden = new SqlParameter("@idEstada", id);
                
                command.Parameters.Add(idExtr);
                command.Parameters.Add(iden);
                
                command.ExecuteNonQuery();
            }
        }

        protected override string SelectAllCommandText
        {
            get
            {
                return "SELECT NIF, nome, morada, email, númeroIdentificação FROM dbo.Estada";
            }
        }

        protected override string SelectCommandText
        {
            get
            {
                return String.Format("{0} WHERE NIF = @NIF", SelectAllCommandText);
            }
        }
    }
}