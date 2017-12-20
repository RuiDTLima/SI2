using System;
using System.Collections.Generic;
using Glampinho.dal;
using Glampinho.model;
using System.Linq;

namespace Glampinho.concrete {
    class HóspedeRepository : IHóspedeRepository {
        private IContext context;

        public HóspedeRepository(IContext context) {
            this.context = context;
        }

        public IEnumerable<Hóspede> Find(Func<Hóspede, bool> criteria) {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Hóspede> FindAll() {
            return new HóspedeMapper(context).ReadAll();
        }
    }
}