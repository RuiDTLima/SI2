using Glampinho.dal;
using System;
using System.Collections.Generic;
using Glampinho.model;
using System.Linq;

namespace Glampinho.concrete {
    class TendaRepository : ITendaRepository {
        private IContext context;

        public TendaRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Tenda> Find(Func<Tenda, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Tenda> FindAll() {
            return new TendaMapper(context).ReadAll();
        }
    }
}