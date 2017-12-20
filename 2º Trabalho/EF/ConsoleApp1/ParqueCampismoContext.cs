using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class ParqueCampismoContext : DbContext
    {
        public DbSet<ParqueCampismo> Parques { get; set; }
        public ParqueCampismoContext(): base("name=Model1")
        {}
       
    }
}
