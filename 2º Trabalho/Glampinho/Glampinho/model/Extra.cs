using System;

namespace Glampinho.model {
    class Extra {
        public virtual int id { get; set; } // chave primária
        public virtual String descrição { get; set; }
        public virtual int preçoDia { get; set; }
        public virtual String associado { get; set; }   // 'alojamento' || 'pessoa'
    }
}