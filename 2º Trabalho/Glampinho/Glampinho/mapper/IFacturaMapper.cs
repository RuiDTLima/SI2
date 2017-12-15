using System;
using System.Collections.Generic;
using Glampinho.model;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho.mapper
{
    interface IFacturaMapper : IMapper<Factura, int, List<Factura>>
    {
        void finishEstadaWithFactura(Factura factura);
    }
}
