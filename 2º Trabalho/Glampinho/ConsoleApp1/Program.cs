
using ConsoleApp1;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho
{
    class App
    {
        static void Main(string[] args)
        {



            Console.WriteLine("1 - Inserir/Remover/Atualizar Hóspede");
            Console.WriteLine("2 - Inserir/Remover/Atualizar Alojamento num Parque");
            Console.WriteLine("3 - Inserir/Remover/Atualizar Extra de Alojamento");
            Console.WriteLine("4 - Inserir/Remover/Atualizar Extra de Pessoa");
            Console.WriteLine("5 - Inserir/Remover/Atualizar Actividade");
            Console.WriteLine("6 - Criar uma estada para um dado período de tempo");
            Console.WriteLine("7 - Inscrever um hóspede numa atividade.");
            Console.WriteLine("8 - Pagamento devido por uma estada, com emissão da respetiva fatura");
            Console.WriteLine("9 - Enviar emails a todos os hóspedes responsáveis");
            Console.WriteLine("10 - Listar todas as atividades com lugares disponíveis para um intervalo de datas especificado");

            using (var db = new GlampinhoEF())
            {
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
                            alineaC(db, nome, Int32.Parse(nif), morada, email, Int32.Parse(numId), commandHospede);
                            break;

                        /*case "2":
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
                            alineaC(context, nome, Int32.Parse(nif), morada, email, Int32.Parse(numId), command);
                            break;*/
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
                            alineaE(db, Int32.Parse(id), descrição, Int32.Parse(preçoDia), associado, commandExtraAloj);
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
                            alineaF(db, Int32.Parse(id1), descrição1, Int32.Parse(preçoDia1), associado1, commandExtraPessoal);
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
                            alineaG(db, nomeParque, Int32.Parse(númeroSequencial), nomeAct, descriçãoAct, Int32.Parse(lotaçãoMáxima), Int32.Parse(preçoParticipante), Convert.ToDateTime(dataRealização), commandAct);
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
                            alineaI(db, Int32.Parse(nifHospede), Int32.Parse(numeroSeq), Int32.Parse(ano), nomeParq);
                            break;
                        case "8":
                            Console.WriteLine("ID Estada:");
                            string idEstada = Console.ReadLine();
                            alineaJ(db, Int32.Parse(idEstada));
                            break;
                        case "9":
                            Console.WriteLine("Intervalo:");
                            string intervalo = Console.ReadLine();
                            alineaK(db, Int32.Parse(intervalo));
                            break;
                        case "10":
                            Console.WriteLine("Data Inicio(yyyy-MM-dd):");
                            string dataInicio = Console.ReadLine();
                            Console.WriteLine("Data Fim(yyyy-MM-dd):");
                            string dataFim = Console.ReadLine();
                            alineaL(db, Convert.ToDateTime(dataInicio), Convert.ToDateTime(dataFim));
                            break;
                        default:
                            Console.WriteLine("Fechando aplicação.");
                            Environment.Exit(0);
                            break;
                    }
                }
            }
            void alineaC(GlampinhoEF db, string nome, int nif, string morada, string email, int numId, string command)
            {


                var newHóspede = new Hóspede
                {
                    nome = nome,
                    NIF = nif,
                    morada = morada,
                    email = email,
                    númeroIdentificação = numId
                };


                switch (command)
                {
                    case "create":
                        db.Hóspede.Add(newHóspede);
                        db.SaveChanges();
                        break;
                    case "delete":

                        db.Entry(newHóspede).State = EntityState.Deleted;
                        db.SaveChanges();
                        break;
                    case "update":

                        //duas formas diferentes de fazer
                        /*Hóspede hosp = db.Hóspede.First(i => i.NIF == nif);
                        hosp.morada = morada;
                        hosp.nome = nome;
                        hosp.númeroIdentificação = numId;
                        hosp.email = email;

                        db.SaveChanges();*/

                        db.Hóspede.Attach(newHóspede);
                        var entry = db.Entry(newHóspede);
                        entry.Property(e => e.nome).IsModified = true;
                        entry.Property(e => e.morada).IsModified = true;
                        entry.Property(e => e.email).IsModified = true;
                        entry.Property(e => e.númeroIdentificação).IsModified = true;
                        entry.Property(e => e.NIF).IsModified = true;
                        db.SaveChanges();

                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaE(GlampinhoEF db, int id, string descrição, int preçoDia, string associado, string command)
            {


                var newExtraAloj = new Extra
                {
                    id = id,
                    descrição = descrição,
                    preçoDia = preçoDia,
                    associado = associado,
                };
                switch (command)
                {
                    case "create":
                        db.Extra.Add(newExtraAloj);
                        db.SaveChanges();
                        break;
                    case "delete":

                        db.Entry(newExtraAloj).State = EntityState.Deleted;
                        db.SaveChanges();
                        break;
                    case "update":
                        db.Extra.Attach(newExtraAloj);
                        var entry = db.Entry(newExtraAloj);
                        entry.Property(e => e.descrição).IsModified = true;
                        entry.Property(e => e.preçoDia).IsModified = true;
                        entry.Property(e => e.associado).IsModified = true;
                        db.SaveChanges();

                        break;
                    default:
                        throw new Exception("Error");
                }



            }
            void alineaF(GlampinhoEF db, int id, string descrição, int preçoDia, string associado, string command)
            {
                var newExtraAloj = new Extra
                {
                    id = id,
                    descrição = descrição,
                    preçoDia = preçoDia,
                    associado = associado,
                };
                switch (command)
                {
                    case "create":
                        db.Extra.Add(newExtraAloj);
                        db.SaveChanges();
                        break;
                    case "delete":

                        db.Entry(newExtraAloj).State = EntityState.Deleted;
                        db.SaveChanges();
                        break;
                    case "update":
                        db.Extra.Attach(newExtraAloj);
                        var entry = db.Entry(newExtraAloj);
                        entry.Property(e => e.descrição).IsModified = true;
                        entry.Property(e => e.preçoDia).IsModified = true;
                        entry.Property(e => e.associado).IsModified = true;
                        db.SaveChanges();

                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaG(GlampinhoEF db, string nomeParque, int númeroSequencial, string nome, string descrição, int lotaçãoMáxima, int preçoParticipante, DateTime dataRealização, string command)
            {

                var newActividade = new Actividades
                {
                    nome = nome,
                    nomeParque = nomeParque,
                    númeroSequencial = númeroSequencial,
                    descrição = descrição,
                    lotaçãoMáxima = lotaçãoMáxima,
                    preçoParticipante = preçoParticipante,
                    dataRealização = dataRealização
                };

                switch (command)
                {
                    case "create":
                        db.Actividades.Add(newActividade);
                        db.SaveChanges();
                        break;
                    case "delete":
                        db.Entry(newActividade).State = EntityState.Deleted;
                        db.SaveChanges();
                        break;
                    case "update":
                        db.Actividades.Attach(newActividade);
                        var entry = db.Entry(newActividade);
                        entry.Property(e => e.descrição).IsModified = true;
                        entry.Property(e => e.lotaçãoMáxima).IsModified = true;
                        entry.Property(e => e.preçoParticipante).IsModified = true;
                        entry.Property(e => e.dataRealização).IsModified = true;
                        db.SaveChanges();

                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaI(GlampinhoEF db, int nifHospede, int numeroSeq, int ano, string nomeParq)
            {
                var a = db.inscreverHóspede(nifHospede, numeroSeq, nomeParq, ano);
            }
            void alineaH(GlampinhoEF db, int id, string descrição, int preçoDia, string associado, string command) { }
            void alineaJ(GlampinhoEF db, int idEstada)
            {
                db.finishEstadaWithFactura(idEstada);
                Console.WriteLine("Factura emitida.");
            }
            void alineaK(GlampinhoEF db, int intervalo)
            {

                ObjectParameter output = new ObjectParameter("text", typeof(int));
                db.SendEmails(intervalo, output);
                Console.WriteLine(output.Value);
            }
            void alineaL(GlampinhoEF db, DateTime dataInicio, DateTime dataFim)
            {
                var act = db.listarAtividades(dataInicio, dataFim);
                string output = "";
                
               
                    foreach (var a in act)
                    {
                        output += "Nome: " + a.nome + " Descrição: " + a.descrição;
                    }
                if(output=="")Console.WriteLine("Não existem atividades a listar no intervalo especificado.");
                else Console.WriteLine(output);
               
            }
        }

    }
}
