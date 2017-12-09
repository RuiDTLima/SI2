using System;

namespace Glampinho.model {
    class Alojamento {
        public virtual String nome { get; set; }    // unique
        public virtual String localização { get; set; } // chave primária
        public virtual String descrição { get; set; }
        public virtual int preçoBase { get; set; }
        public virtual int númeroMáximoPessoas { get; set; }
        public virtual String tipoAlojamento { get; set; }  // 'bungalow' || 'tenda'
        public virtual String nomeParque { get; set; }  // chave primária
        public virtual ParqueCampismo parque { get; set; }
    }
}