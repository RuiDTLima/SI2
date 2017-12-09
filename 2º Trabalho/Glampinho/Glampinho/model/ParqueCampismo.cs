using System;

namespace Glampinho.model {
    public class ParqueCampismo {
        public virtual string nome { get; set; }    // chave primária
        public virtual String morada { get; set; }
        public virtual int estrelas { get; set; }   // 1 || 2 || 3 || 4 || 5
        public virtual String email { get; set; }
    }
}