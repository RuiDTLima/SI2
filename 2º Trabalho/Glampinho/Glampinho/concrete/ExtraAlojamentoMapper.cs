using System;
using System.Collections.Generic;
using Glampinho.mapper;
using Glampinho.model;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete
{
    class ExtraAlojamentoMapper : AbstracMapper<Extra, int, List<Extra>>, IExtraAlojamentoMapper {
        public ExtraAlojamentoMapper(IContext ctx) : base(ctx) { }
        protected override string InsertCommandText
        {
            get
            {
                return "INSERT INTO Extra(id, descrição, preçoDia, associado) " +
                        "VALUES(@id, @descrição, @preçoDia, 'alojamento')";
            }
        }

        protected override string SelectAllCommandText
        {
            get
            {
                return "SELECT id, descrição, preçoDia, associado FROM Extra";
            }
        }

        protected override string SelectCommandText
        {
            get
            {
                return String.Format("{0} WHERE id = @id", SelectAllCommandText);
            }
        }

        protected override string UpdateCommandText
        {
            get
            {
                return "UPDATE Extra SET descrição=@descrição, preçoDia=@preçoDia WHERE id = @id";
            }
        }
        protected override void DeleteParameters(IDbCommand command, Extra e)
        {
            SqlParameter id = new SqlParameter("@id", e.id);

            command.Parameters.Add(id);
        }

        protected override void InsertParameters(IDbCommand command, Extra e)
        {
            SqlParameter id = new SqlParameter("@id", e.id);
            SqlParameter descrição = new SqlParameter("@descrição", e.descrição);
            SqlParameter preçoDia = new SqlParameter("@preçoDia", e.preçoDia);
            SqlParameter associado = new SqlParameter("@associado", "alojamento");
          

            command.Parameters.Add(id);
            command.Parameters.Add(descrição);
            command.Parameters.Add(preçoDia);
            command.Parameters.Add(associado);
        
        }

        protected override void SelectParameters(IDbCommand command, int k)
        {
            SqlParameter param = new SqlParameter("@id", k);
            command.Parameters.Add(param);
        }

        protected override void UpdateParameters(IDbCommand command, Extra e)
        {
            SqlParameter descrição = new SqlParameter("@descrição", e.descrição);
            SqlParameter preçoDia = new SqlParameter("@preçoDia", e.preçoDia);
            SqlParameter associado = new SqlParameter("@associado", e.associado);

            command.Parameters.Add(descrição);
            command.Parameters.Add(preçoDia);
            command.Parameters.Add(associado);
        }

        protected override Extra UpdateEntityID(IDbCommand command, Extra e)
        {
            var id = command.Parameters["@id"] as SqlParameter;
            e.id = int.Parse(id.Value.ToString());
            return e;
        }

        protected override Extra Map(IDataRecord record)
        {
            Extra extra = new Extra();
            extra.id = record.GetInt32(0);
            extra.descrição = record.GetString(1);
            extra.preçoDia = record.GetInt32(2);
            extra.associado = record.GetString(3);

            return extra;
        }
        protected override string DeleteCommandText
        {
            get
            {
                return "dbo.deleteExtra"; // chamar procedimento armazenado
            }
        }

        public override Extra Delete(Extra entity)
        {
            if (entity == null)
                throw new ArgumentException("The Extra cannot be null to be deleted");

            EnsureContext();

            using (IDbCommand command = context.createCommand())
            {
                command.CommandText = DeleteCommandText;
                command.CommandType = CommandType.StoredProcedure;

                DeleteParameters(command, entity);

                return command.ExecuteNonQuery() == 0 ? null : entity;
            }
        }
    }
}

