using System;

namespace Glampinho.model {
    class Factura {
        public virtual int id { get; set; } // chave primária
        public virtual int ano { get; set; }    // chave primária
        public virtual int preçoTotal { get; set; }
        public virtual String nomeHóspede { get; set; }
        public virtual int NIFHóspede { get; set; }
        public virtual Hóspede hóspede { get; set; }
    }
}