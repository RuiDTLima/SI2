using System.Collections.Generic;

namespace Glampinho.dal {
    interface IRepository<T> {
        IEnumerable<T> FindAll();
        IEnumerable<T> Find(System.Func<T, bool> criteria);
    }
}