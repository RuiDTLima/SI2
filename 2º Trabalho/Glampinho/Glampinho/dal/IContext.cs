using System;
using System.Data.SqlClient;

namespace Glampinho.dal {
    interface IContext: IDisposable {
        void Open();
        SqlCommand createCommand();
    }
}