using System;
using System.Collections.Generic;
using Glampinho.model;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Glampinho.mapper
{
    interface IEstadaMapper : IMapper<Estada, int, List<Estada>>
    {

        int createEstada(string nifResponsavel, int duração);

        void addAlojamento(string tipo, int lotação, int id);

        void addHospede(string nifHospede, int id);

        void addExtraAlojamento(int idExtraAloj, int id);

        void addExtraEstada(int idExtraEstada, int id);
    }
}
