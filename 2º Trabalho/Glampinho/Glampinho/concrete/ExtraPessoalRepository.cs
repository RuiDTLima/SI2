using System;
using System.Collections.Generic;
using Glampinho.dal;
using Glampinho.model;
using System.Linq;

namespace Glampinho.concrete {
    class ExtraPessoalRepository : IExtraPessoalRepository {
        private IContext context;

        public ExtraPessoalRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Extra> Find(Func<Extra, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Extra> FindAll() {
            return new ExtraPessoalMapper(context).ReadAll();
        }
    }
}