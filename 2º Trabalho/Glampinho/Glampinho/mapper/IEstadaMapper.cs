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

        int CreateEstada(int nifResponsavel, int duração);

        void AddAlojamento(string tipo, int lotação, int id);

        void AddHospede(int nifHospede, int id);

        void AddExtraAlojamento(int idExtraAloj, int id);

        void AddExtraEstada(int idExtraEstada, int id);
    }
}
