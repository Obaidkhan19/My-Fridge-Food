using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class RoughController : ApiController
    {



        FridgefoodEntities db = new FridgefoodEntities();


        [HttpGet]
        public HttpResponseMessage GetLowStockItems()
        {
            try
            {
                var lowStockItems = new List<string>();

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
                    }
                }

                return Request.CreateResponse(HttpStatusCode.OK, lowStockItems);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }



        [HttpGet]
        public HttpResponseMessage TotalStockQuantity()
        {
            try
            {
                var itemsWithTotalQuantity = new List<dynamic>();

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

                    var itemWithTotalQuantity = new
                    {
                        ItemName = fridgeItem.Name,
                        TotalQuantity = totalQuantity,
                        QuantityUnit = stockQuantityUnit
                    };

                    itemsWithTotalQuantity.Add(itemWithTotalQuantity);
                }

                return Request.CreateResponse(HttpStatusCode.OK, itemsWithTotalQuantity);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        /* 
         * Status = s == null ? null :
                        (s.ExpiryDate < DateTime.Now ? "Expired" :
                        (f.ExpiryReminder != null ?
                            (s.ExpiryDate - DateTime.Now <= TimeSpan.FromDays(f.ExpiryReminder.Value) ? "Near Expiry" : "Good") :
                            ((s.ExpiryDate - DateTime.Now).Days <= (s.ExpiryDate - s.PurchaseDate).Days * 0.1 ? "Near Expiry" : "Good")))
         * 
         * 
         * 
         *   [HttpPost]
        public HttpResponseMessage FridgeItemAdd()
        {
            try
            { 
                HttpRequest request = HttpContext.Current.Request;
                var imagefile = request.Files["Image"];
                var name = request.Form["Name"].ToString(); 
                var category = request.Form["Category"];
                var fridgeid = request.Form["FridgeId"]; 
                var freeztime = request.Form["FreezTime"];
                var expiryreminder = request.Form["ExpiryReminder"];
                var lowstockreminder = request.Form["LowStockReminder"];
                var lowstockreminderunit = request.Form["LowStockReminderUnit"];
                var dailyconsumption = request.Form["DailyConsumption"];
                var dailyconsumptionunit = request.Form["DailyConsumptionUnit"];
                var itemunit = request.Form["ItemUnit"];
                int fid = int.Parse(fridgeid);
                var item = db.FridgeItems.Where(i => i.Name == name && i.FridgeId == fid).FirstOrDefault();
                if (item != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Exist");
                }
                else
                {
                    string filename = "";
                    if (imagefile != null)
                    {
                        string extension = Path.GetExtension(imagefile.FileName);
                        DateTime dt = DateTime.Now;
                        filename = name + "_" + dt.Year + dt.Month + dt.Day + dt.Minute + dt.Second + dt.Hour + extension;
                        imagefile.SaveAs(HttpContext.Current.Server.MapPath("~/Images/" + filename));
                    }

                    FridgeItem f = new FridgeItem();
                    f.Image = filename;
                    f.Name = name;
                    f.Category = category; 
                       f.FreezTime = int.Parse(freeztime);
                    f.ExpiryReminder = int.Parse(expiryreminder);
                    f.LowStockReminder = int.Parse(lowstockreminder);
                    f.LowStockReminderUnit = lowstockreminderunit;
                    f.DailyConsumption = int.Parse(dailyconsumption);
                    f.DailyConsumptionUnit = dailyconsumptionunit;
                    f.FridgeId = int.Parse(fridgeid);
                    db.FridgeItems.Add(f);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Successfully");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
      [HttpGet]
      public HttpResponseMessage RecipeDetail(int rid)
      {
          try
          {
              var ingredients = from ing in db.Set<Ingredient>()
                                join fi in db.Set<FridgeItem>()
                                on ing.FridgeItemId equals fi.Id
                                where ing.RecipeId == rid
                                select new
                                {
                                    Id = ing.Id,
                                    IngQuantity = ing.Quantity,
                                    IngUnit = ing.Unit,
                                    ItemName = fi.Name,
                                    FridgeItemId = fi.Id,
                                    Stocks = (from s in db.Set<Stock>()
                                              where s.FridgeItemId == fi.Id
                                              select new
                                              {
                                                  Quantity = s.Quantity ?? 0,
                                                  Unit = s.QuantityUnit ?? "",
                                              }).ToList(),
                                };
              List<dynamic> modifiedIngredients = new List<dynamic>();

              foreach (var ingredient in ingredients)
              {
                  double totalStockQuantity = 0;
                  string stockQuantityUnit = "";
                  foreach (var stock in ingredient.Stocks)
                  {


                      if (string.IsNullOrEmpty(stock.Unit))
                      {
                          totalStockQuantity += stock.Quantity;
                      }
                      // IF STOCK IS IN KG
                      else if (stock.Unit == "kg")
                      {
                          totalStockQuantity += stock.Quantity * 1000;
                          stockQuantityUnit = "g";
                      }
                      // IF STOCK IS IN l
                      else if (stock.Unit == "l")
                      {
                          totalStockQuantity += stock.Quantity * 1000;
                          stockQuantityUnit = "ml";
                      }
                      // IF STOCK IS ALREADY IN G
                      else if (stock.Unit == "g")
                      {
                          totalStockQuantity += stock.Quantity;
                          stockQuantityUnit = "g";
                      }
                      // IF STOCK IS ALREADY IN ML
                      else if (stock.Unit == "ml")
                      {
                          totalStockQuantity += stock.Quantity;
                          stockQuantityUnit = "ml";
                      }
                  }

                  var modifiedIngredient = new
                  {
                      ingredient.Id,
                      ingredient.IngQuantity,
                      ingredient.IngUnit,
                      ingredient.ItemName,
                      ingredient.FridgeItemId,
                      Stocks = new List<dynamic>
              {
                  new { Quantity = totalStockQuantity, Unit = stockQuantityUnit }
              }
                  };
                  modifiedIngredients.Add(modifiedIngredient);
              }
              return Request.CreateResponse(HttpStatusCode.OK, modifiedIngredients);
          }
          catch (Exception ex)
          {
              return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
          }
      }

           ========================// ANOTHER WAY
               var modifiedIngredient = new
                  {
                      ingredient.Id,
                      IngQuantity = ingredient.IngQuantity,
                      IngUnit = ingredient.IngUnit,
                      ingredient.ItemName,
                      ingredient.FridgeItemId,
                      AvaliableQuantity = totalStockQuantity,
                      AvaliableUnit = stockQuantityUnit,
                  };
                  modifiedIngredients.Add(modifiedIngredient);
              }
              return Request.CreateResponse(HttpStatusCode.OK, modifiedIngredients);

            ========================// ANOTHER WAY

           foreach (var ingredient in ingredients)
              {
                  double totalStockQuantity = 0;
                  string stockQuantityUnit = "";

                  foreach (var stock in ingredient.Stocks)
                  {
                      if (string.IsNullOrEmpty(stock.Unit))
                      {
                          totalStockQuantity += stock.Quantity;
                      }
                      else if (stock.Unit == "kg")
                      {
                          totalStockQuantity += stock.Quantity * 1000;
                          stockQuantityUnit = "g";
                      }
                      else if (stock.Unit == "l")
                      {
                          totalStockQuantity += stock.Quantity * 1000;
                          stockQuantityUnit = "ml";
                      }
                      else if (stock.Unit == "g" || stock.Unit == "")
                      {
                          totalStockQuantity += stock.Quantity;
                          stockQuantityUnit = "g";
                      }
                      else if (stock.Unit == "ml")
                      {
                          totalStockQuantity += stock.Quantity;
                          stockQuantityUnit = "ml";
                      }
                  }

                  var modifiedIngredient = new
                  {
                      ingredient.Id,
                      IngQuantity = ingredient.IngQuantity,
                      IngUnit = ingredient.IngUnit,
                      ingredient.ItemName,
                      ingredient.FridgeItemId,
                      AvaliableQuantity = totalStockQuantity,
                      AvaliableUnit = stockQuantityUnit,
                  };

                  modifiedIngredients.Add(modifiedIngredient);
              }

              return Request.CreateResponse(HttpStatusCode.OK, modifiedIngredients);
          }




         [HttpGet]
        public HttpResponseMessage ConsumeStock(int sid, double quantity, String unit)
        {
            try
            {
                var stock = db.Stocks.Where(s => s.Id == sid).FirstOrDefault();
                if (stock == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "Stock not found.");
                }

                if (unit == null)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Unit must be specified.");
                }

                if (stock.QuantityUnit == null)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Stock unit is not specified.");
                }

                // The quantity is assumed to be stored in grams
                double stockQuantityGrams = double.Parse(stock.Quantity.ToString());

                // Convert grams to kilograms if the stock unit is "kg"
                if (stock.QuantityUnit.ToLower() == "kg")
                {
                    stockQuantityGrams *= 1000;
                }

                // Convert the input quantity to grams or kilograms, as appropriate
                double quantityGrams = quantity;
                if (unit.ToLower() == "kg")
                {
                    quantityGrams *= 1000;
                }
                else if (unit.ToLower() == "g" && stock.QuantityUnit.ToLower() == "kg")
                {
                    quantityGrams /= 1000;
                }

                if (!string.Equals(unit.ToLower(), stock.QuantityUnit.ToLower()))
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "User unit does not match stock unit.");
                }

                if (quantityGrams > stockQuantityGrams)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Insufficient stock quantity.");
                }

                stockQuantityGrams -= quantityGrams;

                // Convert grams back to kilograms if the stock unit is "kg"
                if (stock.QuantityUnit.ToLower() == "kg")
                {
                    stockQuantityGrams /= 1000;
                }

                stock.Quantity = stockQuantityGrams;

                if (stock.Quantity == 0)
                {
                    db.Stocks.Remove(stock);
                    db.SaveChanges();

                    // Check if the stock was actually removed
                    if (db.Stocks.Any(s => s.Id == sid))
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, "Error removing stock from database.");
                    }
                }
                else
                {
                    db.SaveChanges();
                }

                return Request.CreateResponse(HttpStatusCode.OK, stock);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
      */

    }
}
