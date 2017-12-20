namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("AlojamentoEstada")]
    public partial class AlojamentoEstada
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string nomeParque { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(30)]
        public string localização { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int id { get; set; }

        public int? preçoBase { get; set; }

        public virtual Alojamento Alojamento { get; set; }

        public virtual Estada Estada { get; set; }
    }
}
