using Glampinho.concrete;
using Glampinho.mapper;
using Glampinho.model;
using System;
using System.Configuration;

namespace Glampinho {
    class Program {
        static void Main(string[] args) {
            string connectionString = ConfigurationManager.ConnectionStrings["glampinho"].ConnectionString;

            using (Context context = new Context(connectionString)) {
                Hóspede hóspede = new Hóspede();

                hóspede.NIF = 112233445;

                HóspedeMapper hóspedeMapper = new HóspedeMapper(context);

                foreach(var h in hóspedeMapper.ReadAll()) {
                    Console.WriteLine("Hóspede: {0} || {1} || {2} || {3} || {4}", h.NIF, h.nome, h.morada, h.email, h.númeroIdentificação);
                }

                /*Hóspede newHóspede = new Hóspede();
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
                deleteHóspede.NIF = 112233445;*/




                /*ExtraPessoalMapper pessoalMapper = new ExtraPessoalMapper(context);

                Extra extra = new Extra();
                extra.id = 5;
                extra.descrição = "teste c#";
                extra.preçoDia = 12;


                extra = pessoalMapper.Create(extra);
                extra = pessoalMapper.Delete(extra);*/

                /*EstadaMapper estadaMapper = new EstadaMapper(context);

                Estada estada = new Estada();
              
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


                ProcUtils utils = new ProcUtils(context);

                utils.SendEmails(7);

                utils.ListActividades(Convert.ToDateTime("2016-03-12"), Convert.ToDateTime("2017-03-16"));
                utils.MediaPagamentos(2);

            }
        }
    }
}