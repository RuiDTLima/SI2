namespace Glampinho.model {
    class Tenda : Alojamento{
        public virtual int área { get; set; }
        public virtual Alojamento alojamento { get; set; }
    }
}