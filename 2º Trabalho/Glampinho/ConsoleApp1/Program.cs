using ConsoleApp1;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

namespace Glampinho {
    class Program {
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
                                        UpdateAlojamento();
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
                                        UpdateAlojamento();
                                        Console.WriteLine("\nBungalow actualizado com sucesso.\n");
                                        break;
                                }
                            }
                            break;

                        case "3":
                        case "4":
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

            using (var context = new GlampinhoEF()) {
                context.Hóspede.Add(newHóspede);
                context.SaveChanges();
            }
        }
        
        private static void DeleteHóspede() {
            int NIF;

            Console.Write("NIF: ");
            NIF = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.deleteHospede(NIF);
            }
        }

        private static void UpdateHóspede() {
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

            using (var context = new GlampinhoEF()) {
                context.Hóspede.Attach(updateHóspede);

                var entry = context.Entry(updateHóspede);
                entry.Property(e => e.nome).IsModified = true;
                entry.Property(e => e.morada).IsModified = true;
                entry.Property(e => e.email).IsModified = true;
                entry.Property(e => e.númeroIdentificação).IsModified = true;
                entry.Property(e => e.NIF).IsModified = true;
                context.SaveChanges();
            }
        }

        private static void CreateTenda() {
            string nomeParque, nome, localização, descrição;
            int preçoBase, área;
            byte lotação;

            Console.Write("Nome do parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Nome: ");
            nome = Console.ReadLine();

            Console.Write("Localização: ");
            localização = Console.ReadLine();

            Console.Write("Descrição: ");
            descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            lotação = byte.Parse(Console.ReadLine());

            Console.Write("Área: ");
            área = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.InsertAlojamentoTenda(nomeParque, nome, localização, descrição, preçoBase, lotação, área);
            }
        }

        private static void DeleteTenda() {
            string nomeParque, localização;

            Console.Write("Nome do parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            localização = Console.ReadLine();

            using (var context = new GlampinhoEF()) {
                context.deleteAlojamento(localização, nomeParque);
            }
        }

        private static void CreateBungalow() {
            string nomeParque, nome, localização, descrição, tipologia;
            int preçoBase;
            byte lotação;

            Console.Write("Nome do parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Nome: ");
            nome = Console.ReadLine();

            Console.Write("Localização: ");
            localização = Console.ReadLine();

            Console.Write("Descrição: ");
            descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            lotação = byte.Parse(Console.ReadLine());

            Console.Write("Tipologia: ");
            tipologia = Console.ReadLine();

            using (var context = new GlampinhoEF()) {
                context.InsertAlojamentoBungalow(nomeParque, nome, localização, descrição, preçoBase, lotação, tipologia);
            }
        }

        private static void UpdateAlojamento() {
            string descrição, nomeParque, localização;
            int preçoBase;
            byte númeroMáximoPessoas;

            Console.Write("Nome do parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            localização = Console.ReadLine();

            Console.Write("Descrição: ");
            descrição = Console.ReadLine();

            Console.Write("Preço Base: ");
            preçoBase = int.Parse(Console.ReadLine());

            Console.Write("Número Máximo de Pessoas: ");
            númeroMáximoPessoas = byte.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.UpdateAlojamento(preçoBase, númeroMáximoPessoas, descrição, nomeParque, localização);
            }
        }

        private static void DeleteBungalow() {
            string nomeParque, localização;

            Console.Write("Nome do parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Localização: ");
            localização = Console.ReadLine();

            using (var context = new GlampinhoEF()) {
                context.deleteAlojamento(localização, nomeParque);
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
                using (var context = new GlampinhoEF()) {
                    extra.associado = "alojamento";

                    context.Extra.Add(extra);
                    context.SaveChanges();
                }
            }
            else {
                using (var context = new GlampinhoEF()) {
                    extra.associado = "pessoa";

                    context.Extra.Add(extra);
                    context.SaveChanges();
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
                using (var context = new GlampinhoEF()) {
                    extra.associado = "alojamento";

                    context.Extra.Attach(extra);

                    var entry = context.Entry(extra);
                    entry.Property(e => e.descrição).IsModified = true;
                    entry.Property(e => e.preçoDia).IsModified = true;
                    entry.Property(e => e.associado).IsModified = true;
                    context.SaveChanges();
                }
            }
            else {
                using (var context = new GlampinhoEF()) {
                    extra.associado = "pessoa";

                    context.Extra.Attach(extra);

                    var entry = context.Entry(extra);
                    entry.Property(e => e.descrição).IsModified = true;
                    entry.Property(e => e.preçoDia).IsModified = true;
                    entry.Property(e => e.associado).IsModified = true;
                    context.SaveChanges();
                }
            }
        }

        private static void DeleteExtra(string tipoExtra) {
            int id;

            Console.Write("Id: ");
            id = int.Parse(Console.ReadLine());

            if (tipoExtra.Equals("3")) {
                using (var context = new GlampinhoEF()) {
                    context.deleteExtra(id);
                }
            }
            else {
                using (var context = new GlampinhoEF()) {
                    context.deleteExtraPessoa(id);
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

            using (var context = new GlampinhoEF()) {
                context.Actividades.Add(actividade);
                context.SaveChanges();
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

            using (var context = new GlampinhoEF()) {
                context.Actividades.Attach(actividade);

                var entry = context.Entry(actividade);
                entry.Property(e => e.descrição).IsModified = true;
                entry.Property(e => e.nome).IsModified = true;
                entry.Property(e => e.lotaçãoMáxima).IsModified = true;
                entry.Property(e => e.preçoParticipante).IsModified = true;
                entry.Property(e => e.dataRealização).IsModified = true;
                context.SaveChanges();
            }
        }

        private static void DeleteActividade() {
            string nomeParque;
            int númeroSequencial, ano;
            Console.Write("Nome Parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Número Sequencial: ");
            númeroSequencial = int.Parse(Console.ReadLine());

            Console.Write("Ano(YYYY): ");
            ano = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.deleteAtividades(nomeParque, númeroSequencial, ano);
            }
        }

        private static void CreateEstadaInTime() {
            string tipoAloj;
            int NIFResponsável, NIFHóspede, tempoEstada, idExtraPessoal, idExtraAlojamento;
            byte lotação;
            DateTime dataInício, dataFim;

            Console.Write("NIF Hóspede Responsável: ");
            NIFResponsável = int.Parse(Console.ReadLine());

            Console.Write("NIF Hóspede Acompanhante: ");
            NIFHóspede = int.Parse(Console.ReadLine());

            Console.Write("Data Inicial da Estada(YYYY-MM-DD HH:MM:SS): ");
            dataInício = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Data Final da Estada(YYYY-MM-DD HH:MM:SS): ");
            dataFim = Convert.ToDateTime(Console.ReadLine());

            tempoEstada = dataFim.Subtract(dataInício).Days;

            Console.Write("Tipo de Alojamento(tenda/bungalow): ");
            tipoAloj = Console.ReadLine();

            Console.Write("Lotação de pessoas: ");
            lotação = byte.Parse(Console.ReadLine());

            Console.Write("Identificador extra pessoal: ");
            idExtraPessoal = int.Parse(Console.ReadLine());

            Console.Write("Identificador extra alojamento: ");
            idExtraAlojamento = int.Parse(Console.ReadLine());
            
            using (var context = new GlampinhoEF()) {
                context.createEstadaInTime(NIFResponsável, NIFHóspede, tempoEstada, tipoAloj, lotação, idExtraPessoal, idExtraAlojamento);
            }
        }

        private static void InscreverHóspede() {
            int NIF, numeroSequencial, ano;
            string nomeParque;

            Console.Write("NIF Hospede: ");
            NIF = int.Parse(Console.ReadLine());

            Console.Write("Nome Parque: ");
            nomeParque = Console.ReadLine();

            Console.Write("Numero Sequencial: ");
            numeroSequencial = int.Parse(Console.ReadLine());

            Console.Write("Ano(YYYY): ");
            ano = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.inscreverHóspede(NIF, numeroSequencial, nomeParque, ano);
            }
        }

        private static void FinishEstadaWithFactura() {
            int idEstada;

            Console.Write("ID Estada: ");
            idEstada = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                context.finishEstadaWithFactura(idEstada);
            }
        }

        private static void SendEmails() {
            List<string> messages;
            Console.Write("Intervalo: ");
            int intervalo = int.Parse(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                messages = context.SendEmails1(intervalo).ToList();
            }

            Console.WriteLine("\nEmails enviados: \n");

            messages.ForEach((string message) => {
                Console.Write(message);
            });
        }

        private static void ListarActividades() {
            Console.Write("Data Inicio(YYYY-MM-DD): ");
            DateTime dataInicio = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Data Fim(YYYY-MM-DD): ");
            DateTime dataFim = Convert.ToDateTime(Console.ReadLine());

            using (var context = new GlampinhoEF()) {
                var actividades = context.listarAtividades(dataInicio, dataFim);
                Console.WriteLine("\nActividades disponiveis: \n");

                string output = "";

                foreach (var a in actividades) {
                    output += "Nome: " + a.nome + " Descrição: " + a.descrição + "\n";
                }
                Console.WriteLine(output);
            }
        }

        private static void FindFacturas() {
            int NIF, total = 0;
            string nomeParque;
            DateTime dataInicio, dataFim;

            List<int> data;

            Console.Write("NIF: ");
            NIF = int.Parse(Console.ReadLine());

            Console.Write("Data Inicio(YYYY-MM-DD): ");
            dataInicio = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Data Fim(YYYY-MM-DD): ");
            dataFim = Convert.ToDateTime(Console.ReadLine());

            Console.Write("Nome Parque: ");
            nomeParque = Console.ReadLine();

            using (var context = new GlampinhoEF()) { 
                data = context.Database.SqlQuery<int>("SELECT preçoTotal FROM Factura INNER JOIN (\n" +
                    "SELECT idFactura FROM Estada INNER JOIN(\n" +
                    "SELECT A.id FROM HóspedeEstada INNER JOIN(\n" +
                    "SELECT Distinct id FROM ParqueCampismo INNER JOIN AlojamentoEstada ON ParqueCampismo.nome=@p0 )AS A ON HóspedeEstada.id=A.id and HóspedeEstada.NIF=@p1 ) AS B ON B.id=Estada.id and Estada.dataInício between @p2 and @p3)AS C ON Factura.id = C.idFactura",
                    nomeParque, NIF, dataInicio, dataFim).ToList();
            }
            
            foreach (var custo in data) {
                total += custo;
            }

            Console.WriteLine("Despedas totais do hóspede com NIF: {0} - {1} Euros\n", NIF, total);
        }

        private static void DeleteParque() {
            string nomeParque;
            List<int> hóspedes, estadas;
            ParqueCampismo parque = new ParqueCampismo();

            Console.Write("Nome Parque: ");
            nomeParque = Console.ReadLine();

            parque.nome = nomeParque;

            using (var context = new GlampinhoEF()) {
                hóspedes = context.Database.SqlQuery<int>(
                "SELECT DISTINCT NIF FROM HóspedeEstada \n" +
                 "EXCEPT\n" +
                 "SELECT DISTINCT NIF FROM HóspedeEstada INNER JOIN ( SELECT id FROM AlojamentoEstada WHERE nomeParque<>@p0 ) AS A ON A.id=HóspedeEstada.id", nomeParque).ToList();
            }

            hóspedes.ForEach((hóspede) => {
                using (var context = new GlampinhoEF()) {
                    context.deleteHospede(hóspede);
                }
            });

            using(var context = new GlampinhoEF()) {
                estadas = context.Database.SqlQuery<int>(
                "SELECT A.id FROM Estada INNER JOIN(SELECT * FROM AlojamentoEstada WHERE nomeParque = @p0) AS A ON Estada.id = A.id", nomeParque).ToList();

                context.Entry(parque).State = EntityState.Deleted;
                context.SaveChanges();
            }

            estadas.ForEach((estadaId) =>{
                Estada estada = new Estada();
                estada.id = estadaId;

                using (var context = new GlampinhoEF()) {
                    context.Entry(estada).State = EntityState.Deleted;
                    context.SaveChanges();
                }
            });
        }
    }
}