using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fridgefood
{
    class LowStock
    {
        public static void GetLowStockItems()
        {
            try
            {
                var lowStockItems = new List<string>();
                var db = new FridgefoodEntities();

                var fridgeItems = db.FridgeItems.ToList();

                foreach (var fridgeItem in fridgeItems)
                {
                    var stocks = db.Stocks.Where(s => s.FridgeItemId == fridgeItem.Id).ToList();

                    double totalQuantity = 0;
                    string stockQuantityUnit = "";

                    foreach (var stock in stocks)
                    {
                        if (string.IsNullOrEmpty(stock.QuantityUnit))
                        {
                            totalQuantity += stock.Quantity ?? 0.0;
                            stockQuantityUnit = "Unit"; // Set a default unit when quantity unit is empty
                        }
                        else if (stock.QuantityUnit == "kg")
                        {
                            totalQuantity += stock.Quantity * 1000 ?? 0.0;
                            stockQuantityUnit = "g";
                        }
                        else if (stock.QuantityUnit == "l")
                        {
                            totalQuantity += stock.Quantity * 1000 ?? 0.0;
                            stockQuantityUnit = "ml";
                        }
                        else if (stock.QuantityUnit == "g")
                        {
                            totalQuantity += stock.Quantity ?? 0.0;
                            stockQuantityUnit = "g";
                        }
                        else if (stock.QuantityUnit == "ml")
                        {
                            totalQuantity += stock.Quantity ?? 0.0;
                            stockQuantityUnit = "ml";
                        }
                    }

                    var lowStockQuantity = fridgeItem.LowStockReminder;
                    var convertedLowStockQuantity = lowStockQuantity;

                    // Convert low stock quantity to the same unit as the combined quantity
                    if (!string.IsNullOrEmpty(fridgeItem.LowStockReminderUnit))
                    {
                        if (fridgeItem.LowStockReminderUnit == "kg")
                        {
                            convertedLowStockQuantity *= 1000;
                        }
                        else if (fridgeItem.LowStockReminderUnit == "l")
                        {
                            convertedLowStockQuantity *= 1000;
                        }
                    }

                    if (totalQuantity < convertedLowStockQuantity)
                    {
                        var lowStockItemMessage = fridgeItem.Name + " running low in stock of fridge " + fridgeItem.FridgeId;
                        lowStockItems.Add(lowStockItemMessage);

                        if (!db.ShoppingLists.Any(sl => sl.FridgeItemId == fridgeItem.Id))
                        {
                            // ADD TO SHOPPING LIST
                            DateTime dt = DateTime.Now;
                            ShoppingList sl = new ShoppingList();
                            sl.Header = "Low Stock";
                            sl.Body = fridgeItem.Name + " is running low in stock";
                            sl.Date = dt;
                            sl.FridgeId = fridgeItem.FridgeId;
                            sl.FridgeItemId = fridgeItem.Id;
                            db.ShoppingLists.Add(sl);
                            db.SaveChanges();
                            Console.WriteLine(fridgeItem.Name + " was add to shopping list");
                        }
                    }
                    else
                    {
                        var shoppingListItem = db.ShoppingLists.FirstOrDefault(sl => sl.FridgeItemId == fridgeItem.Id);
                        if (shoppingListItem != null)
                        {
                            db.ShoppingLists.Remove(shoppingListItem);
                            db.SaveChanges();
                            Console.WriteLine(fridgeItem.Name + " was removed from shopping list");
                        }
                    }
                }
                // for removing item if FridgeItemId is null then dont do anything 
                //// Check if there are any shopping list items with FridgeItemId not present in FridgeItem   
                var orphanedShoppingListItems = db.ShoppingLists
      .Where(sl => sl.FridgeItemId != null && !db.FridgeItems.Any(fi => fi.Id == sl.FridgeItemId))
    .ToList();
                foreach (var orphanedItem in orphanedShoppingListItems)
                { 

                    db.ShoppingLists.Remove(orphanedItem); 
                    db.SaveChanges();
                    Console.WriteLine("Removed orphaned item from the shopping list: " + orphanedItem.Body);
                }


                Console.WriteLine("Low Stock Items:");
                foreach (var item in lowStockItems)
                {
                    Console.WriteLine(item);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("An error occurred: " + ex.Message);
            }
        }
    }
}
