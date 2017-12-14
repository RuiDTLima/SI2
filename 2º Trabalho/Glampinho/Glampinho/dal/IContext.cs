using System;
using System.Data.SqlClient;

namespace Glampinho {
    interface IContext : IDisposable {
        void Open();
        SqlCommand createCommand();
        void EnlistTransaction();
    }
}