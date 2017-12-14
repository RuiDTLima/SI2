using System;
using System.Transactions;
using System.Data.SqlClient;

namespace Glampinho
{
    interface IContext : IDisposable
    {
        void Open();
        SqlCommand createCommand();
        //SqlCommand createProcedure(String s);
        void EnlistTransaction();


    }
}
