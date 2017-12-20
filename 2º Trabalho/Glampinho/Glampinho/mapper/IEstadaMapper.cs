using System.Collections.Generic;
using Glampinho.model;

namespace Glampinho.mapper {
    interface IEstadaMapper : IMapper<Estada, int, List<Estada>> {
        int CreateEstada(Hóspede hóspede, int duração);

        void AddAlojamento(Alojamento alojamento, int id);

        void AddHospede(Hóspede hóspede, int id);

        void AddExtraAlojamento(Extra extra, int id);
        
        void AddExtraEstada(Extra extra, int id);
    }
}