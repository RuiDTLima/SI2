﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ConsoleApp1
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class GlampinhoEF : DbContext
    {
        public GlampinhoEF()
            : base("name=GlampinhoEF")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
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
    
        [DbFunction("GlampinhoEF", "listAtividades")]
        public virtual IQueryable<listAtividades_Result> listAtividades(Nullable<System.DateTime> dataInicio, Nullable<System.DateTime> dataFim)
        {
            var dataInicioParameter = dataInicio.HasValue ?
                new ObjectParameter("dataInicio", dataInicio) :
                new ObjectParameter("dataInicio", typeof(System.DateTime));
    
            var dataFimParameter = dataFim.HasValue ?
                new ObjectParameter("dataFim", dataFim) :
                new ObjectParameter("dataFim", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.CreateQuery<listAtividades_Result>("[GlampinhoEF].[listAtividades](@dataInicio, @dataFim)", dataInicioParameter, dataFimParameter);
        }
    
        public virtual int addAlojamento(string tipoAlojamento, Nullable<byte> lotação, Nullable<int> idEstada)
        {
            var tipoAlojamentoParameter = tipoAlojamento != null ?
                new ObjectParameter("tipoAlojamento", tipoAlojamento) :
                new ObjectParameter("tipoAlojamento", typeof(string));
    
            var lotaçãoParameter = lotação.HasValue ?
                new ObjectParameter("lotação", lotação) :
                new ObjectParameter("lotação", typeof(byte));
    
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addAlojamento", tipoAlojamentoParameter, lotaçãoParameter, idEstadaParameter);
        }
    
        public virtual int addExtraPessoa(Nullable<int> idExtra, Nullable<int> idEstada)
        {
            var idExtraParameter = idExtra.HasValue ?
                new ObjectParameter("idExtra", idExtra) :
                new ObjectParameter("idExtra", typeof(int));
    
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addExtraPessoa", idExtraParameter, idEstadaParameter);
        }
    
        public virtual int addExtraToAlojamento(Nullable<int> idExtra, Nullable<int> idEstada)
        {
            var idExtraParameter = idExtra.HasValue ?
                new ObjectParameter("idExtra", idExtra) :
                new ObjectParameter("idExtra", typeof(int));
    
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addExtraToAlojamento", idExtraParameter, idEstadaParameter);
        }
    
        public virtual int addExtraToEstada(Nullable<int> idExtra, Nullable<int> idEstada)
        {
            var idExtraParameter = idExtra.HasValue ?
                new ObjectParameter("idExtra", idExtra) :
                new ObjectParameter("idExtra", typeof(int));
    
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addExtraToEstada", idExtraParameter, idEstadaParameter);
        }
    
        public virtual int addHóspede(Nullable<int> nIF, Nullable<int> id)
        {
            var nIFParameter = nIF.HasValue ?
                new ObjectParameter("NIF", nIF) :
                new ObjectParameter("NIF", typeof(int));
    
            var idParameter = id.HasValue ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addHóspede", nIFParameter, idParameter);
        }
    
        public virtual ObjectResult<Nullable<int>> addHospedeAtividade(Nullable<int> hospede, string nomeParque, Nullable<int> númeroSequencial)
        {
            var hospedeParameter = hospede.HasValue ?
                new ObjectParameter("hospede", hospede) :
                new ObjectParameter("hospede", typeof(int));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var númeroSequencialParameter = númeroSequencial.HasValue ?
                new ObjectParameter("númeroSequencial", númeroSequencial) :
                new ObjectParameter("númeroSequencial", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("addHospedeAtividade", hospedeParameter, nomeParqueParameter, númeroSequencialParameter);
        }
    
        public virtual int addPreçoTotal(Nullable<int> idFactura, Nullable<int> ano)
        {
            var idFacturaParameter = idFactura.HasValue ?
                new ObjectParameter("idFactura", idFactura) :
                new ObjectParameter("idFactura", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addPreçoTotal", idFacturaParameter, anoParameter);
        }
    
        public virtual int createEstada(Nullable<int> nIFResponsável, Nullable<int> tempoEstada, ObjectParameter idNumber)
        {
            var nIFResponsávelParameter = nIFResponsável.HasValue ?
                new ObjectParameter("NIFResponsável", nIFResponsável) :
                new ObjectParameter("NIFResponsável", typeof(int));
    
            var tempoEstadaParameter = tempoEstada.HasValue ?
                new ObjectParameter("tempoEstada", tempoEstada) :
                new ObjectParameter("tempoEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("createEstada", nIFResponsávelParameter, tempoEstadaParameter, idNumber);
        }
    
        public virtual int createEstadaInTime(Nullable<int> nIFResponsável, Nullable<int> nIFHóspede, Nullable<int> tempoEstada, string tipoAlojamento, Nullable<byte> lotação, Nullable<int> idExtraPessoal, Nullable<int> idExtraAlojamento)
        {
            var nIFResponsávelParameter = nIFResponsável.HasValue ?
                new ObjectParameter("NIFResponsável", nIFResponsável) :
                new ObjectParameter("NIFResponsável", typeof(int));
    
            var nIFHóspedeParameter = nIFHóspede.HasValue ?
                new ObjectParameter("NIFHóspede", nIFHóspede) :
                new ObjectParameter("NIFHóspede", typeof(int));
    
            var tempoEstadaParameter = tempoEstada.HasValue ?
                new ObjectParameter("tempoEstada", tempoEstada) :
                new ObjectParameter("tempoEstada", typeof(int));
    
            var tipoAlojamentoParameter = tipoAlojamento != null ?
                new ObjectParameter("tipoAlojamento", tipoAlojamento) :
                new ObjectParameter("tipoAlojamento", typeof(string));
    
            var lotaçãoParameter = lotação.HasValue ?
                new ObjectParameter("lotação", lotação) :
                new ObjectParameter("lotação", typeof(byte));
    
            var idExtraPessoalParameter = idExtraPessoal.HasValue ?
                new ObjectParameter("idExtraPessoal", idExtraPessoal) :
                new ObjectParameter("idExtraPessoal", typeof(int));
    
            var idExtraAlojamentoParameter = idExtraAlojamento.HasValue ?
                new ObjectParameter("idExtraAlojamento", idExtraAlojamento) :
                new ObjectParameter("idExtraAlojamento", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("createEstadaInTime", nIFResponsávelParameter, nIFHóspedeParameter, tempoEstadaParameter, tipoAlojamentoParameter, lotaçãoParameter, idExtraPessoalParameter, idExtraAlojamentoParameter);
        }
    
        public virtual int deleteALL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteALL");
        }
    
        public virtual int deleteAlojamento(string localização, string nomeParque)
        {
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteAlojamento", localizaçãoParameter, nomeParqueParameter);
        }
    
        public virtual int deleteAlojamentoBungalow(string localização, string nomeParque)
        {
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteAlojamentoBungalow", localizaçãoParameter, nomeParqueParameter);
        }
    
        public virtual int deleteAlojamentoTenda(string localização, string nomeParque)
        {
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteAlojamentoTenda", localizaçãoParameter, nomeParqueParameter);
        }
    
        public virtual int deleteAtividades(string nomeParque, Nullable<int> númeroSequencial, Nullable<int> ano)
        {
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var númeroSequencialParameter = númeroSequencial.HasValue ?
                new ObjectParameter("númeroSequencial", númeroSequencial) :
                new ObjectParameter("númeroSequencial", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteAtividades", nomeParqueParameter, númeroSequencialParameter, anoParameter);
        }
    
        public virtual int deleteExtra(Nullable<int> id)
        {
            var idParameter = id.HasValue ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteExtra", idParameter);
        }
    
        public virtual int deleteExtraPessoa(Nullable<int> id)
        {
            var idParameter = id.HasValue ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteExtraPessoa", idParameter);
        }
    
        public virtual int deleteHospede(Nullable<int> nIFHospede)
        {
            var nIFHospedeParameter = nIFHospede.HasValue ?
                new ObjectParameter("NIFHospede", nIFHospede) :
                new ObjectParameter("NIFHospede", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("deleteHospede", nIFHospedeParameter);
        }
    
        public virtual int eliminaHóspedesAssociados(Nullable<int> idEstada)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("eliminaHóspedesAssociados", idEstadaParameter);
        }
    
        public virtual int finishEstadaWithFactura(Nullable<int> idEstada)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("finishEstadaWithFactura", idEstadaParameter);
        }
    
        public virtual int getAlojamentoPreço(Nullable<int> idEstada, Nullable<int> idFactura, Nullable<int> ano, Nullable<int> linha, ObjectParameter novaLinha)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            var idFacturaParameter = idFactura.HasValue ?
                new ObjectParameter("idFactura", idFactura) :
                new ObjectParameter("idFactura", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            var linhaParameter = linha.HasValue ?
                new ObjectParameter("linha", linha) :
                new ObjectParameter("linha", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("getAlojamentoPreço", idEstadaParameter, idFacturaParameter, anoParameter, linhaParameter, novaLinha);
        }
    
        public virtual int getCustoTotalActividades(Nullable<int> idEstada, Nullable<int> idFactura, Nullable<int> ano, Nullable<int> linha)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            var idFacturaParameter = idFactura.HasValue ?
                new ObjectParameter("idFactura", idFactura) :
                new ObjectParameter("idFactura", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            var linhaParameter = linha.HasValue ?
                new ObjectParameter("linha", linha) :
                new ObjectParameter("linha", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("getCustoTotalActividades", idEstadaParameter, idFacturaParameter, anoParameter, linhaParameter);
        }
    
        public virtual int getEstadaExtrasPreço(Nullable<int> idEstada, Nullable<int> idFactura, Nullable<int> ano, Nullable<int> linha, ObjectParameter novaLinha)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            var idFacturaParameter = idFactura.HasValue ?
                new ObjectParameter("idFactura", idFactura) :
                new ObjectParameter("idFactura", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            var linhaParameter = linha.HasValue ?
                new ObjectParameter("linha", linha) :
                new ObjectParameter("linha", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("getEstadaExtrasPreço", idEstadaParameter, idFacturaParameter, anoParameter, linhaParameter, novaLinha);
        }
    
        public virtual int getPessoalExtrasPreço(Nullable<int> idEstada, Nullable<int> idFactura, Nullable<int> ano, Nullable<int> linha, ObjectParameter novaLinha)
        {
            var idEstadaParameter = idEstada.HasValue ?
                new ObjectParameter("idEstada", idEstada) :
                new ObjectParameter("idEstada", typeof(int));
    
            var idFacturaParameter = idFactura.HasValue ?
                new ObjectParameter("idFactura", idFactura) :
                new ObjectParameter("idFactura", typeof(int));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            var linhaParameter = linha.HasValue ?
                new ObjectParameter("linha", linha) :
                new ObjectParameter("linha", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("getPessoalExtrasPreço", idEstadaParameter, idFacturaParameter, anoParameter, linhaParameter, novaLinha);
        }
    
        public virtual int inscreverHóspede(Nullable<int> nIFHóspede, Nullable<int> númeroSequencial, string nomeParque, Nullable<int> ano)
        {
            var nIFHóspedeParameter = nIFHóspede.HasValue ?
                new ObjectParameter("NIFHóspede", nIFHóspede) :
                new ObjectParameter("NIFHóspede", typeof(int));
    
            var númeroSequencialParameter = númeroSequencial.HasValue ?
                new ObjectParameter("númeroSequencial", númeroSequencial) :
                new ObjectParameter("númeroSequencial", typeof(int));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var anoParameter = ano.HasValue ?
                new ObjectParameter("ano", ano) :
                new ObjectParameter("ano", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("inscreverHóspede", nIFHóspedeParameter, númeroSequencialParameter, nomeParqueParameter, anoParameter);
        }
    
        public virtual int InsertAlojamentoBungalow(string nomeParque, string nome, string localização, string descrição, Nullable<int> preçoBase, Nullable<byte> númeroMáximoPessoas, string tipologia)
        {
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var nomeParameter = nome != null ?
                new ObjectParameter("nome", nome) :
                new ObjectParameter("nome", typeof(string));
    
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var descriçãoParameter = descrição != null ?
                new ObjectParameter("descrição", descrição) :
                new ObjectParameter("descrição", typeof(string));
    
            var preçoBaseParameter = preçoBase.HasValue ?
                new ObjectParameter("preçoBase", preçoBase) :
                new ObjectParameter("preçoBase", typeof(int));
    
            var númeroMáximoPessoasParameter = númeroMáximoPessoas.HasValue ?
                new ObjectParameter("númeroMáximoPessoas", númeroMáximoPessoas) :
                new ObjectParameter("númeroMáximoPessoas", typeof(byte));
    
            var tipologiaParameter = tipologia != null ?
                new ObjectParameter("tipologia", tipologia) :
                new ObjectParameter("tipologia", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("InsertAlojamentoBungalow", nomeParqueParameter, nomeParameter, localizaçãoParameter, descriçãoParameter, preçoBaseParameter, númeroMáximoPessoasParameter, tipologiaParameter);
        }
    
        public virtual int InsertAlojamentoTenda(string nomeParque, string nome, string localização, string descrição, Nullable<int> preçoBase, Nullable<byte> númeroMáximoPessoas, Nullable<int> área)
        {
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var nomeParameter = nome != null ?
                new ObjectParameter("nome", nome) :
                new ObjectParameter("nome", typeof(string));
    
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var descriçãoParameter = descrição != null ?
                new ObjectParameter("descrição", descrição) :
                new ObjectParameter("descrição", typeof(string));
    
            var preçoBaseParameter = preçoBase.HasValue ?
                new ObjectParameter("preçoBase", preçoBase) :
                new ObjectParameter("preçoBase", typeof(int));
    
            var númeroMáximoPessoasParameter = númeroMáximoPessoas.HasValue ?
                new ObjectParameter("númeroMáximoPessoas", númeroMáximoPessoas) :
                new ObjectParameter("númeroMáximoPessoas", typeof(byte));
    
            var áreaParameter = área.HasValue ?
                new ObjectParameter("área", área) :
                new ObjectParameter("área", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("InsertAlojamentoTenda", nomeParqueParameter, nomeParameter, localizaçãoParameter, descriçãoParameter, preçoBaseParameter, númeroMáximoPessoasParameter, áreaParameter);
        }
    
        public virtual ObjectResult<listarAtividades_Result> listarAtividades(Nullable<System.DateTime> dataInicio, Nullable<System.DateTime> dataFim)
        {
            var dataInicioParameter = dataInicio.HasValue ?
                new ObjectParameter("dataInicio", dataInicio) :
                new ObjectParameter("dataInicio", typeof(System.DateTime));
    
            var dataFimParameter = dataFim.HasValue ?
                new ObjectParameter("dataFim", dataFim) :
                new ObjectParameter("dataFim", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<listarAtividades_Result>("listarAtividades", dataInicioParameter, dataFimParameter);
        }
    
        public virtual int mediaPagamentos(Nullable<int> n, ObjectParameter pagamento)
        {
            var nParameter = n.HasValue ?
                new ObjectParameter("n", n) :
                new ObjectParameter("n", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("mediaPagamentos", nParameter, pagamento);
        }
    
        public virtual int SendEmails(Nullable<int> periodoTemporal)
        {
            var periodoTemporalParameter = periodoTemporal.HasValue ?
                new ObjectParameter("periodoTemporal", periodoTemporal) :
                new ObjectParameter("periodoTemporal", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("SendEmails", periodoTemporalParameter);
        }
    
        public virtual int test(Nullable<int> lol)
        {
            var lolParameter = lol.HasValue ?
                new ObjectParameter("lol", lol) :
                new ObjectParameter("lol", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("test", lolParameter);
        }
    
        public virtual int test2(Nullable<int> lol)
        {
            var lolParameter = lol.HasValue ?
                new ObjectParameter("lol", lol) :
                new ObjectParameter("lol", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("test2", lolParameter);
        }
    
        public virtual ObjectResult<testeAlineaC_Result> testeAlineaC()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaC_Result>("testeAlineaC");
        }
    
        public virtual ObjectResult<testeAlineaD_DELETE_Result> testeAlineaD_DELETE()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaD_DELETE_Result>("testeAlineaD_DELETE");
        }
    
        public virtual ObjectResult<testeAlineaD_INSERT_Result> testeAlineaD_INSERT()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaD_INSERT_Result>("testeAlineaD_INSERT");
        }
    
        public virtual ObjectResult<testeAlineaI_Result> testeAlineaI()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaI_Result>("testeAlineaI");
        }
    
        public virtual ObjectResult<testeAlineaJ_Result> testeAlineaJ()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaJ_Result>("testeAlineaJ");
        }
    
        public virtual int testeAlineaK()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("testeAlineaK");
        }
    
        public virtual ObjectResult<testeAlineaL_Result> testeAlineaL()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaL_Result>("testeAlineaL");
        }
    
        public virtual ObjectResult<Nullable<int>> testeAlineaM()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("testeAlineaM");
        }
    
        public virtual ObjectResult<Nullable<int>> verificarHospedeParque(Nullable<int> hospede, string nomeParque)
        {
            var hospedeParameter = hospede.HasValue ?
                new ObjectParameter("hospede", hospede) :
                new ObjectParameter("hospede", typeof(int));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("verificarHospedeParque", hospedeParameter, nomeParqueParameter);
        }
    
        public virtual int inserts()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("inserts");
        }
    
        public virtual int sendEmail(Nullable<int> nIF, string email, string text, ObjectParameter mail)
        {
            var nIFParameter = nIF.HasValue ?
                new ObjectParameter("NIF", nIF) :
                new ObjectParameter("NIF", typeof(int));
    
            var emailParameter = email != null ?
                new ObjectParameter("email", email) :
                new ObjectParameter("email", typeof(string));
    
            var textParameter = text != null ?
                new ObjectParameter("text", text) :
                new ObjectParameter("text", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sendEmail", nIFParameter, emailParameter, textParameter, mail);
        }
    
        public virtual ObjectResult<string> SendEmails1(Nullable<int> periodoTemporal)
        {
            var periodoTemporalParameter = periodoTemporal.HasValue ?
                new ObjectParameter("periodoTemporal", periodoTemporal) :
                new ObjectParameter("periodoTemporal", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("SendEmails1", periodoTemporalParameter);
        }
    
        public virtual ObjectResult<testaInsertAlojamentoBungalow_Result> testaInsertAlojamentoBungalow()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testaInsertAlojamentoBungalow_Result>("testaInsertAlojamentoBungalow");
        }
    
        public virtual ObjectResult<testaInsertAlojamentoTenda_Result> testaInsertAlojamentoTenda()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testaInsertAlojamentoTenda_Result>("testaInsertAlojamentoTenda");
        }
    
        public virtual ObjectResult<testeAlineaE_Result> testeAlineaE()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaE_Result>("testeAlineaE");
        }
    
        public virtual ObjectResult<testeAlineaF_Result> testeAlineaF()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaF_Result>("testeAlineaF");
        }
    
        public virtual ObjectResult<testeAlineaG_Result> testeAlineaG()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaG_Result>("testeAlineaG");
        }
    
        public virtual ObjectResult<testeAlineaHAddAlojamento_Result> testeAlineaHAddAlojamento()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHAddAlojamento_Result>("testeAlineaHAddAlojamento");
        }
    
        public virtual ObjectResult<testeAlineaHAddExtraToAlojamento_Result> testeAlineaHAddExtraToAlojamento()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHAddExtraToAlojamento_Result>("testeAlineaHAddExtraToAlojamento");
        }
    
        public virtual ObjectResult<testeAlineaHAddExtraToEstada_Result> testeAlineaHAddExtraToEstada()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHAddExtraToEstada_Result>("testeAlineaHAddExtraToEstada");
        }
    
        public virtual ObjectResult<testeAlineaHAddHóspede_Result> testeAlineaHAddHóspede()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHAddHóspede_Result>("testeAlineaHAddHóspede");
        }
    
        public virtual ObjectResult<testeAlineaHCreateEstada_Result> testeAlineaHCreateEstada()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHCreateEstada_Result>("testeAlineaHCreateEstada");
        }
    
        public virtual ObjectResult<testeAlineaHCreateEstadaInTime_Result> testeAlineaHCreateEstadaInTime()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaHCreateEstadaInTime_Result>("testeAlineaHCreateEstadaInTime");
        }
    
        public virtual ObjectResult<testeAlineaNTriggerDelete_Result> testeAlineaNTriggerDelete()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaNTriggerDelete_Result>("testeAlineaNTriggerDelete");
        }
    
        public virtual ObjectResult<testeAlineaNTriggerInsert_Result> testeAlineaNTriggerInsert()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaNTriggerInsert_Result>("testeAlineaNTriggerInsert");
        }
    
        public virtual ObjectResult<testeAlineaNTriggerUpdate_Result> testeAlineaNTriggerUpdate()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<testeAlineaNTriggerUpdate_Result>("testeAlineaNTriggerUpdate");
        }
    
        public virtual int UpdateAlojamento(Nullable<int> preçoBase, Nullable<byte> númeroMáximoPessoas, string descrição, string nomeParque, string localização)
        {
            var preçoBaseParameter = preçoBase.HasValue ?
                new ObjectParameter("preçoBase", preçoBase) :
                new ObjectParameter("preçoBase", typeof(int));
    
            var númeroMáximoPessoasParameter = númeroMáximoPessoas.HasValue ?
                new ObjectParameter("númeroMáximoPessoas", númeroMáximoPessoas) :
                new ObjectParameter("númeroMáximoPessoas", typeof(byte));
    
            var descriçãoParameter = descrição != null ?
                new ObjectParameter("descrição", descrição) :
                new ObjectParameter("descrição", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("UpdateAlojamento", preçoBaseParameter, númeroMáximoPessoasParameter, descriçãoParameter, nomeParqueParameter, localizaçãoParameter);
        }
    
        public virtual int UpdateAlojamentoBungalow(Nullable<int> preçoBase, Nullable<byte> númeroMáximoPessoas, string descrição, string nomeParque, string localização, string tipologia)
        {
            var preçoBaseParameter = preçoBase.HasValue ?
                new ObjectParameter("preçoBase", preçoBase) :
                new ObjectParameter("preçoBase", typeof(int));
    
            var númeroMáximoPessoasParameter = númeroMáximoPessoas.HasValue ?
                new ObjectParameter("númeroMáximoPessoas", númeroMáximoPessoas) :
                new ObjectParameter("númeroMáximoPessoas", typeof(byte));
    
            var descriçãoParameter = descrição != null ?
                new ObjectParameter("descrição", descrição) :
                new ObjectParameter("descrição", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var tipologiaParameter = tipologia != null ?
                new ObjectParameter("tipologia", tipologia) :
                new ObjectParameter("tipologia", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("UpdateAlojamentoBungalow", preçoBaseParameter, númeroMáximoPessoasParameter, descriçãoParameter, nomeParqueParameter, localizaçãoParameter, tipologiaParameter);
        }
    
        public virtual int UpdateAlojamentoTenda(Nullable<int> preçoBase, Nullable<byte> númeroMáximoPessoas, string descrição, string nomeParque, string localização, Nullable<int> área)
        {
            var preçoBaseParameter = preçoBase.HasValue ?
                new ObjectParameter("preçoBase", preçoBase) :
                new ObjectParameter("preçoBase", typeof(int));
    
            var númeroMáximoPessoasParameter = númeroMáximoPessoas.HasValue ?
                new ObjectParameter("númeroMáximoPessoas", númeroMáximoPessoas) :
                new ObjectParameter("númeroMáximoPessoas", typeof(byte));
    
            var descriçãoParameter = descrição != null ?
                new ObjectParameter("descrição", descrição) :
                new ObjectParameter("descrição", typeof(string));
    
            var nomeParqueParameter = nomeParque != null ?
                new ObjectParameter("nomeParque", nomeParque) :
                new ObjectParameter("nomeParque", typeof(string));
    
            var localizaçãoParameter = localização != null ?
                new ObjectParameter("localização", localização) :
                new ObjectParameter("localização", typeof(string));
    
            var áreaParameter = área.HasValue ?
                new ObjectParameter("área", área) :
                new ObjectParameter("área", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("UpdateAlojamentoTenda", preçoBaseParameter, númeroMáximoPessoasParameter, descriçãoParameter, nomeParqueParameter, localizaçãoParameter, áreaParameter);
        }
    }
}
