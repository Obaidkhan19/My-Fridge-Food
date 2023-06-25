using System;
using System.Collections.Generic;
using System.Linq; 

namespace Fridgefood
{
    class DailyConsumption
    {
        public class ConsumedItem
        {
            public string Name { get; set; }
            public double Quantity { get; set; }
            public string QuantityUnit { get; set; }
            public int FridgeId { get; set; }

        }
        public static List<ConsumedItem> DailyConsume()
        {
            List<ConsumedItem> consumedItems = new List<ConsumedItem>();
            FridgefoodEntities db = new FridgefoodEntities();
            try
            {
                // Check if daily consumption is enabled for each fridge
                var fridges = db.Fridges.ToList();

                foreach (var fridge in fridges)
                {
                    if (fridge.AllDailyConsumption == false)
                    {
                        Console.WriteLine($"Daily consumption is disabled for FridgeId: {fridge.Id}.");
                        continue; // Skip to the next fridge
                    }

                    // Get the daily consumption items for the current fridge from the FridgeItem table
                    var fridgeItems = db.FridgeItems.Where(fi => fi.FridgeId == fridge.Id).ToList();

                    foreach (var fridgeItem in fridgeItems)
                    {
                        var stock = db.Stocks.FirstOrDefault(s => s.FridgeItemId == fridgeItem.Id);  // wrong

                        if (stock == null)
                        {
                           
                            Console.WriteLine($"Stock item not found for FridgeItemId: {fridgeItem.Id}. of Fridge {fridge.Id}");
                            continue; // Skip to the next fridge item
                        }

                        double convertedUserQuantity = ConvertQuantity(fridgeItem.DailyConsumption ?? 0.0, fridgeItem.DailyConsumptionUnit, stock.QuantityUnit);
                        double convertedStockQuantity = ConvertQuantity(stock.Quantity ?? 0, stock.QuantityUnit, stock.QuantityUnit);

                        double consumedQuantity = convertedUserQuantity;
                        if (convertedUserQuantity > convertedStockQuantity)
                        {
                            
                          
                            Console.WriteLine($"Insufficient stock for FridgeItemId: {fridgeItem.Id}  of Fridge {fridge.Id}.");
                            // continue; // Skip to the next fridge item
                             consumedQuantity = convertedStockQuantity; //consume whole stocks
                        }

                        // Check for "null" string value for unit
                        if (stock.QuantityUnit == null && fridgeItem.DailyConsumptionUnit == "null")
                        {
                            stock.Quantity -= fridgeItem.DailyConsumption;
                        }
                        else
                        {
                            stock.Quantity -= ConvertQuantity(fridgeItem.DailyConsumption ?? 0.0, fridgeItem.DailyConsumptionUnit, stock.QuantityUnit);
                            stock.Quantity = Math.Round(stock.Quantity ?? 0, 2);
                        }

                        if (stock.Quantity <= 0)
                        {
                            db.Stocks.Remove(stock);
                        }

                        // Add the consumed item to the list
                        consumedItems.Add(new ConsumedItem
                        {
                            Name = fridgeItem.Name,
                           //   Quantity = convertedUserQuantity,
                            //   QuantityUnit = stock.QuantityUnit,

                            // modified consume insufficient stock
                            Quantity = consumedQuantity,
                            QuantityUnit = stock.QuantityUnit ?? fridgeItem.DailyConsumptionUnit, // Assign stock.QuantityUnit if not null, otherwise use fridgeItem.DailyConsumptionUnit
                            FridgeId =fridgeItem.FridgeId??0,
                        });
                    }
                }

                db.SaveChanges();

                Console.WriteLine("Daily consumption completed.");
            }
            catch (Exception ex)
            {
                Console.WriteLine("An error occurred: " + ex.Message);
            }

            return consumedItems;
        }

        public static double ConvertQuantity(double quantity, string fromUnit, string toUnit)
        {
            // Create an instance of the class containing the ConvertQuantity method
            var converter = new QuantityConverter();

            // Call the ConvertQuantity method on the instance
            return converter.ConvertQuantity(quantity, fromUnit, toUnit);
        }
   
    }
}

public class QuantityConverter {

         public double ConvertQuantity(double quantity, string fromUnit, string toUnit)
        {
            if (string.IsNullOrEmpty(fromUnit) && string.IsNullOrEmpty(toUnit))
            {
                return quantity;
            }

            if (string.IsNullOrEmpty(fromUnit) && toUnit == null)
            {
                return quantity;
            }

            if (fromUnit == "null" && toUnit == null)
            {
                return quantity;
            }


            if (toUnit == null)
            {
                throw new ArgumentException("Cannot convert between units and null.");
            }
            double baseQuantity = ConvertToBase(quantity, fromUnit);
            return ConvertFromBase(baseQuantity, toUnit);
        }


        private double ConvertToBase(double quantity, string unit)
        {
            switch (unit)
            {
                case "kg":
                    return quantity * 1000;
                case "g":
                    return quantity;
                case "l":
                    return quantity * 1000;
                case "ml":
                    return quantity;
                default:
                    throw new ArgumentException($"Unsupported unit: {unit}.");
            }
        }

        private double ConvertFromBase(double baseQuantity, string unit)
        {
            switch (unit)
            {
                case "kg":
                    return baseQuantity / 1000;
                case "g":
                    return baseQuantity;
                case "l":
                    return baseQuantity / 1000;
                case "ml":
                    return baseQuantity;
                default:
                    throw new ArgumentException($"Unsupported unit: {unit}.");
            }
        }
}