using Glampinho.concrete;
using Glampinho.mapper;
using Glampinho.model;
using System;
using System.Configuration;

namespace Glampinho {
    class Program {

        private static string connectionString = ConfigurationManager.ConnectionStrings["glampinho"].ConnectionString;

        static void Main(string[] args) {



            Console.WriteLine("1 - Inserir/Remover/Atualizar Hóspede");
            Console.WriteLine("2 - Inserir/Remover/Atualizar Alojamento num Parque");
            Console.WriteLine("3 - Inserir/Remover/Atualizar Extra de Alojamento");
            Console.WriteLine("4 - Inserir/Remover/Atualizar Extra de Pessoa");
            Console.WriteLine("5 - Inserir/Remover/Atualizar Actividade");
            Console.WriteLine("6 - Criar uma estada para um dado período de tempo");
            Console.WriteLine("7 - Inscrever um hóspede numa atividade. j ");
            Console.WriteLine("8 - Pagamento devido por uma estada, com emissão da respetiva fatura");
            Console.WriteLine("9 - Enviar emails a todos os hóspedes responsáveis");
            Console.WriteLine("10 - Listar todas as atividades com lugares disponíveis para um intervalo de datas especificado");


            using (Context context = new Context(connectionString)) {
                while (true)
                {
                    
                    switch (Console.ReadLine())
                    {
                        case "1":
                            Console.WriteLine("Indique a operação:");
                            string commandHospede = Console.ReadLine();

                            Console.WriteLine("Nome:");
                            string nome = Console.ReadLine();
                            Console.WriteLine("NIF:");
                            string nif = Console.ReadLine();
                            Console.WriteLine("Morada:");
                            string morada = Console.ReadLine();
                            Console.WriteLine("Email:");
                            string email = Console.ReadLine();
                            Console.WriteLine("Numero Identificação:");
                            string numId = Console.ReadLine();
                            alineaC(context, nome, Int32.Parse(nif), morada, email, Int32.Parse(numId), commandHospede);
                            break;

                        case "2":
                            /*Console.WriteLine("Indique a operação:");
                            string command = Console.ReadLine();

                            Console.WriteLine("Nome:");
                            string nome = Console.ReadLine();
                            Console.WriteLine("NIF:");
                            string nif = Console.ReadLine();
                            Console.WriteLine("Morada:");
                            string morada = Console.ReadLine();
                            Console.WriteLine("Email:");
                            string email = Console.ReadLine();
                            Console.WriteLine("Numero Identificação:");
                            string numId = Console.ReadLine();
                            alineaC(context, nome, Int32.Parse(nif), morada, email, Int32.Parse(numId), command);*/
                            break;
                        case "3":
                            Console.WriteLine("Indique a operação:");
                            string commandExtraAloj = Console.ReadLine();

                            Console.WriteLine("Id:");
                            string id = Console.ReadLine();
                            Console.WriteLine("Descrição:");
                            string descrição = Console.ReadLine();
                            Console.WriteLine("Preço Dia:");
                            string preçoDia = Console.ReadLine();
                            Console.WriteLine("Associado:");
                            string associado = Console.ReadLine();
                            alineaE(context,  Int32.Parse(id),  descrição, Int32.Parse(preçoDia),  associado, commandExtraAloj);
                            break;
                        case "4":
                            Console.WriteLine("Indique a operação:");
                            string commandExtraPessoal = Console.ReadLine();

                            Console.WriteLine("Id:");
                            string id1 = Console.ReadLine();
                            Console.WriteLine("Descrição:");
                            string descrição1 = Console.ReadLine();
                            Console.WriteLine("Preço Dia:");
                            string preçoDia1 = Console.ReadLine();
                            Console.WriteLine("Associado:");
                            string associado1 = Console.ReadLine();
                            alineaF(context, Int32.Parse(id1), descrição1, Int32.Parse(preçoDia1), associado1, commandExtraPessoal);
                            break;
                        case "5":
                            Console.WriteLine("Indique a operação:");
                            string commandAct = Console.ReadLine();
                            Console.WriteLine("Nome Actividade:");
                            string nomeAct = Console.ReadLine();
                            Console.WriteLine("Nome Parque:");
                            string nomeParque = Console.ReadLine();
                            Console.WriteLine("Num Sequencial:");
                            string númeroSequencial = Console.ReadLine();
                            Console.WriteLine("Descrição:");
                            string descriçãoAct = Console.ReadLine();
                            Console.WriteLine("Lotação:");
                            string lotaçãoMáxima = Console.ReadLine();
                            Console.WriteLine("Preço participante:");
                            string preçoParticipante = Console.ReadLine();
                            Console.WriteLine("Data Realização");
                            string dataRealização = Console.ReadLine();
                            alineaG(context,nomeParque, Int32.Parse(númeroSequencial), nomeAct, descriçãoAct, Int32.Parse(lotaçãoMáxima), Int32.Parse(preçoParticipante),Convert.ToDateTime(dataRealização) ,commandAct);
                            break;
                        case "6":
                            
                            break;
                        case "7":
                            Console.WriteLine("NIF Hospede:");
                            string nifHospede = Console.ReadLine();
                            Console.WriteLine("Numero Sequencial:");
                            string numeroSeq = Console.ReadLine();
                            Console.WriteLine("Nome Parque:");
                            string nomeParq = Console.ReadLine();
                            Console.WriteLine("Ano:");
                            string ano = Console.ReadLine();
                            alineaI(context, Int32.Parse(nifHospede), Int32.Parse(numeroSeq), Int32.Parse(ano), nomeParq);
                            break;
                        case "8":
                            Console.WriteLine("ID Estada:");
                            string idEstada = Console.ReadLine();
                            alineaJ(context, Int32.Parse(idEstada));
                            break;
                        case "9":
                            Console.WriteLine("Intervalo:");
                            string intervalo = Console.ReadLine();
                            alineaK(context, Int32.Parse(intervalo));
                            break;
                        case "10":
                            Console.WriteLine("Data Inicio(yyyy-MM-dd):");
                            string dataInicio = Console.ReadLine();
                            Console.WriteLine("Data Fim(yyyy-MM-dd):");
                            string dataFim = Console.ReadLine();
                            alineaL(context, Convert.ToDateTime(dataInicio), Convert.ToDateTime(dataFim));
                            break;
                        default:
                            Console.WriteLine("Fechando aplicação.");
                            Environment.Exit(0);
                            break;
                    }
                }
            }

            void alineaC(Context ctx, string nome, int nif, string morada, string email, int numId, string command)
            {
                HóspedeMapper hóspedeMapper = new HóspedeMapper(ctx);
                Hóspede newHóspede = new Hóspede();
                newHóspede.nome = nome;
                newHóspede.NIF = nif;
                newHóspede.morada = morada;
                newHóspede.email = email;
                newHóspede.númeroIdentificação = numId;
                
                switch (command)
                {
                    case "create":
                        newHóspede = hóspedeMapper.Create(newHóspede);
                        break;
                    case "delete":
                        newHóspede = hóspedeMapper.Delete(newHóspede);
                        break;
                    case "update":
                        newHóspede = hóspedeMapper.Update(newHóspede);
                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaE(Context ctx, int id, string descrição, int preçoDia, string associado, string command)
            {
                ExtraAlojamentoMapper extraMapper = new ExtraAlojamentoMapper(ctx);
                Extra extra = new Extra();
                extra.id = id;
                extra.descrição = descrição;
                extra.preçoDia = preçoDia;
                extra.associado = associado;

                switch (command)
                {
                    case "create":
                        extra = extraMapper.Create(extra);
                        break;
                    case "delete":
                        extra = extraMapper.Delete(extra);
                        break;
                    case "update":
                        extra = extraMapper.Update(extra);
                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaF(Context ctx, int id, string descrição, int preçoDia, string associado, string command)
                {
                    ExtraPessoalMapper extraMapper = new ExtraPessoalMapper(ctx);
                    Extra extra = new Extra();
                    extra.id = id;
                    extra.descrição = descrição;
                    extra.preçoDia = preçoDia;
                    extra.associado = associado;

                    switch (command)
                    {
                        case "create":
                            extra = extraMapper.Create(extra);
                            break;
                        case "delete":
                            extra = extraMapper.Delete(extra);
                            break;
                        case "update":
                            extra = extraMapper.Update(extra);
                            break;
                        default:
                            throw new Exception("Error");
                    }
                }
            void alineaG(Context ctx, string nomeParque, int númeroSequencial, string nome,string descrição, int lotaçãoMáxima, int preçoParticipante, DateTime dataRealização, string command)
            {
                ActividadesMapper actMapper = new ActividadesMapper(ctx);
                Actividades actividade = new Actividades();
                actividade.nome = nome;
                actividade.nomeParque = nomeParque;
                actividade.númeroSequencial = númeroSequencial;
                actividade.descrição = descrição;
                actividade.lotaçãoMáxima = lotaçãoMáxima;
                actividade.preçoParticipante = preçoParticipante;
                actividade.dataRealização = dataRealização;

                switch (command)
                {
                    case "create":
                        actividade = actMapper.Create(actividade);
                        break;
                    case "delete":
                        actividade = actMapper.Delete(actividade);
                        break;
                    case "update":
                        actividade = actMapper.Update(actividade);
                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaH(Context ctx, int id, string descrição, int preçoDia, string associado, string command) { } //TODO!!!
            void alineaI(Context ctx, int nifHospede, int numeroSeq, int ano,string nomeParq)
            {
                HóspedeMapper hóspedeMapper = new HóspedeMapper(ctx);
                Hóspede h = hóspedeMapper.Read(nifHospede);

                ActividadesMapper actividadesMapper = new ActividadesMapper(ctx);
                Actividades a = actividadesMapper.Read(numeroSeq,ano,nomeParq);

                actividadesMapper.InscreverHospede(a,h);
                Console.WriteLine("Hóspede inscrito na atividade " + a.nome);
            }
            void alineaJ(Context ctx, int idEstada)
            {
                FaturaMapper faturaMapper = new FaturaMapper(ctx);
                Factura f = new Factura();
                f.id = idEstada;
                faturaMapper.finishEstadaWithFactura(f);
                Console.WriteLine("Factura emitida.");
            }
            void alineaK(Context ctx, int intervalo)
            {
                ProcUtils utils = new ProcUtils(ctx);
                utils.SendEmails(intervalo);
            }
            void alineaL(Context ctx, DateTime dataInicio, DateTime dataFim)
            {
                ProcUtils utils = new ProcUtils(ctx);
                utils.ListActividades(dataInicio, dataFim);
            }


            }
        }
    }