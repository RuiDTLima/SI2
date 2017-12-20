namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Telefones
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string nomeParque { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int telefone { get; set; }

        public virtual ParqueCampismo ParqueCampismo { get; set; }
    }
}
