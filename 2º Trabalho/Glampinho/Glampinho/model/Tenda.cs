using System;

namespace Glampinho.model {
    class Tenda {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual String localização { get; set; } // chave primária
        public virtual int área { get; set; }
        public virtual Alojamento alojamento { get; set; }
    }
}