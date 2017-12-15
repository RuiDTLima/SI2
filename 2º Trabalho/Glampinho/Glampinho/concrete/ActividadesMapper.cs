using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Glampinho.model;
using Glampinho.mapper;
using System.Transactions;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete
{
    class ActividadesMapper : AbstracMapper<Actividades, int?, List<Actividades>>, IAtividadesMapper
    {
        public ActividadesMapper(Context ctx) : base(ctx) { }

        public override Actividades Create(Actividades entity)
        {
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();

                using (IDbCommand cmd = context.createCommand())
                {
                    cmd.CommandText = InsertCommandText;
                    cmd.CommandType = InsertCommandType;
                    InsertParameters(cmd, entity);
                    cmd.ExecuteNonQuery();
                    entity = UpdateEntityID(cmd, entity);
                }
                if (entity != null)
                {
                    SqlParameter p = new SqlParameter("@nomeParque", entity.nomeParque);
                    SqlParameter p1 = new SqlParameter("@numeroSequencial", entity.númeroSequencial);
                    SqlParameter p2 = new SqlParameter("@ano", entity.ano);
                    SqlParameter p3 = new SqlParameter("@nome", entity.nome);
                    SqlParameter p4 = new SqlParameter("@descrição", entity.descrição);
                    SqlParameter p5 = new SqlParameter("@lotaçãoMáxima", entity.lotaçãoMáxima);
                    SqlParameter p6 = new SqlParameter("@preçoParticipante", entity.preçoParticipante);
                    SqlParameter p7 = new SqlParameter("@dataRealização", entity.dataRealização);
                    SqlParameter p8 = new SqlParameter("@parque", entity.parque);


                    List<IDataParameter> parameters = new List<IDataParameter>();

                    parameters.Add(p);
                    parameters.Add(p1);
                    parameters.Add(p2);
                    parameters.Add(p3);
                    parameters.Add(p4);
                    parameters.Add(p5);
                    parameters.Add(p6);
                    parameters.Add(p7);
                    parameters.Add(p8);


                    ExecuteNonQuery("INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização) VALUES(@nomeParque, @númeroSequencial, @nome, @descrição, @lotaçãoMáxima, @preçoParticipante, @dataRealização)", parameters);

                }
                ts.Complete();
            }

            return entity;
        }


        public override Actividades Delete(Actividades entity)
        {
            if (entity == null)
                throw new ArgumentException("The " + typeof(Actividades) + " to delete cannot be null");

            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                using (IDbCommand command = context.createCommand())
                {
                    command.CommandText = DeleteCommandText;
                    command.CommandType = CommandType.StoredProcedure;

                    DeleteParameters(command, entity);

                    return command.ExecuteNonQuery() == 0 ? null : entity;
                }

            }
        }


        protected override string InsertCommandText => "insert into dbo.Actividades(nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização) values(@nomeParque, @númeroSequencial, @nome, @descrição, @lotaçãoMáxima, @preçoParticipante, @dataRealização); select @id=studentNumber from STUDENT;";

        protected override string SelectAllCommandText => "select nomeParque, númeroSequencial, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização from dbo.Actividades";

        protected override string SelectCommandText => String.Format("{0} where nomeParque=@nomeParque, númeroSequencial=@númeroSequencial, ano=@ano", SelectAllCommandText);

        protected override string UpdateCommandText => "update Actividades set nomeParque=@nomeParque, númeroSequencial=@númeroSequencial, nome=@nome, descrição=@descrição, lotaçãoMáxima=@lotaçãoMáxima, preçoParticipante=@preçoParticipante, dataRealização=@dataRealização where where nomeParque=@nomeParque, númeroSequencial=@númeroSequencial, ano=@ano";

        protected override string DeleteCommandText => "dbo.deleteAtividades";

        protected override void DeleteParameters(IDbCommand cmd, Actividades entity)
        {
            SqlParameter p1 = new SqlParameter("@nomeParque", entity.nomeParque);
            SqlParameter p2 = new SqlParameter("@númeroSequencial", entity.númeroSequencial);
            SqlParameter p3 = new SqlParameter("@ano", entity.ano);
            cmd.Parameters.Add(p1);
            cmd.Parameters.Add(p2);
            cmd.Parameters.Add(p3);
        }

        protected override void InsertParameters(IDbCommand cmd, Actividades entity)
        {
            UpdateParameters(cmd, entity);
        }

        protected override Actividades Map(IDataRecord record)
        {
            Actividades s = new Actividades();
            s.nomeParque = record.GetString(0);
            s.númeroSequencial = record.GetInt32(1);
            s.ano = record.GetInt32(2);
            s.nome = record.GetString(3);
            s.descrição = record.GetString(4);
            s.lotaçãoMáxima = record.GetInt32(5);
            s.preçoParticipante = record.GetInt32(6);
            s.dataRealização = record.GetDateTime(7);
            return s;
        }

        protected override void SelectParameters(IDbCommand cmd, int? id)
        {
            SqlParameter p = new SqlParameter("@id", id);
            cmd.Parameters.Add(p);
        }

        protected override Actividades UpdateEntityID(IDbCommand cmd, Actividades e)
        {
            var param1 = cmd.Parameters["@nomeParuqe"] as SqlParameter;
            var param2 = cmd.Parameters["@númeroSequencial"] as SqlParameter;
            var param3 = cmd.Parameters["@ano"] as SqlParameter;
            e.nomeParque = param1.Value.ToString();
            e.númeroSequencial = int.Parse(param2.Value.ToString());
            e.ano = int.Parse(param3.Value.ToString());
            return e;
        }

        protected override void UpdateParameters(IDbCommand cmd, Actividades entity)
        {
            SqlParameter p = new SqlParameter("@nomeParque", entity.nomeParque);
            SqlParameter p1 = new SqlParameter("@numeroSequencial", entity.númeroSequencial);
            SqlParameter p2 = new SqlParameter("@ano", entity.ano);
            SqlParameter p3 = new SqlParameter("@nome", entity.nome);
            SqlParameter p4 = new SqlParameter("@descrição", entity.descrição);
            SqlParameter p5 = new SqlParameter("@lotaçãoMáxima", entity.lotaçãoMáxima);
            SqlParameter p6 = new SqlParameter("@preçoParticipante", entity.preçoParticipante);
            SqlParameter p7 = new SqlParameter("@dataRealização", entity.dataRealização);
            SqlParameter p8 = new SqlParameter("@parque", entity.parque);

            cmd.Parameters.Add(p1);
            cmd.Parameters.Add(p2);
            cmd.Parameters.Add(p3);
            cmd.Parameters.Add(p4);
            cmd.Parameters.Add(p5);
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
    }
}
