using Glampinho.concrete;
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

                foreach(var h in hóspedeMapper.ReadAll()) {
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

                var result = hóspedeMapper.Delete(deleteHóspede);
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
            using(Context context = new Context(connectionString)) {
                TendaMapper tendaMapper = new TendaMapper(context);

                foreach(var tenda in tendaMapper.ReadAll()) {
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
            }
        }
    }
}