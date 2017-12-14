/*
*
*   ISEL-ADEETC-SI2
*   ND 2014-2017
*
*   Material didático para apoio 
*   à unidade curricular de 
*   Sistemas de Informação II
*
*   O código pode não ser completo.
**/
using System;
using System.Transactions;
using System.Data;
using System.Data.SqlClient;
using Glampinho.concrete;

namespace Glampinho.concrete
{

    class Context : IContext
    {
        private string connectionString;
        private SqlConnection con = null;




        public Context(string cs)
        {
            connectionString = cs;
        }

        public void Open()
        {
            if (con == null)
            {
                con = new SqlConnection(connectionString);

            }
            if (con.State != ConnectionState.Open)
                con.Open();
        }

        public SqlCommand createCommand()
        {
            Open();
            SqlCommand cmd = con.CreateCommand();
            return cmd;
        }
        public SqlCommand createProcedure(String s)
        {
            Open();
            SqlCommand cmd = new SqlCommand(s,con);

            // 2. set the command object so it knows to execute a stored procedure
            cmd.CommandType = CommandType.StoredProcedure;
            return cmd;
        }

        public void Dispose()
        {
            if (con != null)
            {
                con.Dispose();
                con = null;
            }

        }

        public void EnlistTransaction()
        {
            if (con != null)
            {
                con.EnlistTransaction(Transaction.Current);
            }
        }
    }
}
