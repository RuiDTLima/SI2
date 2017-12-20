namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Bungalow")]
    public partial class Bungalow
    {
        [Key , ForeignKey("Alojamento")]
        [Column(Order = 0)]
        [StringLength(30)]
        public string nomeParque { get; set; }

        [Key , ForeignKey("Alojamento")]
        [Column(Order = 1)]
        [StringLength(30)]
        public string localização { get; set; }

        [Required]
        [StringLength(2)]
        public string tipologia { get; set; }

        public virtual Alojamento Alojamento { get; set; }
    }
}
