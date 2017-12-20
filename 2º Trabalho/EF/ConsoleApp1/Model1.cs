namespace ConsoleApp1
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class Model1 : DbContext
    {
        public Model1()
            : base("name=Model1")
        {
        }

        public virtual DbSet<Actividades> Actividades { get; set; }
        public virtual DbSet<Alojamento> Alojamento { get; set; }
        public virtual DbSet<AlojamentoEstada> AlojamentoEstada { get; set; }
        public virtual DbSet<Bungalow> Bungalow { get; set; }
        public virtual DbSet<Estada> Estada { get; set; }
        public virtual DbSet<EstadaExtra> EstadaExtra { get; set; }
        public virtual DbSet<Extra> Extra { get; set; }
        public virtual DbSet<Factura> Factura { get; set; }
        public virtual DbSet<Hóspede> Hóspede { get; set; }
        public virtual DbSet<HóspedeEstada> HóspedeEstada { get; set; }
        public virtual DbSet<Item> Item { get; set; }
        public virtual DbSet<Paga> Paga { get; set; }
        public virtual DbSet<ParqueCampismo> ParqueCampismo { get; set; }
        public virtual DbSet<Telefones> Telefones { get; set; }
        public virtual DbSet<Tenda> Tenda { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Actividades>()
                .HasMany(e => e.Paga)
                .WithRequired(e => e.Actividades)
                .HasForeignKey(e => new { e.nomeParque, e.númeroSequencial, e.ano });

            modelBuilder.Entity<Alojamento>()
                .Property(e => e.tipoAlojamento)
                .IsUnicode(false);

            modelBuilder.Entity<Alojamento>()
                .HasMany(e => e.AlojamentoEstada)
                .WithRequired(e => e.Alojamento)
                .HasForeignKey(e => new { e.nomeParque, e.localização });

            modelBuilder.Entity<Alojamento>()
                .HasOptional(e => e.Bungalow)
                .WithRequired(e => e.Alojamento)
                .WillCascadeOnDelete();

            modelBuilder.Entity<Alojamento>()
                .HasOptional(e => e.Tenda)
                .WithRequired(e => e.Alojamento)
                .WillCascadeOnDelete();

            modelBuilder.Entity<Bungalow>()
                .Property(e => e.tipologia)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Estada>()
                .HasMany(e => e.AlojamentoEstada)
                .WithRequired(e => e.Estada)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Extra>()
                .Property(e => e.associado)
                .IsUnicode(false);

            modelBuilder.Entity<Extra>()
                .HasMany(e => e.Alojamento)
                .WithMany(e => e.Extra)
                .Map(m => m.ToTable("AlojamentoExtra").MapLeftKey("id").MapRightKey(new[] { "nomeParque", "localização" }));

            modelBuilder.Entity<Factura>()
                .HasMany(e => e.Estada)
                .WithOptional(e => e.Factura)
                .HasForeignKey(e => new { e.idFactura, e.ano })
                .WillCascadeOnDelete();

            modelBuilder.Entity<Factura>()
                .HasMany(e => e.Item)
                .WithRequired(e => e.Factura)
                .HasForeignKey(e => new { e.idFactura, e.ano })
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Hóspede>()
                .HasMany(e => e.Factura)
                .WithOptional(e => e.Hóspede)
                .HasForeignKey(e => e.NIFHóspede);

            modelBuilder.Entity<HóspedeEstada>()
                .Property(e => e.hóspede)
                .IsUnicode(false);

            modelBuilder.Entity<Item>()
                .Property(e => e.tipo)
                .IsUnicode(false);

            modelBuilder.Entity<ParqueCampismo>()
                .HasMany(e => e.Actividades)
                .WithRequired(e => e.ParqueCampismo)
                .HasForeignKey(e => e.nomeParque);

            modelBuilder.Entity<ParqueCampismo>()
                .HasMany(e => e.Alojamento)
                .WithRequired(e => e.ParqueCampismo)
                .HasForeignKey(e => e.nomeParque);

            modelBuilder.Entity<ParqueCampismo>()
                .HasMany(e => e.Estada)
                .WithOptional(e => e.ParqueCampismo)
                .HasForeignKey(e => e.nomeParque)
                .WillCascadeOnDelete();

            modelBuilder.Entity<ParqueCampismo>()
                .HasMany(e => e.Telefones)
                .WithRequired(e => e.ParqueCampismo)
                .HasForeignKey(e => e.nomeParque);
        }
    }
}
