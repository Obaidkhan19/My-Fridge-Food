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
    
    public partial class ConsumptionLog
    {
        public int Id { get; set; }
        public string LogData { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public Nullable<double> Quantity { get; set; }
        public Nullable<int> UserId { get; set; }
        public string QunatityUnit { get; set; }
        public Nullable<int> FridgeItemId { get; set; }
        public Nullable<int> FridgeId { get; set; }
    }
}
