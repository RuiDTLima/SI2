using Glampinho.concrete;
using Glampinho.mapper;
using Glampinho.model;
using System;
using System.Configuration;

namespace Glampinho {
    class Program {
        static void Main(string[] args) {
            string connectionString = ConfigurationManager.ConnectionStrings["glampinho"].ConnectionString;
            /* ---------- Teste Hóspede ---------- */
            /*using (Context context = new Context(connectionString)) {
                Hóspede hóspede = new Hóspede();

                hóspede.NIF = 112233445;

                HóspedeMapper hóspedeMapper = new HóspedeMapper(context);

                foreach (var h in hóspedeMapper.ReadAll()) {
                    Console.WriteLine("Hóspede: {0} || {1} || {2} || {3} || {4}", h.NIF, h.nome, h.morada, h.email, h.númeroIdentificação);
                }

                Hóspede newHóspede = new Hóspede();
                newHóspede.nome = "teste C#";
                newHóspede.NIF = 1;
                newHóspede.morada = "teste";
                newHóspede.email = "teste@c#.com";
                newHóspede.númeroIdentificação = 12;

                newHóspede = hóspedeMapper.Create(newHóspede);

                Console.WriteLine("Hóspede: {0} || {1} || {2} || {3} || {4}", newHóspede.NIF, newHóspede.nome, newHóspede.morada, newHóspede.email, newHóspede.númeroIdentificação);
                
                newHóspede.morada = "update";
                newHóspede.nome = "teste C#";
                newHóspede.NIF = 1;
                newHóspede.email = "teste@c#.com";
                newHóspede.númeroIdentificação = 12;
                hóspedeMapper.Update(newHóspede);

                Hóspede deleteHóspede = new Hóspede();
                deleteHóspede.NIF = 112233445;
            }*/

            /* ---------- Teste Bungalow ---------- */
            /*using (Context context = new Context(connectionString)) {
                BungalowMapper bungalowMapper = new BungalowMapper(context);

                foreach(var bungalow in bungalowMapper.ReadAll()) {
                    Console.WriteLine("Bungalow: {0} || {1} || {2} || {3} || {4} || {5} || {6}", bungalow.nomeParque, bungalow.nome, bungalow.localização, bungalow.descrição, bungalow.preçoBase, bungalow.númeroMáximoPessoas, bungalow.tipologia);
                }

                Bungalow newBungalow = new Bungalow();
                newBungalow.nomeParque = "Glampinho";
                newBungalow.nome = "test c#";
                newBungalow.localização = "Rua c#";
                newBungalow.descrição = "bungalow de teste de c#";
                newBungalow.preçoBase = 50;
                newBungalow.númeroMáximoPessoas = 0;
                newBungalow.tipologia = "T0";

                newBungalow = bungalowMapper.Create(newBungalow);

                Console.WriteLine("Bungalow: {0} || {1} || {2} || {3} || {4} || {5} || {6}", newBungalow.nomeParque, newBungalow.nome, newBungalow.localização, newBungalow.descrição, newBungalow.preçoBase, newBungalow.númeroMáximoPessoas, newBungalow.tipologia);

                newBungalow.preçoBase = 0;
                bungalowMapper.Update(newBungalow);

                bungalowMapper.Delete(newBungalow);
            }*/

            /* ---------- Teste Tenda ---------- */
            /*using (Context context = new Context(connectionString)) {
                TendaMapper tendaMapper = new TendaMapper(context);

                foreach (var tenda in tendaMapper.ReadAll()) {
                    Console.WriteLine("Tenda: {0} || {1} || {2} || {3} || {4} || {5} || {6}", tenda.nomeParque, tenda.nome, tenda.localização, tenda.descrição, tenda.preçoBase, tenda.númeroMáximoPessoas, tenda.área);
                }

                Tenda newTenda = new Tenda();
                newTenda.nomeParque = "Glampinho";
                newTenda.nome = "Tenda c#";
                newTenda.localização = "Rua tenda c#";
                newTenda.descrição = "tenda de teste de c#";
                newTenda.preçoBase = 50;
                newTenda.númeroMáximoPessoas = 1;
                newTenda.área = 25;

                newTenda = tendaMapper.Create(newTenda);

                Console.WriteLine("Tenda: {0} || {1} || {2} || {3} || {4} || {5} || {6}", newTenda.nomeParque, newTenda.nome, newTenda.localização, newTenda.descrição, newTenda.preçoBase, newTenda.númeroMáximoPessoas, newTenda.área);

                newTenda.preçoBase = 0;
                tendaMapper.Update(newTenda);

                tendaMapper.Delete(newTenda);
            }*/

            /* ---------- Teste Extra Alojamento ---------- */
            /*using(Context context = new Context(connectionString)) {
                ExtraAlojamentoMapper extraAlojamentoMapper = new ExtraAlojamentoMapper(context);

                foreach(var extra in extraAlojamentoMapper.ReadAll()) {
                    Console.WriteLine("Extra Alojamento: {0} || {1} || {2} || {3}", extra.id, extra.descrição, extra.preçoDia, extra.associado);
                }

                Extra newExtraAlojamento = new Extra();
                newExtraAlojamento.id = 3;
                newExtraAlojamento.descrição = "extra de alojamento de teste";
                newExtraAlojamento.preçoDia = 0;
                newExtraAlojamento.associado = "alojamento";

                newExtraAlojamento = extraAlojamentoMapper.Create(newExtraAlojamento);
                Console.WriteLine("Extra Alojamento: {0} || {1} || {2} || {3}", newExtraAlojamento.id, newExtraAlojamento.descrição, newExtraAlojamento.preçoDia, newExtraAlojamento.associado);

                newExtraAlojamento.preçoDia = 50;
                extraAlojamentoMapper.Update(newExtraAlojamento);

                Extra deletedExtra = new Extra();
                deletedExtra.id = 1;
                deletedExtra.descrição = "descricao";
                deletedExtra.preçoDia = 12;
                deletedExtra.associado = "alojamento";

                extraAlojamentoMapper.Delete(deletedExtra);
            }*/

            /* ---------- Teste Extra Pessoal ---------- */
            /*using (Context context = new Context(connectionString)) {
                ExtraPessoalMapper extraPessoalMapper = new ExtraPessoalMapper(context);

                foreach (var extra in extraPessoalMapper.ReadAll()) {
                    Console.WriteLine("Extra Pessoa: {0} || {1} || {2} || {3}", extra.id, extra.descrição, extra.preçoDia, extra.associado);
                }

                Extra newExtraPessoa = new Extra();
                newExtraPessoa.id = 3;
                newExtraPessoa.descrição = "extra de pessoa de teste";
                newExtraPessoa.preçoDia = 0;
                newExtraPessoa.associado = "pessoa";

                newExtraPessoa = extraPessoalMapper.Create(newExtraPessoa);
                Console.WriteLine("Extra Pessoa: {0} || {1} || {2} || {3}", newExtraPessoa.id, newExtraPessoa.descrição, newExtraPessoa.preçoDia, newExtraPessoa.associado);

                newExtraPessoa.preçoDia = 50;
                extraPessoalMapper.Update(newExtraPessoa);

                Extra deletedExtra = new Extra();
                deletedExtra.id = 2;
                deletedExtra.descrição = "erro";
                deletedExtra.preçoDia = 20;
                deletedExtra.associado = "pessoa";

                extraPessoalMapper.Delete(deletedExtra);
            }*/

            /* ---------- Teste Actividades ---------- */
            /*using (Context context = new Context(connectionString)) {
                ActividadesMapper actividadesMapper = new ActividadesMapper(context);

                foreach(var actividade in actividadesMapper.ReadAll()) {
                    Console.WriteLine("Actividade: {0} || {1} || {2} || {3} || {4} || {5} || {6} || {7}", actividade.nomeParque, actividade.númeroSequencial, actividade.ano, actividade.nome, actividade.descrição, actividade.lotaçãoMáxima, actividade.preçoParticipante, actividade.dataRealização);
                }

                Actividades newActividade = new Actividades();
                newActividade.nomeParque = "Glampinho";
                newActividade.númeroSequencial = 2;
                newActividade.ano = 2017;
                newActividade.nome = "actividade de teste";
                newActividade.descrição = "actividade para teste no c#";
                newActividade.lotaçãoMáxima = 2;
                newActividade.preçoParticipante = 10;
                newActividade.dataRealização = new DateTime(2017, 12, 18, 10, 30, 0);

                newActividade = actividadesMapper.Create(newActividade);
                Console.WriteLine("Actividade: {0} || {1} || {2} || {3} || {4} || {5} || {6} || {7}", newActividade.nomeParque, newActividade.númeroSequencial, newActividade.ano, newActividade.nome, newActividade.descrição, newActividade.lotaçãoMáxima, newActividade.preçoParticipante, newActividade.dataRealização);

                newActividade.preçoParticipante = 50;
                actividadesMapper.Update(newActividade);

                Actividades deleteActividade = new Actividades();
                deleteActividade.nomeParque = "Glampinho";
                deleteActividade.númeroSequencial = 1;
                deleteActividade.ano = 2017;
                deleteActividade.nome = "FUT7";
                deleteActividade.descrição = "Jogo de futebol 7vs7";
                deleteActividade.lotaçãoMáxima = 14;
                deleteActividade.preçoParticipante = 3;
                deleteActividade.dataRealização = new DateTime(2017, 03, 15, 10, 30, 0);

                actividadesMapper.Delete(deleteActividade);
            }*/

            /* --------- Teste EstadaInTime ---------- */
            using(Context context = new Context(connectionString)) {
                ProcUtils procedimentos = new ProcUtils(context);
                Hóspede responsável = new Hóspede();
                responsável.NIF = 112233445;
                responsável.nome = "Teste";
                responsável.morada = "Rua teste";
                responsável.email = "teste@teste.com";
                responsável.númeroIdentificação = 11223344;

                Hóspede hóspede = new Hóspede();
                hóspede.NIF = 566778899;
                hóspede.nome = "Maria";
                hóspede.morada = "Rua 2";
                hóspede.email = "maria@gmail.com";
                hóspede.númeroIdentificação = 55667788;

                Estada estada = new Estada();
                estada.id = 5;
                estada.dataInício = new DateTime(2017, 12, 20, 13, 00, 00);
                estada.dataFim = new DateTime(2017, 12, 25, 13, 00, 00);

                BungalowMapper bungalowMapper = new BungalowMapper(context);
                Bungalow bungalow = bungalowMapper.Read(new Tuple<string, string>("Glampinho", "Rua 7"));

                Extra extraPessoal = new Extra();
                extraPessoal.id = 2;
                extraPessoal.descrição = "teste";
                extraPessoal.preçoDia = 15;
                extraPessoal.associado = "pessoa";

                Extra extraAlojamento = new Extra();
                extraAlojamento.id = 3;
                extraAlojamento.descrição = "metodo";
                extraAlojamento.preçoDia = 20;
                extraAlojamento.associado = "alojamento";

                procedimentos.createEstadaInTime(responsável, hóspede, estada, bungalow, extraPessoal, extraAlojamento);
            }

            /* ---------- Teste Estada ---------- */
            /*using(Context context = new Context(connectionString)) {
                EstadaMapper estadaMapper = new EstadaMapper(context);

                int id = estadaMapper.CreateEstada(1, 5);
                estadaMapper.AddAlojamento("tenda", 4, id);
                estadaMapper.AddHospede(566778899, id);
                estadaMapper.AddExtraAlojamento(3, id);
                estadaMapper.AddExtraEstada(2, id);
            }*/
               /* Estada estada = new Estada();
              
                Hóspede h2 = new Hóspede();
                Hóspede h1 = new Hóspede();
                h1.NIF = 566778899;
                h2.NIF = 112233445;
                Alojamento alojamento = new Alojamento();
                alojamento.tipoAlojamento = "tenda";
                alojamento.númeroMáximoPessoas = 10;
                Extra extra1 = new Extra();
                extra1.id = 3;
                Extra extra2 = new Extra();
                extra2.id = 2;




                int id = estadaMapper.CreateEstada(h2, 5);
                estadaMapper.AddAlojamento(alojamento,id);
                estadaMapper.AddHospede(h1,id);
                estadaMapper.AddExtraAlojamento(extra1, id);
                estadaMapper.AddExtraEstada(extra2, id);*/


            /* hóspedeMapper.InscreverHospede(112233445, 6, "Glampinho", 2017);*/

            /*FaturaMapper faturaMapper = new FaturaMapper(context);
            faturaMapper.finishEstadaWithFactura(3); */


            /*ProcUtils utils = new ProcUtils(context);
                utils.SendEmails(7);

                var result = hóspedeMapper.Delete(deleteHóspede);*/
                /*ProcUtils utils = new ProcUtils(context);

                utils.SendEmails(7);

                utils.ListActividades(Convert.ToDateTime("2016-03-12"), Convert.ToDateTime("2017-03-16"));
                utils.MediaPagamentos(2);

                FaturaRepository repository = new FaturaRepository(context);
                repository.CalcularDespesasHospede(repository.FindFacturas(123456789, Convert.ToDateTime("2017-03-15"), Convert.ToDateTime("2017-10-16"), "Glampinho"), 123456789);
                */

                /*ParqueCampismoMapper p = new ParqueCampismoMapper(context);
                ParqueCampismo parque = new ParqueCampismo();
                parque.nome = "Glampinho";
                p.Delete(parque);*/
            }
    }
}