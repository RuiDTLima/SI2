
using ConsoleApp1;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
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
            Console.WriteLine("11 - Obter o total pago por hóspede");
            Console.WriteLine("12 - Eliminar um dos parques ");

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
                            Console.WriteLine("Hóspede Criado.");
                            Console.WriteLine("");
                            break;

                        case "2":
                            Console.WriteLine("Indique o tipo de alojamento a inserir ( bungalow/tenda ) :");
                            string tipo = Console.ReadLine();
                            Console.WriteLine("Nome do Parque:");
                            string nomeParque = Console.ReadLine();
                            Console.WriteLine("Nome do Alojamento:");
                            string nomeAloj = Console.ReadLine();
                            Console.WriteLine("Localização:");
                            string localização = Console.ReadLine();
                            Console.WriteLine("Descrição:");
                            string descrição = Console.ReadLine();
                            Console.WriteLine("Preço Base:");
                            string preçoBase = Console.ReadLine();
                            Console.WriteLine("Número Máximo de pessoas:");
                            string númeroMáximoPessoas = Console.ReadLine();
                            string area = "";
                            string tipologia = "";
                            if (tipo == "tenda")
                            {
                                Console.WriteLine("Area:");
                                 area = Console.ReadLine();
                            }
                            else if (tipo == "bungalow")
                            {
                                Console.WriteLine("Tipologia:");
                                 tipologia = Console.ReadLine();
                            }
                            
                            alineaD(db,nomeParque, nomeAloj,localização,descrição,Int32.Parse(preçoBase), Int32.Parse(númeroMáximoPessoas), tipo, Int32.Parse(area), tipologia);
                            Console.WriteLine("Criado Alojamento do tipo "+tipo);
                            Console.WriteLine("");
                            break;
                        case "3":
                            Console.WriteLine("Indique a operação:");
                            string commandExtraAloj = Console.ReadLine();

                            Console.WriteLine("Id:");
                            string id = Console.ReadLine();
                            Console.WriteLine("Descrição:");
                            string descriçãoExtra = Console.ReadLine();
                            Console.WriteLine("Preço Dia:");
                            string preçoDia = Console.ReadLine();
                            Console.WriteLine("Associado:");
                            string associado = Console.ReadLine();
                            alineaE(db, Int32.Parse(id), descriçãoExtra, Int32.Parse(preçoDia), associado, commandExtraAloj);
                            Console.WriteLine("Criado Extra de Alojamento.");
                            Console.WriteLine("");
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
                            Console.WriteLine("Criado Extra de Pessoa.");
                            Console.WriteLine("");
                            break;
                        case "5":
                            Console.WriteLine("Indique a operação:");
                            string commandAct = Console.ReadLine();
                            Console.WriteLine("Nome Actividade:");
                            string nomeAct = Console.ReadLine();
                            Console.WriteLine("Nome Parque:");
                            string nomeParq = Console.ReadLine();
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
                            Console.WriteLine("Ano");
                            string ano = Console.ReadLine();
                            alineaG(db, nomeParq, Int32.Parse(númeroSequencial), nomeAct, descriçãoAct, Int32.Parse(lotaçãoMáxima), Int32.Parse(preçoParticipante), Convert.ToDateTime(dataRealização), Int32.Parse(ano), commandAct);
                            Console.WriteLine("Atividade "+nomeAct+" criada.");
                            Console.WriteLine("");
                            break;
                        case "6":
                            Console.WriteLine("NIF Hóspede Responsável:");
                            string nifResp = Console.ReadLine();
                            Console.WriteLine("NIF Hóspede Acompanhante:");
                            string nifHosp = Console.ReadLine();
                            Console.WriteLine("Duração da estada (em dias):");
                            string tempoEstada = Console.ReadLine();
                            Console.WriteLine("Tipo de Alojamento(tenda/bungalow) :");
                            string tipoAloj = Console.ReadLine();
                            Console.WriteLine("Lotação de pessoas:");
                            string lot = Console.ReadLine();
                            Console.WriteLine("Identificador extra pessoal:");
                            string idExtraPessoal = Console.ReadLine();
                            Console.WriteLine("Identificador extra alojamento:");
                            string idExtrAloj = Console.ReadLine();
                            alineaH(db, Int32.Parse(nifResp), Int32.Parse(nifHosp), Int32.Parse(tempoEstada), tipoAloj, Int32.Parse(lot), Int32.Parse(idExtraPessoal), Int32.Parse(idExtrAloj));
                            Console.WriteLine("");
                            break;
                        case "7":
                            Console.WriteLine("NIF Hospede:");
                            string nifHospede = Console.ReadLine();
                            Console.WriteLine("Numero Sequencial:");
                            string numeroSeq = Console.ReadLine();
                            Console.WriteLine("Nome Parque:");
                            string nomParq = Console.ReadLine();
                            Console.WriteLine("Ano:");
                            string year = Console.ReadLine();
                            alineaI(db, Int32.Parse(nifHospede), Int32.Parse(numeroSeq), Int32.Parse(year), nomParq);
                            Console.WriteLine("Hóspede inscrito na atividade nr: "+numeroSeq);
                            Console.WriteLine("");
                            break;
                        case "8":
                            Console.WriteLine("ID Estada:");
                            string idEstada = Console.ReadLine();
                            alineaJ(db, Int32.Parse(idEstada));
                            Console.WriteLine("");
                            break;
                        case "9":
                            Console.WriteLine("Intervalo:");
                            string intervalo = Console.ReadLine();
                            alineaK(db, Int32.Parse(intervalo));
                            Console.WriteLine("");
                            break;
                        case "10":
                            Console.WriteLine("Data Inicio(yyyy-MM-dd):");
                            string dataInicio = Console.ReadLine();
                            Console.WriteLine("Data Fim(yyyy-MM-dd):");
                            string dataFim = Console.ReadLine();
                            alineaL(db, Convert.ToDateTime(dataInicio), Convert.ToDateTime(dataFim));
                            Console.WriteLine("");
                            break;
                        case "11":
                            Console.WriteLine("NIF Hospede:");
                            string NIF = Console.ReadLine();
                            Console.WriteLine("Intervalo de datas");
                            Console.WriteLine("Data Inicio(yyyy-MM-dd):");
                            string dataInicio1 = Console.ReadLine();
                            Console.WriteLine("Data Fim(yyyy-MM-dd):");
                            string dataFim1 = Console.ReadLine();
                            Console.WriteLine("Nome do parque:");
                            string parqueCampismo = Console.ReadLine();
                            alinea1b(db, Int32.Parse(NIF), Convert.ToDateTime(dataInicio1), Convert.ToDateTime(dataFim1), parqueCampismo);
                            break;
                        case "12":
                            Console.WriteLine("Nome do parque:");
                            string parqCamp = Console.ReadLine();
                            alinea1c(db, parqCamp);
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
            void alineaD(GlampinhoEF db, string nomeParque, string nome, string localização, string descrição ,int preçoBase,int númeroMáximoPessoas, string tipo, int area, string tipologia)
            {
                if(tipo == "tenda")
                {
                     db.InsertAlojamentoTenda(nomeParque,nome,localização,descrição,preçoBase,(byte)númeroMáximoPessoas,area);
                }
                if(tipo == "bungalow")
                {
                     db.InsertAlojamentoBungalow(nomeParque, nome, localização, descrição, preçoBase,(byte)númeroMáximoPessoas, tipologia);
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
            void alineaG(GlampinhoEF db, string nomeParque, int númeroSequencial, string nome, string descrição, int lotaçãoMáxima, int preçoParticipante, DateTime dataRealização,int ano, string command)
            {

                var newActividade = new Actividades
                {
                    nome = nome,
                    nomeParque = nomeParque,
                    númeroSequencial = númeroSequencial,
                    descrição = descrição,
                    lotaçãoMáxima = lotaçãoMáxima,
                    preçoParticipante = preçoParticipante,
                    dataRealização = dataRealização,
                    ano = ano
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
                        entry.Property(e => e.ano).IsModified = true;
                        db.SaveChanges();

                        break;
                    default:
                        throw new Exception("Error");
                }
            }
            void alineaI(GlampinhoEF db, int nifHospede, int numeroSeq, int ano, string nomeParq)
            {
                var a = db.inscreverHóspede(nifHospede, numeroSeq, nomeParq, ano);
                db.SaveChanges();
            }
            void alineaH(GlampinhoEF db, int NIFResponsável ,int NIFHóspede, int tempoEstada, string tipoAlojamento, int lotação, int idExtraPessoal, int idExtraAlojamento)
            {
                db.createEstadaInTime(NIFResponsável, NIFHóspede, tempoEstada, tipoAlojamento, (byte)lotação, idExtraPessoal, idExtraAlojamento);
                db.SaveChanges();
                Console.WriteLine("Estada criada com sucesso para o hóspede responsável: "+ NIFResponsável);
            }
            void alineaJ(GlampinhoEF db, int idEstada)
            {
                db.finishEstadaWithFactura(idEstada);
                db.SaveChanges();
                Console.WriteLine("Factura emitida.");
            }
            void alineaK(GlampinhoEF db, int intervalo)
            {
                var msg = db.SendEmails1(intervalo);
                List<String> mails = msg.ToList();
                
                foreach(string s in mails)
                {
                    Console.WriteLine(s);
                } 
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
            void alinea1b(GlampinhoEF db, int NIF, DateTime dataInicio, DateTime dataFim, string parqueCampismo)
            {
                DbRawSqlQuery<int> data = db.Database.SqlQuery<int>("SELECT preçoTotal FROM Factura INNER JOIN (\n" +
                "SELECT idFactura FROM Estada INNER JOIN(\n" +
                "SELECT A.id FROM HóspedeEstada INNER JOIN(\n" +
                "SELECT Distinct id FROM ParqueCampismo INNER JOIN AlojamentoEstada ON ParqueCampismo.nome=@p0 )AS A ON HóspedeEstada.id=A.id and HóspedeEstada.NIF=@p1 ) AS B ON B.id=Estada.id and Estada.dataInício between @p2 and @p3)AS C ON Factura.id = C.idFactura",
                parqueCampismo, NIF, dataInicio, dataFim);
                int total = 0;
                List<int> preçosTotais = data.ToList();
                foreach (var fac in preçosTotais)
                {
                    total += fac;
                }
                Console.WriteLine("Despedas totais do hóspede com NIF: " + NIF + " : " + total + " Euros.");
            }
            void alinea1c(GlampinhoEF db, string nomeParque)
            {
                DbRawSqlQuery<int> hospedes = db.Database.SqlQuery<int>(
                "SELECT DISTINCT NIF FROM HóspedeEstada \n" +
                 "EXCEPT\n" +
                 "SELECT DISTINCT NIF FROM HóspedeEstada INNER JOIN ( SELECT id FROM AlojamentoEstada WHERE nomeParque<>@p0 ) AS A ON A.id=HóspedeEstada.id", nomeParque);
                List<int> hosps = hospedes.ToList();
                foreach (var hosp in hosps)
                {
                    var newHóspede = new Hóspede
                    {
                        NIF = hosp
      
                    };
                    db.Entry(newHóspede).State = EntityState.Deleted;
                    db.SaveChanges();
                }

                DbRawSqlQuery<int> estadas = db.Database.SqlQuery<int>(
                "SELECT A.id FROM Estada INNER JOIN(SELECT * FROM AlojamentoEstada WHERE nomeParque = @p0) AS A ON Estada.id = A.id", nomeParque);
                List<int> listEstadas = estadas.ToList();

                
                var pCampismo = new ParqueCampismo
                {
                    nome = nomeParque

                };
                db.Entry(pCampismo).State = EntityState.Deleted;
                db.SaveChanges();

                foreach (var est in listEstadas)
                {
                    var newEstada = new Estada
                    {
                        id = est

                    };
                    db.Entry(newEstada).State = EntityState.Deleted;
                    db.SaveChanges();
                }
                

                Console.WriteLine("Parque "+nomeParque+" apagado.");

            }
        }

        

    }
}
