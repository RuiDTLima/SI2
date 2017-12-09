using System;

namespace Glampinho.model {
    class AlojamentoEstada {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual String localização { get; set; } // chave primária
        public virtual int id { get; set; }     // chave primária
        public virtual int preçoBase { get; set; }
        public virtual Estada estada { get; set; }
        public virtual Alojamento alojamento { get; set; }
    }
}