using System.Collections.Generic;
using Glampinho.model;

namespace Glampinho.mapper {
    interface IFacturaMapper : IMapper<Factura, int, List<Factura>> {
        void finishEstadaWithFactura(int idEstada);
    }
}