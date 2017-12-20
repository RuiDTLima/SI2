using System;
using System.Collections.Generic;
using Glampinho.dal;
using Glampinho.model;
using System.Linq;

namespace Glampinho.concrete {
    class BungalowRepository : IBungalowRepository {
        private IContext context;

        public BungalowRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Bungalow> Find(Func<Bungalow, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Bungalow> FindAll() {
            return new BungalowMapper(context).ReadAll();
        }
    }
}