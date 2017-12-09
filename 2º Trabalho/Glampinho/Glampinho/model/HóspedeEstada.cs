using System;

namespace Glampinho.model {
    class HóspedeEstada {
        public virtual int NIF { get; set; }    // chave primária
        public virtual int id { get; set; }     // chave primária
        public virtual String hóspede { get; set; } // 'true' || 'false'
        public virtual Hóspede hósp { get; set; }
        public virtual Estada estada { get; set; }
    }
}