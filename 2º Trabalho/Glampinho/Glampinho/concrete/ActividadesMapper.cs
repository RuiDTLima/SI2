using System;
using System.Collections.Generic;
using Glampinho.model;
using Glampinho.mapper;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete {
    /**
     * In Tuple first element is nomeParque, second element is númeroSequencial and third is ano
     */
    class ActividadesMapper : AbstractMapper<Actividades, Tuple<String, int, int>, List<Actividades>>, IAtividadesMapper {
        protected override CommandType DeleteCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        public ActividadesMapper(IContext ctx) : base(ctx) { }

        protected override string DeleteCommandText => "dbo.deleteAtividades";

        protected override string InsertCommandText => "INSERT INTO dbo.Actividades(nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização)" +
                                                "VALUES(@nomeParque, @númeroSequencial, @ano, @nome, @descrição, @lotaçãoMáxima, @preçoParticipante, @dataRealização)";

        protected override string SelectAllCommandText => "SELECT nomeParque, númeroSequencial, ano, nome, descrição, lotaçãoMáxima, preçoParticipante, dataRealização FROM dbo.Actividades";

        protected override string SelectCommandText => String.Format("{0} WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano", SelectAllCommandText);

        protected override string UpdateCommandText => "UPDATE dbo.Actividades SET nomeParque = @nomeParque, númeroSequencial = @númeroSequencial, ano = @ano, nome = @nome, descrição = @descrição, lotaçãoMáxima = @lotaçãoMáxima, preçoParticipante = @preçoParticipante, dataRealização = @dataRealização WHERE nomeParque = @nomeParque AND númeroSequencial = @númeroSequencial AND ano = @ano";

        protected override void DeleteParameters(IDbCommand cmd, Actividades entity) {
            SqlParameter p1 = new SqlParameter("@nomeParque", entity.nomeParque);
            SqlParameter p2 = new SqlParameter("@númeroSequencial", entity.númeroSequencial);
            SqlParameter p3 = new SqlParameter("@ano", entity.ano);

            cmd.Parameters.Add(p1);
            cmd.Parameters.Add(p2);
            cmd.Parameters.Add(p3);
        }

        protected override void InsertParameters(IDbCommand cmd, Actividades entity) {
            UpdateParameters(cmd, entity);
        }

        protected override void SelectParameters(IDbCommand cmd, Tuple<String, int, int> k) {
            SqlParameter parkName = new SqlParameter("@nomeParque", k.Item1);
            SqlParameter sequencialNumber = new SqlParameter("@númeroSequencial", k.Item2);
            SqlParameter year = new SqlParameter("@ano", k.Item3);

            cmd.Parameters.Add(parkName);
            cmd.Parameters.Add(sequencialNumber);
            cmd.Parameters.Add(year);
        }

        protected override void UpdateParameters(IDbCommand cmd, Actividades entity) {
            SqlParameter p = new SqlParameter("@nomeParque", entity.nomeParque);
            SqlParameter p1 = new SqlParameter("@númeroSequencial", entity.númeroSequencial);
            SqlParameter p2 = new SqlParameter("@ano", entity.ano);
            SqlParameter p3 = new SqlParameter("@nome", entity.nome);
            SqlParameter p4 = new SqlParameter("@descrição", entity.descrição);
            SqlParameter p5 = new SqlParameter("@lotaçãoMáxima", entity.lotaçãoMáxima);
            SqlParameter p6 = new SqlParameter("@preçoParticipante", entity.preçoParticipante);
            SqlParameter p7 = new SqlParameter("@dataRealização", entity.dataRealização);

            cmd.Parameters.Add(p);
            cmd.Parameters.Add(p1);
            cmd.Parameters.Add(p2);
            cmd.Parameters.Add(p3);
            cmd.Parameters.Add(p4);
            cmd.Parameters.Add(p5);
            cmd.Parameters.Add(p6);
            cmd.Parameters.Add(p7);
        }

        protected override Actividades UpdateEntityID(IDbCommand cmd, Actividades e) {
            var param1 = cmd.Parameters["@nomeParque"] as SqlParameter;
            var param2 = cmd.Parameters["@númeroSequencial"] as SqlParameter;
            var param3 = cmd.Parameters["@ano"] as SqlParameter;

            e.nomeParque = param1.Value.ToString();
            e.númeroSequencial = int.Parse(param2.Value.ToString());
            e.ano = int.Parse(param3.Value.ToString());

            return e;
        }

        protected override Actividades Map(IDataRecord record) {
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
    }
}