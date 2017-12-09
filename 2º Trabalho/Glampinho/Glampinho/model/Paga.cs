using System;

namespace Glampinho.model {
    class Paga {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual int númeroSequencial { get; set; }   // chave primária
        public virtual int ano { get; set; }    // chave primária
        public virtual int NIF { get; set; }    // chave primária
        public virtual int preçoParticipante { get; set; }
        public virtual Actividades actividades { get; set; }
    }
}
