using System;

namespace Glampinho.model {
    class AlojamentoExtra {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual String localização { get; set; } // chave primária
        public virtual int id { get; set; } // chave primária
        public virtual Extra extra { get; set; }
        public virtual Alojamento alojamento { get; set; }
    }
}