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
    
    public partial class Item
    {
        public int idFactura { get; set; }
        public int ano { get; set; }
        public int linha { get; set; }
        public int quantidade { get; set; }
        public int preço { get; set; }
        public string descrição { get; set; }
        public string tipo { get; set; }
    
        public virtual Factura Factura { get; set; }
    }
}
