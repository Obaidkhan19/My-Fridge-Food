﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class FridgefoodEntities : DbContext
    {
        public FridgefoodEntities()
            : base("name=FridgefoodEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Fridge> Fridges { get; set; }
        public virtual DbSet<Ingredient> Ingredients { get; set; }
        public virtual DbSet<Recipe> Recipes { get; set; }
        public virtual DbSet<Stock> Stocks { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<ShoppingList> ShoppingLists { get; set; }
        public virtual DbSet<FridgeUser> FridgeUsers { get; set; }
        public virtual DbSet<FridgeItem> FridgeItems { get; set; }
        public virtual DbSet<Item> Items { get; set; }
        public virtual DbSet<ConsumptionLog> ConsumptionLogs { get; set; }
        public virtual DbSet<Bin> Bins { get; set; }
        public virtual DbSet<RecipeNotification> RecipeNotifications { get; set; }
    }
}
