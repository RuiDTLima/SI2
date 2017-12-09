using System;

namespace Glampinho.model {
    class Item {
        public virtual int idFactura { get; set; }  //chave primária
        public virtual int ano { get; set; }    // chave primária
        public virtual int linha { get; set; }  // chave primária
        public virtual int quantidade { get; set; }
        public virtual int preço { get; set; }
        public virtual String descrição { get; set; }
        public virtual String tipo { get; set; }    // 'actividade' || 'alojamento' || 'extra'
        public virtual Factura factura { get; set; }
    }
}