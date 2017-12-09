namespace Glampinho.model {
    class EstadaExtra {
        public virtual int estadaId { get; set; }   // chave primária
        public virtual int extraId { get; set; }    // chave primária
        public virtual int preçoDia { get; set; }
        public virtual Estada estada { get; set; }
        public virtual Extra extra { get; set; }
    }
}