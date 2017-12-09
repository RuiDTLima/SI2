using System;

namespace Glampinho.model {
    class Hóspede {
        public virtual int NIF { get; set; }    // chave primária
        public virtual String nome { get; set; }
        public virtual String morada { get; set; }
        public virtual String email { get; set; }
        public virtual int númeroIdentificação { get; set; }
    }
}