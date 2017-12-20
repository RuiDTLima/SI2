namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Alojamento")]
    public partial class Alojamento
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Alojamento()
        {
            AlojamentoEstada = new HashSet<AlojamentoEstada>();
            Extra = new HashSet<Extra>();
        }

        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string nomeParque { get; set; }

        [Required]
        [StringLength(30)]
        public string nome { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(30)]
        public string localização { get; set; }

        [StringLength(30)]
        public string descrição { get; set; }

        public int? preçoBase { get; set; }

        public byte? númeroMáximoPessoas { get; set; }

        [Required]
        [StringLength(8)]
        public string tipoAlojamento { get; set; }

        public virtual ParqueCampismo ParqueCampismo { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AlojamentoEstada> AlojamentoEstada { get; set; }

        public virtual Bungalow Bungalow { get; set; }

        public virtual Tenda Tenda { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Extra> Extra { get; set; }
    }
}
