using System;

namespace Glampinho.model {
    class Estada {
        public virtual int id { get; set; } // chave primária
        public virtual DateTime dataInício { get; set; }
        public virtual DateTime dataFim { get; set; }
        public virtual int idFactura { get; set; }
        public virtual int ano { get; set; }
        public virtual Factura factura { get; set; }
    }
}