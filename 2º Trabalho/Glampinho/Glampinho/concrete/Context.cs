using System;
using System.Data.SqlClient;
using Glampinho.dal;

namespace Glampinho.concrete {
    class Context : IContext {
        private string connectionString;
        private SqlConnection connection;

        public Context(String connectionString) {
            this.connectionString = connectionString;
            connection = null;
        }

        public void Open() {
            if (connection == null) {
                connection = new SqlConnection(connectionString);
            }
            if (connection.State != System.Data.ConnectionState.Open) {
                connection.Open();
            }
        }

        public SqlCommand createCommand() {
            Open();
            return connection.CreateCommand();
        }

        public void Dispose() {
            if(connection != null) {
                connection.Dispose();
                connection = null;      // para indicar que a connection não está em uso
            }
        }
    }
}