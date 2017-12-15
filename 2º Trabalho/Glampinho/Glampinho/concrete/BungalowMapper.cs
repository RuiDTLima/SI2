using Glampinho.mapper;
using Glampinho.model;
using System.Collections.Generic;
using System;
using System.Data;
using System.Data.SqlClient;

namespace Glampinho.concrete {
    /**
     *  In tuple the first element is nomeParque and the second is localização 
     */
    class BungalowMapper : AbstractMapper<Bungalow, Tuple<string, string>, List<Bungalow>>, IBungalowMapper {
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

        public BungalowMapper(IContext ctx) : base(ctx) { }

        protected override string DeleteCommandText {
            get {
                return "dbo.deleteAlojamento";
            }
        }

        protected override string InsertCommandText {
            get {
                return "dbo.InsertAlojamentoBungalow";
            }
        }

        protected override string SelectAllCommandText {
            get {
                return "SELECT Aloj.nomeParque, nome, Aloj.localização, descrição, preçoBase, númeroMáximoPessoas, tipologia FROM dbo.Alojamento AS Aloj JOIN dbo.Bungalow AS Bung ON Aloj.nomeParque = Bung.nomeParque AND Aloj.localização = Bung.localização";
            }
        }

        protected override string SelectCommandText {
            get {
                return "SELECT Aloj.nomeParque, nome, Aloj.localização, descrição, preçoBase, númeroMáximoPessoas, tipologia FROM " +
                       "(SELECT nomeParque, nome, localização, descrição, preçoBase, númeroMáximoPessoas FROM dbo.Alojamento WHERE nomeParque = @nomeParque AND localização = @localização) AS Aloj " +
                       "JOIN(SELECT nomeParque, localização, tipologia FROM dbo.Bungalow WHERE nomeParque = @nomeParque AND localização = @localização) AS Bung ON Aloj.nomeParque = Bung.nomeParque AND Aloj.localização = Bung.localização";
            }
        }

        protected override string UpdateCommandText {
            get {
                return "UPDATE dbo.Alojamento SET preçoBase = @preçoBase, descrição = @descrição, númeroMáximoPessoas = @númeroMáximoPessoas, nome = @nome WHERE nomeParque = @nomeParque AND localização = @localização AND tipoAlojamento='bungalow'\n"+
                        "UPDATE dbo.Bungalow SET tipologia = @tipologia WHERE nomeParque = @nomeParque AND localização = @localização";
            }
        }

        protected override void DeleteParameters(IDbCommand command, Bungalow e) {
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);

            command.Parameters.Add(location);
            command.Parameters.Add(parkName);
        }

        protected override void InsertParameters(IDbCommand command, Bungalow e) {
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);
            SqlParameter name = new SqlParameter("@nome", e.nome);
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter description = new SqlParameter("@descrição", e.descrição);
            SqlParameter basePrice = new SqlParameter("@preçoBase", e.preçoBase);
            SqlParameter maxPeople = new SqlParameter("@númeroMáximoPessoas", e.númeroMáximoPessoas);
            SqlParameter typology = new SqlParameter("@tipologia", e.tipologia);

            command.Parameters.Add(parkName);
            command.Parameters.Add(name);
            command.Parameters.Add(location);
            command.Parameters.Add(description);
            command.Parameters.Add(basePrice);
            command.Parameters.Add(maxPeople);
            command.Parameters.Add(typology);
        }

        protected override void SelectParameters(IDbCommand command, Tuple<string, string> k) {
            SqlParameter parkName = new SqlParameter("@nomeParque", k.Item1);
            SqlParameter location = new SqlParameter("@localização", k.Item2);

            command.Parameters.Add(parkName);
            command.Parameters.Add(location);
        }

        protected override void UpdateParameters(IDbCommand command, Bungalow e) {
            SqlParameter basePrice = new SqlParameter("@preçoBase", e.preçoBase);
            SqlParameter description = new SqlParameter("@descrição", e.descrição);
            SqlParameter maxPeople = new SqlParameter("@númeroMáximoPessoas", e.númeroMáximoPessoas);
            SqlParameter name = new SqlParameter("@nome", e.nome);
            SqlParameter parkName = new SqlParameter("@nomeParque", e.nomeParque);
            SqlParameter location = new SqlParameter("@localização", e.localização);
            SqlParameter typology = new SqlParameter("@tipologia", e.tipologia);

            command.Parameters.Add(basePrice);
            command.Parameters.Add(description);
            command.Parameters.Add(maxPeople);
            command.Parameters.Add(name);
            command.Parameters.Add(parkName);
            command.Parameters.Add(location);
            command.Parameters.Add(typology);
        }

        protected override Bungalow UpdateEntityID(IDbCommand command, Bungalow e) {
            var parkName = command.Parameters["@nomeParque"] as SqlParameter;
            var location = command.Parameters["@localização"] as SqlParameter;
            e.nomeParque = parkName.Value.ToString();
            e.localização = location.Value.ToString();
            return e;
        }

        protected override Bungalow Map(IDataRecord record) {
            Bungalow bungalow = new Bungalow();
            bungalow.nomeParque = record.GetString(0);
            bungalow.nome = record.GetString(1);
            bungalow.localização = record.GetString(2);
            bungalow.descrição = record.GetString(3);
            bungalow.preçoBase = record.GetInt32(4);
            bungalow.númeroMáximoPessoas = record.GetByte(5);
            bungalow.tipologia = record.GetString(6);

            return bungalow;
        }
    }
}