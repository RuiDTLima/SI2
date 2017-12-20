using System.Collections.Generic;
using Glampinho.model;
using System;

namespace Glampinho.mapper
{
    interface IAtividadesMapper : IMapper<Actividades, Tuple<String, int, int>, List<Actividades>>
    {
    }
}