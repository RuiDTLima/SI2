using Glampinho.model;
using System.Collections.Generic;

namespace Glampinho.mapper {
    interface IHóspedeMapper : IMapper<Hóspede, int, List<Hóspede>> {

        void InscreverHospede(int NIFHóspede, int númeroSequencial , string nomeParque,int ano  );
    }
}