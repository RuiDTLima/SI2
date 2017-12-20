namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Actividades
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Actividades()
        {
            Paga = new HashSet<Paga>();
        }

        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string nomeParque { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int númeroSequencial { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ano { get; set; }

        [StringLength(30)]
        public string nome { get; set; }

        [StringLength(30)]
        public string descrição { get; set; }

        public int? lotaçãoMáxima { get; set; }

        public int? preçoParticipante { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? dataRealização { get; set; }

        public virtual ParqueCampismo ParqueCampismo { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Paga> Paga { get; set; }
    }
}
