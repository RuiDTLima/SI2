using System;

namespace Glampinho.model {
    class Telefones {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual int telefone { get; set; }   // chave primária
        public virtual ParqueCampismo parque { get; set; }
    }
}