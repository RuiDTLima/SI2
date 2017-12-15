using Glampinho.model;
using System;
using System.Collections.Generic;

namespace Glampinho.mapper {
    interface ITendaMapper : IMapper<Tenda, Tuple<string, string>, List<Tenda>> {
    }
}