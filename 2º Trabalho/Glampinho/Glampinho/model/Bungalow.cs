using System;

namespace Glampinho.model {
    class Bungalow {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual String localização { get; set; } // chave primária
        public virtual String tipologia { get; set; }   // 'T0' || 'T1' || 'T2' || 'T3'
        public virtual Alojamento alojamento { get; set; }
    }
}