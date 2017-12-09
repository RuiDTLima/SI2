using System;

namespace Glampinho.model {
    class Actividades {
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual int númeroSequencial { get; set; }   // chave primária
        public virtual int ano { get; set; }    // chave primária
        public virtual String nome { get; set; }
        public virtual String descrição { get; set; }
        public virtual int lotaçãoMáxima { get; set; }
        public virtual int preçoParticipante { get; set; }
        public virtual DateTime dataRealização { get; set; }
        public virtual ParqueCampismo parque { get; set; }
    }
}
