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
    
    public partial class Ingredient
    {
        public int Id { get; set; }
        public Nullable<Double> Quantity { get; set; }
        public string Unit { get; set; }
        public Nullable<int> FridgeItemId { get; set; }
        public Nullable<int> RecipeId { get; set; }
    }
}
