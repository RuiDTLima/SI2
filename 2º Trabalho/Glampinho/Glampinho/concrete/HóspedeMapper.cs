using System;
using System.Collections.Generic;
using Glampinho.mapper;
using Glampinho.model;
using Glampinho.dal;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;

namespace Glampinho.concrete {
    class HóspedeMapper : AbstracMapper<Hóspede, int, List<Hóspede>>, IHóspedeMapper {
        public HóspedeMapper(IContext ctx) : base(ctx) { }

        protected override string DeleteCommandText {
            get {
                return "dbo.deleteHospede"; // chamar procedimento armazenado
            }
        }

        protected override string InsertCommandText {
            get {
                return "INSERT INTO Hóspede(NIF, nome, morada, email, númeroIdentificação) " +
                        "VALUES(@NIF, @nome, @morada, @email, @númeroIdentificação)";
            }
        }

        protected override string SelectAllCommandText {
            get {
                return "SELECT NIF, nome, morada, email, númeroIdentificação FROM Hóspede";
            }
        }

        protected override string SelectCommandText {
            get {
                return String.Format("{0} WHERE NIF = @NIF", SelectAllCommandText);
            }
        }

        protected override string UpdateCommandText {
            get {
                return "UPDATE Hóspede SET morada = @morada, email = @email WHERE NIF = @NIF";
            }
        }

        protected override void DeleteParameters(IDbCommand command, Hóspede e) {
            SqlParameter nif = new SqlParameter("@NIFHospede", e.NIF);

            command.Parameters.Add(nif);
        }

        protected override void InsertParameters(IDbCommand command, Hóspede e) {
            SqlParameter nif = new SqlParameter("@NIF", e.NIF);
            SqlParameter name = new SqlParameter("@nome", e.nome);
            SqlParameter address = new SqlParameter("@morada", e.morada);
            SqlParameter email = new SqlParameter("@email", e.email);
            SqlParameter ID = new SqlParameter("@númeroIdentificação", e.númeroIdentificação);

            command.Parameters.Add(nif);
            command.Parameters.Add(name);
            command.Parameters.Add(address);
            command.Parameters.Add(email);
            command.Parameters.Add(ID);
        }

        protected override void SelectParameters(IDbCommand command, int k) {
            SqlParameter param = new SqlParameter("@NIF", k);
            command.Parameters.Add(param);
        }

        protected override void UpdateParameters(IDbCommand command, Hóspede e) {
            SqlParameter address = new SqlParameter("@morada", e.morada);
            SqlParameter email = new SqlParameter("@email", e.email);
            SqlParameter nif = new SqlParameter("@NIF", e.NIF);

            command.Parameters.Add(address);
            command.Parameters.Add(email);
            command.Parameters.Add(nif);
        }

        protected override Hóspede UpdateEntityID(IDbCommand command, Hóspede e) {
            var nif = command.Parameters["@NIF"] as SqlParameter;
            e.NIF = int.Parse(nif.Value.ToString());
            return e;
        }

        protected override Hóspede Map(IDataRecord record) {
            Hóspede hóspede = new Hóspede();
            hóspede.NIF = record.GetInt32(0);
            hóspede.nome = record.GetString(1);
            hóspede.morada = record.GetString(2);
            hóspede.email = record.GetString(3);
            hóspede.númeroIdentificação = record.GetInt32(4);

            return hóspede;
        }

        public override Hóspede Delete(Hóspede entity) {
            if (entity == null)
                throw new ArgumentException("The Hóspede cannot be null to be deleted");

            EnsureContext();

            using(IDbCommand command = context.createCommand()) {
                command.CommandText = DeleteCommandText;
                command.CommandType = CommandType.StoredProcedure;

                DeleteParameters(command, entity);
                
                return command.ExecuteNonQuery() == 0 ? null : entity;
            }
        }
    }
}