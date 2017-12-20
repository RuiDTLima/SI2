using Glampinho.dal;
using System.Linq;
using Glampinho.model;
using System;
using System.Collections.Generic;

namespace Glampinho.concrete {
    class ExtraAlojamentoRepository : IExtraAlojamentoRepository {
        private IContext context;

        public ExtraAlojamentoRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Extra> Find(Func<Extra, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Extra> FindAll() {
            return new ExtraAlojamentoMapper(context).ReadAll();
        }
    }
}
