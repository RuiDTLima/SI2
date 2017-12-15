using Glampinho.dal;
using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho.concrete
{
   
        class FaturaRepository : IFaturaRepository
        {
            private IContext context;
            public FaturaRepository(IContext ctx)
            {
                context = ctx;
            }

            public IEnumerable<Factura> Find(System.Func<Factura, bool> criteria)
            {
               
                return FindAll().Where(criteria);
            }

            public IEnumerable<Factura> FindAll()
            {
                return new FaturaMapper(context).ReadAll();
            }
        }
    
}
