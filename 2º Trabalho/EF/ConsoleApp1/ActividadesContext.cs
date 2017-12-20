using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class ActividadesContext : DbContext
    {
        public DbSet<Actividades> Actividades { get; set; }
        public ActividadesContext(): base("name=Model1")
        { }
    }
    }

