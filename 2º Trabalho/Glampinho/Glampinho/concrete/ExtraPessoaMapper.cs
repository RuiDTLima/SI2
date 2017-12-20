using System;
using System.Collections.Generic;
using Glampinho.mapper;
using Glampinho.model;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete {
    class ExtraPessoalMapper : AbstractMapper<Extra, int, List<Extra>>, IExtraPessoalMapper {
        protected override CommandType DeleteCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        public ExtraPessoalMapper(IContext ctx) : base(ctx) { }

        protected override string DeleteCommandText {
            get {
                return "dbo.deleteExtraPessoa"; // chamar procedimento armazenado
            }
        }

        protected override string InsertCommandText {
            get {
                return "INSERT INTO dbo.Extra(id, descrição, preçoDia, associado) " +
                        "VALUES(@id, @descrição, @preçoDia, 'pessoa')";
            }
        }

        protected override string SelectAllCommandText {
            get {
                return "SELECT id, descrição, preçoDia, associado FROM dbo.Extra WHERE associado = 'pessoa'";
            }
        }

        protected override string SelectCommandText {
            get {
                return String.Format("{0} AND id = @id", SelectAllCommandText);
            }
        }

        protected override string UpdateCommandText {
            get {
                return "UPDATE dbo.Extra SET descrição = @descrição, preçoDia = @preçoDia WHERE id = @id";
            }
        }

        protected override void DeleteParameters(IDbCommand command, Extra e) {
            SqlParameter id = new SqlParameter("@id", e.id);
            command.Parameters.Add(id);
        }

        protected override void InsertParameters(IDbCommand command, Extra e) {
            SqlParameter id = new SqlParameter("@id", e.id);
            SqlParameter descrição = new SqlParameter("@descrição", e.descrição);
            SqlParameter preçoDia = new SqlParameter("@preçoDia", e.preçoDia);

            command.Parameters.Add(id);
            command.Parameters.Add(descrição);
            command.Parameters.Add(preçoDia);
        }

        protected override void SelectParameters(IDbCommand command, int k) {
            SqlParameter param = new SqlParameter("@id", k);
            command.Parameters.Add(param);
        }

        protected override void UpdateParameters(IDbCommand command, Extra e) {
            SqlParameter description = new SqlParameter("@descrição", e.descrição);
            SqlParameter priceDay = new SqlParameter("@preçoDia", e.preçoDia);
            SqlParameter id = new SqlParameter("@id", e.id);

            command.Parameters.Add(description);
            command.Parameters.Add(priceDay);
            command.Parameters.Add(id);
        }

        protected override Extra UpdateEntityID(IDbCommand command, Extra e) {
            var id = command.Parameters["@id"] as SqlParameter;
            e.id = int.Parse(id.Value.ToString());
            return e;
        }

        protected override Extra Map(IDataRecord record) {
            Extra extra = new Extra();
            extra.id = record.GetInt32(0);
            extra.descrição = record.GetString(1);
            extra.preçoDia = record.GetInt32(2);
            extra.associado = record.GetString(3);

            return extra;
        }

        public override Extra Create(Extra entity) {
            if (entity.associado != "pessoa")
                throw new ArgumentException("Extra must be of type pessoa");
            return base.Create(entity);
        }

        public override Extra Update(Extra entity) {
            if (entity.associado != "pessoa")
                throw new ArgumentException("Extra must be of type pessoa");
            return base.Update(entity);
        }

        public override Extra Delete(Extra entity) {
            if (entity.associado != "pessoa")
                throw new ArgumentException("Extra must be of type pessoa");
            return base.Delete(entity);
        }
    }
}