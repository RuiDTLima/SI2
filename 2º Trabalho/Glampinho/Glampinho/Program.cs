using Glampinho.concrete;
using Glampinho.mapper;
using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Configuration;

namespace Glampinho {
    class Program {
        private static string connectionString = ConfigurationManager.ConnectionStrings["glampinho"].ConnectionString;

        public static void Main(string[] args) {
            while (true) {
                PrintOptions();
                string command = Console.ReadLine();
                switch (command) {
                    case "1":
                        Console.Write("Indique a operação (Create/Delete/Update): ");

                        switch (Console.ReadLine()) {
                            case "Create":
                                CreateHóspede();
                                Console.WriteLine("\nHóspede criado com sucesso.\n");
                                break;

                            case "Delete":
                                DeleteHóspede();
                                Console.WriteLine("\nHóspede eliminado com sucesso.\n");
                                break;

                            case "Update":
                                UpdateHóspede();
                                Console.WriteLine("\nHóspede actualizado com sucesso.\n");
                                break;
                        }
                        break;

                    case "2":
                        Console.Write("Indique a operação (Create/Delete/Update): ");
                        string commandAloj = Console.ReadLine();

                        Console.Write("Sobre um bungalow ou tenda: ");
                        string tipoAlojamento = Console.ReadLine();

                        if (tipoAlojamento.Equals("tenda")) {
                            switch (commandAloj) {
                                case "Create":
                                    CreateTenda();
                                    Console.WriteLine("\nTenda criada com sucesso.\n");
                                    break;
                                case "Delete":
                                    DeleteTenda();
                                    Console.WriteLine("\nTenda eliminada com sucesso.\n");
                                    break;
                                case "Update":
                                    UpdateTenda();
                                    Console.WriteLine("\nTenda actualizada com sucesso.\n");
                                    break;
                            }
                        }
                        else {
                            switch (commandAloj) {
                                case "Create":
                                    CreateBungalow();
                                    Console.WriteLine("\nBungalow criado com sucesso.\n");
                                    break;
                                case "Delete":
                                    DeleteBungalow();
                                    Console.WriteLine("\nBungalow eliminado com sucesso.\n");
                                    break;
                                case "Update":
                                    UpdateBungalow();
                                    Console.WriteLine("\nBungalow actualizado com sucesso.\n");
                                    break;
                            }
                        }
                        break;

                    case "3" :case "4":
                        Console.Write("Indique a operação (Create/Delete/Update): ");
                        
                        switch (Console.ReadLine()) {
                            case "Create":
                                CreateExtra(command);
                                Console.WriteLine("\nExtra criado com sucesso.\n");
                                break;
                            case "Delete":
                                DeleteExtra(command);
                                Console.WriteLine("\nExtra eliminado com sucesso.\n");
                                break;
                            case "Update":
                                UpdateExtra(command);
                                Console.WriteLine("\nExtra actualizado com sucesso.\n");
                                break;
                        }

                        break;
                    case "5":
                        Console.Write("Indique a operação (Create/Delete/Update): ");

                        switch (Console.ReadLine()) {
                            case "Create":
                                CreateActividade();
                                Console.WriteLine("\nActividade criada com sucesso.\n");
                                break;
                            case "Delete":
                                DeleteActividade();
                                Console.WriteLine("\nActividade eliminada com sucesso.\n");
                                break;
                            case "Update":
                                UpdateActividade();
                                Console.WriteLine("\nActividade actualizada com sucesso.\n");
                                break;
                        }

                        break;
                    case "6":
                        CreateEstadaInTime();
                        Console.WriteLine("\nEstada criada com sucesso.\n");
                        break;
                    case "7":
                        InscreverHóspede();
                        Console.WriteLine("\nHóspede inscrito com sucesso.\n");
                        break;
                    case "8":
                        FinishEstadaWithFactura();
                        Console.WriteLine("\nCalculo de factura feito com sucesso.\n");
                        break;
                    case "9":
                        SendEmails();
                        break;
                    case "10":
                        ListarActividades();
                        break;
                    case "11":
                        FindFacturas();
                        break;
                    case "12":
                        DeleteParque();
                        Console.WriteLine("\nParque eliminado com sucesso.\n");
                        break;
                    case "exit":
                        Environment.Exit(0);
                        break;
                }
            }
        }

        private static void PrintOptions() {
            Console.WriteLine("/************************************* Comandos **************************************/");
            Console.WriteLine("1 - Inserir/Remover/Atualizar Hóspede");
            Console.WriteLine("2 - Inserir/Remover/Atualizar Alojamento num Parque");
            Console.WriteLine("3 - Inserir/Remover/Atualizar Extra de Alojamento");
            Console.WriteLine("4 - Inserir/Remover/Atualizar Extra de Pessoa");
            Console.WriteLine("5 - Inserir/Remover/Atualizar Actividade");
            Console.WriteLine("6 - Criar uma estada para um dado período de tempo");
            Console.WriteLine("7 - Inscrever um hóspede numa atividade");
            Console.WriteLine("8 - Pagamento devido por uma estada, com emissão da respetiva fatura");
            Console.WriteLine("9 - Enviar emails a todos os hóspedes responsáveis");
            Console.WriteLine("10 - Listar todas as atividades com lugares disponíveis para um intervalo de datas especificado");
            Console.WriteLine("11 - Obter o total pago por hóspede");
            Console.WriteLine("12 - Eliminar um dos parques");
            Console.WriteLine("exit - Desligar\n");
        }

        private static void CreateHóspede() {
            Hóspede newHóspede = new Hóspede();

            Console.Write("Nome: ");
            newHóspede.nome = Console.ReadLine();

            Console.Write("NIF: ");
            newHóspede.NIF = int.Parse(Console.ReadLine());

            Console.Write("Morada: ");
            newHóspede.morada = Console.ReadLine();

            Console.Write("Email: ");
            newHóspede.email = Console.ReadLine();

            Console.Write("Numero Identificação: ");
            newHóspede.númeroIdentificação = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                HóspedeMapper hóspedeMapper = new HóspedeMapper(context);
                hóspedeMapper.Create(newHóspede);
            }
        }

        private static void DeleteHóspede() {
            Hóspede deleteHóspede = new Hóspede();

            Console.Write("NIF: ");
            deleteHóspede.NIF = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                HóspedeMapper hóspedeMapper = new HóspedeMapper(context);
                hóspedeMapper.Delete(deleteHóspede);
            }
        }

        private static void UpdateHóspede()  {
            Hóspede updateHóspede = new Hóspede();

            Console.Write("Nome: ");
            updateHóspede.nome = Console.ReadLine();

            Console.Write("NIF: ");
            updateHóspede.NIF = int.Parse(Console.ReadLine());

            Console.Write("Morada: ");
            updateHóspede.morada = Console.ReadLine();

            Console.Write("Email: ");
            updateHóspede.email = Console.ReadLine();

            Console.Write("Numero Identificação: ");
            updateHóspede.númeroIdentificação = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                HóspedeMapper hóspedeMapper = new HóspedeMapper(context);
                hóspedeMapper.Update(updateHóspede);
            }
        }

        private static void CreateTenda() {
            Tenda tenda = new Tenda();

            Console.Write("Nome do parque: ");
            tenda.nomeParque = Console.ReadLine();

            Console.Write("Nome: ");
            tenda.nome = Console.ReadLine();

            Console.Write("Localização: ");
            tenda.localização = Console.ReadLine();

            Console.Write("Descrição: ");
            tenda.descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            tenda.preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            tenda.númeroMáximoPessoas = int.Parse(Console.ReadLine());

            Console.Write("Área: ");
            tenda.área = int.Parse(Console.ReadLine());
            
            using (Context context = new Context(connectionString)) {
                TendaMapper tendaMapper = new TendaMapper(context);
                tendaMapper.Create(tenda);
            }
        }

        private static void UpdateTenda() {
            Tenda tenda = new Tenda();

            Console.Write("Nome do parque: ");
            tenda.nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            tenda.localização = Console.ReadLine();

            Console.Write("Descrição: ");
            tenda.descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            tenda.preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            tenda.númeroMáximoPessoas = int.Parse(Console.ReadLine());

            Console.Write("Área: ");
            tenda.área = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                TendaMapper tendaMapper = new TendaMapper(context);
                tendaMapper.Update(tenda);
            }
        }

        private static void DeleteTenda() {
            Tenda tenda = new Tenda();

            Console.Write("Nome do parque: ");
            tenda.nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            tenda.localização = Console.ReadLine();

            using (Context context = new Context(connectionString)) {
                TendaMapper tendaMapper = new TendaMapper(context);
                tendaMapper.Delete(tenda);
            }
        }

        private static void CreateBungalow() {
            Bungalow bungalow = new Bungalow();

            Console.Write("Nome do parque: ");
            bungalow.nomeParque = Console.ReadLine();

            Console.Write("Nome: ");
            bungalow.nome = Console.ReadLine();

            Console.Write("Localização: ");
            bungalow.localização = Console.ReadLine();

            Console.Write("Descrição: ");
            bungalow.descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            bungalow.preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            bungalow.númeroMáximoPessoas = int.Parse(Console.ReadLine());

            Console.Write("Tipologia: ");
            bungalow.tipologia = Console.ReadLine();

            using (Context context = new Context(connectionString)) {
                BungalowMapper bungalowMapper = new BungalowMapper(context);
                bungalowMapper.Create(bungalow);
            }
        }

        private static void UpdateBungalow() {
            Bungalow bungalow = new Bungalow();

            Console.Write("Nome do parque: ");
            bungalow.nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            bungalow.localização = Console.ReadLine();

            Console.Write("Descrição: ");
            bungalow.descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            bungalow.preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            bungalow.númeroMáximoPessoas = int.Parse(Console.ReadLine());

            Console.Write("Tipologia: ");
            bungalow.tipologia = Console.ReadLine();

            using (Context context = new Context(connectionString)) {
                BungalowMapper bungalowMapper = new BungalowMapper(context);
                bungalowMapper.Update(bungalow);
            }
        }

        private static void DeleteBungalow() {
            Bungalow bungalow = new Bungalow();

            Console.Write("Nome do parque: ");
            bungalow.nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            bungalow.localização = Console.ReadLine();

            using (Context context = new Context(connectionString)) {
                BungalowMapper bungalowMapper = new BungalowMapper(context);
                bungalowMapper.Delete(bungalow);
            }
        }

        private static void CreateExtra(string tipoExtra) {
            Extra extra = new Extra();

            Console.Write("Id: ");
            extra.id = int.Parse(Console.ReadLine());

            Console.Write("Descrição: ");
            extra.descrição = Console.ReadLine();

            Console.Write("Preço Dia: ");
            extra.preçoDia = int.Parse(Console.ReadLine());

            if (tipoExtra.Equals("3")) {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "alojamento";

                    ExtraAlojamentoMapper extraAlojamentoMapper = new ExtraAlojamentoMapper(context);
                    extraAlojamentoMapper.Create(extra);
                }
            }
            else {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "pessoa";

                    ExtraPessoalMapper extraPessoalMapper = new ExtraPessoalMapper(context);
                    extraPessoalMapper.Create(extra);
                }
            }
        }

        private static void UpdateExtra(string tipoExtra) {
            Extra extra = new Extra();

            Console.Write("Id: ");
            extra.id = int.Parse(Console.ReadLine());

            Console.Write("Descrição: ");
            extra.descrição = Console.ReadLine();

            Console.Write("Preço Dia: ");
            extra.preçoDia = int.Parse(Console.ReadLine());

            if (tipoExtra.Equals("3")) {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "alojamento";

                    ExtraAlojamentoMapper extraAlojamentoMapper = new ExtraAlojamentoMapper(context);
                    extraAlojamentoMapper.Update(extra);
                }
            }
            else {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "pessoa";
                    ExtraPessoalMapper extraPessoalMapper = new ExtraPessoalMapper(context);
                    extraPessoalMapper.Update(extra);
                }
            }
        }

        private static void DeleteExtra(string tipoExtra) {
            Extra extra = new Extra();

            Console.Write("Id: ");
            extra.id = int.Parse(Console.ReadLine());

            if (tipoExtra.Equals("3")) {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "alojamento";

                    ExtraAlojamentoMapper extraAlojamentoMapper = new ExtraAlojamentoMapper(context);
                    extraAlojamentoMapper.Delete(extra);
                }
            }
            else {
                using (Context context = new Context(connectionString)) {
                    extra.associado = "pessoa";

                    ExtraPessoalMapper extraPessoalMapper = new ExtraPessoalMapper(context);
                    extraPessoalMapper.Delete(extra);
                }
            }
        }

        private static void CreateActividade() {
            Actividades actividade = new Actividades();

            Console.Write("Nome Actividade: ");
            actividade.nome = Console.ReadLine();

            Console.Write("Nome Parque: ");
            actividade.nomeParque = Console.ReadLine();

            Console.Write("Número Sequencial: ");
            actividade.númeroSequencial = int.Parse(Console.ReadLine());

            Console.Write("Descrição: ");
            actividade.descrição = Console.ReadLine();

            Console.Write("Lotação: ");
            actividade.lotaçãoMáxima = int.Parse(Console.ReadLine());

            Console.Write("Preço participante: ");
            actividade.preçoParticipante = int.Parse(Console.ReadLine());

            Console.Write("Data Realização(YYYY-MM-DD HH:MM:SS): ");
            string dataRealização = Console.ReadLine();

            actividade.ano = int.Parse(dataRealização.Substring(0, 4));
            actividade.dataRealização = Convert.ToDateTime(dataRealização);

            using(Context context = new Context(connectionString)) {
                ActividadesMapper actividadesMapper = new ActividadesMapper(context);
                actividadesMapper.Create(actividade);
            }
        }

        private static void UpdateActividade() {
            Actividades actividade = new Actividades();

            Console.Write("Nome Actividade: ");
            actividade.nome = Console.ReadLine();

            Console.Write("Nome Parque: ");
            actividade.nomeParque = Console.ReadLine();

            Console.Write("Número Sequencial: ");
            actividade.númeroSequencial = int.Parse(Console.ReadLine());

            Console.Write("Descrição: ");
            actividade.descrição = Console.ReadLine();

            Console.Write("Lotação: ");
            actividade.lotaçãoMáxima = int.Parse(Console.ReadLine());

            Console.Write("Preço participante: ");
            actividade.preçoParticipante = int.Parse(Console.ReadLine());

            Console.Write("Data Realização(YYYY-MM-DD HH:MM:SS): ");
            string dataRealização = Console.ReadLine();

            actividade.ano = int.Parse(dataRealização.Substring(0, 4));
            actividade.dataRealização = Convert.ToDateTime(dataRealização);

            using (Context context = new Context(connectionString)) {
                ActividadesMapper actividadesMapper = new ActividadesMapper(context);
                actividadesMapper.Update(actividade);
            }
        }

        private static void DeleteActividade() {
            Actividades actividade = new Actividades();
            Console.Write("Nome Parque: ");
            actividade.nomeParque = Console.ReadLine();

            Console.Write("Número Sequencial: ");
            actividade.númeroSequencial = int.Parse(Console.ReadLine());

            Console.Write("Ano(YYYY): ");
            actividade.ano = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                ActividadesMapper actividadesMapper = new ActividadesMapper(context);
                actividadesMapper.Delete(actividade);
            }
        }

        private static void CreateEstadaInTime() {
            Hóspede responsável = new Hóspede();
            Hóspede hóspede = new Hóspede();
            Estada estada = new Estada();
            Extra extraPessoal = new Extra();
            Extra extraAlojamento = new Extra();

            Console.Write("NIF Hóspede Responsável: ");
            responsável.NIF = int.Parse(Console.ReadLine());

            Console.Write("NIF Hóspede Acompanhante: ");
            hóspede.NIF = int.Parse(Console.ReadLine());
            
            Console.Write("Data Inicial da Estada(YYYY-MM-DD HH:MM:SS): ");
            estada.dataInício = Convert.ToDateTime(Console.ReadLine());
            
            Console.Write("Data Final da Estada(YYYY-MM-DD HH:MM:SS): ");
            estada.dataFim = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Tipo de Alojamento(tenda/bungalow): ");
            string tipoAloj = Console.ReadLine();

            Console.Write("Lotação de pessoas: ");
            int lot = int.Parse(Console.ReadLine());

            Console.Write("Identificador extra pessoal: ");
            extraPessoal.id = int.Parse(Console.ReadLine());
            extraPessoal.associado = "pessoa";

            Console.Write("Identificador extra alojamento: ");
            extraAlojamento.id = int.Parse(Console.ReadLine());
            extraAlojamento.associado = "alojamento";

            if (tipoAloj.Equals("tenda")) {
                using (Context context = new Context(connectionString)) {
                    Tenda tenda = new Tenda();
                    tenda.númeroMáximoPessoas = lot;
                    tenda.tipoAlojamento = "tenda";
                    ProcUtils procedimento = new ProcUtils(context);
                    procedimento.createEstadaInTime(responsável, hóspede, estada, tenda, extraPessoal, extraAlojamento);
                }
            }
            else {
                using (Context context = new Context(connectionString)) {
                    Bungalow bungalow = new Bungalow();
                    bungalow.númeroMáximoPessoas = lot;
                    bungalow.tipoAlojamento = "bungalow";
                    ProcUtils procedimento = new ProcUtils(context);
                    procedimento.createEstadaInTime(responsável, hóspede, estada, bungalow, extraPessoal, extraAlojamento);
                }
            }
        }
        
        private static void InscreverHóspede() {
            Hóspede hóspede = new Hóspede();
            Actividades actividade;
            
            Console.Write("NIF Hospede: ");
            hóspede.NIF = int.Parse(Console.ReadLine());

            Console.Write("Nome Parque: ");
            string nomeParq = Console.ReadLine();

            Console.Write("Numero Sequencial: ");
            int numeroSeq = int.Parse(Console.ReadLine());

            Console.Write("Ano(YYYY): ");
            int ano = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                ActividadesMapper actividadesMapper = new ActividadesMapper(context);
                actividade = actividadesMapper.Read(new Tuple<string, int, int>(nomeParq, numeroSeq, ano));
                ProcUtils procedimento = new ProcUtils(context);
                procedimento.InscreverHospede(actividade, hóspede);
            }
        }

        private static void FinishEstadaWithFactura() {
            Estada estada = new Estada();

            Console.Write("ID Estada: ");
            estada.id = int.Parse(Console.ReadLine());
            using(Context context = new Context(connectionString)) {
                ProcUtils procedimento = new ProcUtils(context);
                procedimento.finishEstadaWithFactura(estada);
            }
        }

        private static void SendEmails() {
            List<string> messages;
            Console.Write("Intervalo: ");
            int intervalo = int.Parse(Console.ReadLine());

            using (Context context = new Context(connectionString)) {
                ProcUtils procedimento = new ProcUtils(context);
                messages = procedimento.SendEmails(intervalo);
            }

            Console.WriteLine("\nEmails enviados: \n");

            messages.ForEach((string message) => {
                Console.Write(message);
            });
        }

        private static void ListarActividades()  {
            List<string> actividades;
            Console.Write("Data Inicio(YYYY-MM-DD): ");
            DateTime dataInicio = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Data Fim(YYYY-MM-DD): ");
            DateTime dataFim = Convert.ToDateTime(Console.ReadLine());

            using(Context context = new Context(connectionString)) {
                ProcUtils procedimento = new ProcUtils(context);
                actividades = procedimento.ListarActividades(dataInicio, dataFim);
            }

            Console.WriteLine("\nActividades disponiveis: \n");

            actividades.ForEach((string actividade) => {
                Console.WriteLine(actividade);
            });
        }

        private static void FindFacturas() {
            Hóspede hóspede = new Hóspede();
            ParqueCampismo parque = new ParqueCampismo();

            Tuple<int, int> pair;

            Console.Write("NIF: ");
            hóspede.NIF = int.Parse(Console.ReadLine());

            Console.Write("Data Inicio(YYYY-MM-DD): ");
            DateTime dataInicio = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Data Fim(YYYY-MM-DD): ");
            DateTime dataFim = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Nome Parque: ");
            parque.nome = Console.ReadLine();

            using (Context context = new Context(connectionString)) {
                ProcUtils procedimento = new ProcUtils(context);

                pair = procedimento.FindFacturas(hóspede, dataInicio, dataFim, parque);
            }
            Console.WriteLine("Despedas totais do hóspede com NIF: {0} - {1} Euros\n", pair.Item1, pair.Item2);
        }
        
        private static void DeleteParque() {
            ParqueCampismo parque = new ParqueCampismo();

            Console.Write("Nome Parque: ");
            parque.nome = Console.ReadLine();

            using(Context context = new Context(connectionString)) {
                ProcUtils procedimento = new ProcUtils(context);
                procedimento.DeletePark(parque);
            }
        }
    }
}