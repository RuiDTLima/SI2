namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Estada")]
    public partial class Estada
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Estada()
        {
            AlojamentoEstada = new HashSet<AlojamentoEstada>();
            EstadaExtra = new HashSet<EstadaExtra>();
            HóspedeEstada = new HashSet<HóspedeEstada>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int id { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime dataInício { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime dataFim { get; set; }

        public int? idFactura { get; set; }

        public int? ano { get; set; }

        [StringLength(30)]
        public string nomeParque { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AlojamentoEstada> AlojamentoEstada { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EstadaExtra> EstadaExtra { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<HóspedeEstada> HóspedeEstada { get; set; }

        public virtual Factura Factura { get; set; }

        public virtual ParqueCampismo ParqueCampismo { get; set; }
    }
}
