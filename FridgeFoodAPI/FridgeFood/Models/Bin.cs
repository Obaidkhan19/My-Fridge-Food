//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FridgeFood.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Bin
    {
        public int Id { get; set; }
        public Nullable<double> Quantity { get; set; }
        public string QuantityUnit { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public Nullable<int> FridgeItemId { get; set; }
        public Nullable<int> FridgeId { get; set; }
        public string Label { get; set; }
        public Nullable<System.DateTime> PurchaseDate { get; set; }
        public Nullable<System.DateTime> ExpiryDate { get; set; }
        public Nullable<bool> IsFrozen { get; set; }
    }
}
