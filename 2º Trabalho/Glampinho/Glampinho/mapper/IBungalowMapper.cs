using Glampinho.model;
using System;
using System.Collections.Generic;

namespace Glampinho.mapper {
    interface IBungalowMapper : IMapper<Bungalow, Tuple<string, string>, List<Bungalow>> {
    }
}