//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ConsoleApp1
{
    using System;
    using System.Collections.Generic;
    
    public partial class EstadaExtra
    {
        public int estadaId { get; set; }
        public int extraId { get; set; }
        public Nullable<int> preçoDia { get; set; }
    
        public virtual Estada Estada { get; set; }
        public virtual Extra Extra { get; set; }
    }
}
