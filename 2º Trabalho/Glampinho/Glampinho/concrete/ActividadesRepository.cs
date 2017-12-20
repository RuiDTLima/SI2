using Glampinho.dal;
using System.Linq;
using Glampinho.model;
using System;
using System.Collections.Generic;

namespace Glampinho.concrete{
    class ActividadesRepository : IActividadesRepository {
        private IContext context;

        public ActividadesRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Actividades> Find(Func<Actividades, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Actividades> FindAll() {
            return new ActividadesMapper(context).ReadAll();
        }
    }
}