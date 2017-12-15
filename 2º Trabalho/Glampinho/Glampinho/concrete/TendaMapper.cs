using Glampinho.mapper;
using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete {
    class TendaMapper : AbstractMapper<Tenda, Tuple<string, string>, List<Tenda>>, ITendaMapper {
        protected override CommandType DeleteCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        protected override CommandType InsertCommandType {
            get {
                return CommandType.StoredProcedure;
            }
        }

        public TendaMapper(IContext ctx) : base(ctx) { }

        protected override string DeleteCommandText {
            get {
                return "dbo.deleteAlojamento";
            }
        }

        protected override string InsertCommandText {
            get {
                return "dbo.InsertAlojamentoTenda";
            }
        }

        protected override string SelectAllCommandText {
            get {
                return "SELECT Aloj.nomeParque, nome, Aloj.localização, descrição, preçoBase, númeroMáximoPessoas, área FROM dbo.Alojamento AS Aloj JOIN dbo.Tenda ON Aloj.nomeParque = Tenda.nomeParque AND Aloj.localização = Tenda.localização";
            }
        }

        protected override string SelectCommandText {
            get {
                return "SELECT Aloj.nomeParque, nome, Aloj.localização, descrição, preçoBase, númeroMáximoPessoas, área FROM " + 
                        "(SELECT nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localização = @localização) AS Aloj" +
                        "JOIN(SELECT nomeParque, localização, área FROM dbo.Tenda WHERE nomeParque = @nomeParque AND localização = @localização) as Tenda ON Aloj.nomeParque = Tenda.nomeParque AND Aloj.localização = Tenda.localização";
            }
        }

        protected override string UpdateCommandText {
            get {
                return "UPDATE dbo.Alojamento SET preçoBase = @preçoBase, descrição = @descrição, númeroMáximoPessoas = @númeroMáximoPessoas, nome = @nome WHERE nomeParque = @nomeParque AND localização = @localização AND tipoAlojamento='tenda'\n" + 
                        "UPDATE dbo.Tenda SET área = @área WHERE nomeParque = @nomeParque and localização = @localização";
            }
        }

        protected override void DeleteParameters(IDbCommand command, Tenda e) {
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);

            command.Parameters.Add(location);
            command.Parameters.Add(parkName);
        }

        protected override void InsertParameters(IDbCommand command, Tenda e) {
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);
            SqlParameter name = new SqlParameter("@nome", e.nome);
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter description = new SqlParameter("@descrição", e.descrição);
            SqlParameter basePrice = new SqlParameter("@preçoBase", e.preçoBase);
            SqlParameter maxPeople = new SqlParameter("@númeroMáximoPessoas", e.númeroMáximoPessoas);
            SqlParameter area = new SqlParameter("@área", e.área);

            command.Parameters.Add(parkName);
            command.Parameters.Add(name);
            command.Parameters.Add(location);
            command.Parameters.Add(description);
            command.Parameters.Add(basePrice);
            command.Parameters.Add(maxPeople);
            command.Parameters.Add(area);
        }

        protected override void SelectParameters(IDbCommand command, Tuple<string, string> k) {
            SqlParameter parkName = new SqlParameter("@nomeParque", k.Item1);
            SqlParameter location = new SqlParameter("@localização", k.Item2);

            command.Parameters.Add(parkName);
            command.Parameters.Add(location);
        }

        protected override void UpdateParameters(IDbCommand command, Tenda e) {
            SqlParameter basePrice = new SqlParameter("@preçoBase", e.preçoBase);
            SqlParameter description = new SqlParameter("@descrição", e.descrição);
            SqlParameter maxPeople = new SqlParameter("@númeroMáximoPessoas", e.númeroMáximoPessoas);
            SqlParameter name = new SqlParameter("@nome", e.nome);
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter area = new SqlParameter("@área", e.área);

            command.Parameters.Add(basePrice);
            command.Parameters.Add(description);
            command.Parameters.Add(maxPeople);
            command.Parameters.Add(name);
            command.Parameters.Add(parkName);
            command.Parameters.Add(location);
            command.Parameters.Add(area);
        }

        protected override Tenda UpdateEntityID(IDbCommand command, Tenda e) {
            var parkName = command.Parameters["@nomeParque"] as SqlParameter;
            var location = command.Parameters["@localização"] as SqlParameter;
            e.nomeParque = parkName.Value.ToString();
            e.localização = location.Value.ToString();
            return e;
        }

        protected override Tenda Map(IDataRecord record) {
            Tenda tenda = new Tenda();
            tenda.nomeParque = record.GetString(0);
            tenda.nome = record.GetString(1);
            tenda.localização = record.GetString(2);
            tenda.descrição = record.GetString(3);
            tenda.preçoBase = record.GetInt32(4);
            tenda.númeroMáximoPessoas = record.GetByte(5);
            tenda.área = record.GetInt32(6);

            return tenda;
        }
    }
}