using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Data.Entity;

namespace FridgeFood.Controllers
{ 
    public class FridgeItemController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();

      


        [HttpPost]
        public HttpResponseMessage EditItem()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                var imagefile = request.Files["Image"];
                var name = request.Form["Name"].ToString();
                var itemUnit = request.Form["ItemUnit"];
                var category = request.Form["Category"];
                //var freezingTime = request.Form["FreezingTime"].ToString();
                var fridgeTime = request.Form["FridgeTime"];
                var expiryReminder = request.Form["ExpiryReminder"];
                var lowStockReminder = request.Form["LowStockReminder"].ToString();
                //var lowStockReminderUnit = request.Form["LowStockReminderUnit"];
                var dailyConsumption = request.Form["DailyConsumption"];
              //  var dailyConsumptionUnit = request.Form["DailyConsumptionUnit"].ToString();
                int id = int.Parse(request.Form["Id"]);

                string lowStockReminderUnit = null;
                string dailyConsumptionUnit = null;

                if (request.Form.AllKeys.Contains("LowStockReminderUnit"))
                {
                    lowStockReminderUnit = request.Form["LowStockReminderUnit"];
                }

                if (request.Form.AllKeys.Contains("DailyConsumptionUnit"))
                {
                    dailyConsumptionUnit = request.Form["DailyConsumptionUnit"];
                }

                var fi = db.FridgeItems.FirstOrDefault(i => i.Id == id);
                if (fi == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "notfound");
                }
                else
                {
                    string filename = "";
                    if (imagefile != null)
                    {
                        string extension = Path.GetExtension(imagefile.FileName);
                        DateTime dt = DateTime.Now;
                        filename = name + "_" + dt.Year + dt.Month + dt.Day + dt.Minute + dt.Second + dt.Hour + extension;
                        imagefile.SaveAs(HttpContext.Current.Server.MapPath("~/Images/Items/" + filename));
                    }
                    else
                    {
                        filename = fi.Image;
                    }

                    //item  initialize above
                    fi.Image = filename;
                    fi.Name = name;
                    fi.ItemUnit = itemUnit;
                    fi.Category = category;
                    //fi.FreezingTime = freezingTime; 
                    fi.FridgeTime = int.Parse(fridgeTime);
                    fi.ExpiryReminder = int.Parse(expiryReminder);
                    fi.LowStockReminder = int.Parse(lowStockReminder);
                    fi.LowStockReminderUnit = lowStockReminderUnit;
                    fi.DailyConsumption = int.Parse(dailyConsumption);
                    fi.DailyConsumptionUnit = dailyConsumptionUnit;
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "updatedSuccessfully");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpPost]
        public HttpResponseMessage AddCustomItem()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                var imagefile = request.Files["Image"];
                var name = request.Form["Name"].ToString();
                var itemUnit = request.Form["ItemUnit"];
                var category = request.Form["Category"];
                //var freezingTime = request.Form["FreezingTime"].ToString();
                var fridgeTime = request.Form["FridgeTime"];
                var expiryReminder = request.Form["ExpiryReminder"];
                var lowStockReminder = request.Form["LowStockReminder"].ToString();
               // var lowStockReminderUnit = request.Form["LowStockReminderUnit"];
                var dailyConsumption = request.Form["DailyConsumption"];
               // var dailyConsumptionUnit = request.Form["DailyConsumptionUnit"].ToString();
                var fridgeId = request.Form["FridgeId"];
                int fid = int.Parse(fridgeId);
                string lowStockReminderUnit = null;
                string dailyConsumptionUnit = null;

                if (request.Form.AllKeys.Contains("LowStockReminderUnit"))
                {
                    lowStockReminderUnit = request.Form["LowStockReminderUnit"];
                }

                if (request.Form.AllKeys.Contains("DailyConsumptionUnit"))
                {
                    dailyConsumptionUnit = request.Form["DailyConsumptionUnit"];
                }

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
                        imagefile.SaveAs(HttpContext.Current.Server.MapPath("~/Images/Items/" + filename));
                    } 
                    FridgeItem fi = new FridgeItem();
                    fi.Image = filename;
                    fi.Name = name;
                    fi.ItemUnit = itemUnit;
                    fi.Category = category;
                    //fi.FreezingTime = freezingTime; 
                    fi.FridgeTime = int.Parse(fridgeTime);
                    fi.ExpiryReminder = int.Parse(expiryReminder);
                    fi.LowStockReminder = int.Parse(lowStockReminder);
                    fi.LowStockReminderUnit = lowStockReminderUnit;
                    fi.DailyConsumption = int.Parse(dailyConsumption);
                    fi.DailyConsumptionUnit = dailyConsumptionUnit;
                    fi.FridgeId = fid;

                    db.FridgeItems.Add(fi);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Successfully");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        public class ConsumeIngredientsRequest
        {
            public List<int> FridgeItemIds { get; set; }
            public List<double> Quantities { get; set; }
            public List<string> Units { get; set; }
        }

        // NOT HANDEL MULTIPLE STOCKS AND CONSUME 1 IF 2 HAS NOT ENOUGH STOCK
        [HttpPost]
        public HttpResponseMessage ConsumeIngredients([FromBody] ConsumeIngredientsRequest request)
        {
            try
            {
                var fridgeItemIds = request.FridgeItemIds;
                var quantities = request.Quantities;
                var units = request.Units;

                for (int i = 0; i < fridgeItemIds.Count; i++)
                {
                    int fridgeItemId = fridgeItemIds[i];
                    double quantity = quantities[i];
                    string unit = units[i];
                    if (unit == "nounit")
                    {
                        unit = null;
                    }
                    // Get all stocks of fridge item from fridge item table
                    var stocks = db.Stocks
                        .Where(s => s.FridgeItemId == fridgeItemId && s.Quantity > 0)
                        .OrderBy(s => s.ExpiryDate)
                        .ToList();

                    if (stocks == null || stocks.Count == 0)
                    {
                        return Request.CreateResponse(HttpStatusCode.NotFound, "Insufficient stock for fridge item " + fridgeItemId);
                    }

                    double remainingQuantity = quantity;

                    // Consume the ingredients
                    foreach (var stock in stocks)
                    {
                        // Get the quantity to consume from this stock
                        double quantityToConsume = ConvertQuantity(remainingQuantity, unit, stock.QuantityUnit);

                        if (quantityToConsume <= stock.Quantity)
                        {
                            // Consume from this stock
                            stock.Quantity -= quantityToConsume;
                            remainingQuantity -= ConvertQuantity(quantityToConsume, stock.QuantityUnit, unit);
                            stock.Quantity = Math.Round(stock.Quantity ?? 0, 2);
                            db.Entry(stock).State = EntityState.Modified;

                            // If the stock is now empty, remove it from the database
                            if (stock.Quantity == 0)
                            {
                                db.Stocks.Remove(stock);
                            }

                            db.SaveChanges();
                            break;
                        }
                        else
                        {
                            // Not enough stock in this stock item, continue with next one
                            continue;
                        }
                    }

                    // If there is still quantity remaining, there is insufficient stock
                    if (remainingQuantity > 0)
                    {
                        return Request.CreateResponse(HttpStatusCode.NotFound, "Insufficient stock for fridge item " + fridgeItemId);
                    }
                }

                return Request.CreateResponse(HttpStatusCode.OK, "Ingredients consumed successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage GetFridgeItem(int fiid)
        {
            try
            {
                var fridgeitem = db.FridgeItems.FirstOrDefault(fi => fi.Id ==fiid);
                return Request.CreateResponse(HttpStatusCode.OK, fridgeitem);

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ConsumeAllStock(int sid, String data,  int uid, int fid)
        {
            try
            {
                var stock = db.Stocks.FirstOrDefault(fi => fi.Id == sid);
                if (stock == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
               // int? fridgeid = stock.FridgeId;
                double? quantity = stock.Quantity;
                String unit = stock.QuantityUnit;
                DateTime localDate = DateTime.Now; 
                ConsumptionLog cl = new ConsumptionLog();
                cl.Date = localDate;
                cl.LogData = data;
               cl.FridgeId = fid;
                cl.FridgeItemId = stock.FridgeItemId;
                cl.Quantity = quantity;
                cl.QunatityUnit = unit;
                cl.UserId = uid;
                db.ConsumptionLogs.Add(cl);
                db.SaveChanges();
                db.Stocks.Remove(stock);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Consumed");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage ConsumeStock(int sid, double quantity, string unit, String data , int uid, int fid)
        {
            try
            {
                // WHEN I WANT TO SEND ANYTHING IN UNIT
               // if (unit == "nounit") {
              //      unit= null;
             //   }

                var stock = db.Stocks.Where(s => s.Id == sid).FirstOrDefault();

                if (stock == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "Stock item not found.");
                }

                double convertedUserQuantity = ConvertQuantity(quantity, unit, stock.QuantityUnit);
                double convertedStockQuantity = ConvertQuantity(stock.Quantity??0, stock.QuantityUnit, stock.QuantityUnit);

                if (convertedUserQuantity > convertedStockQuantity)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Insufficientstock");
                }
                // NO UNIT

                // Check for "null" string value for unit
                if (stock.QuantityUnit == null && unit == "null")
                {
                    stock.Quantity -= quantity;
                }
                
               
                // FOR KG AND GRAM AND ML OR L  (to get more units add you can modify the ConvertToBase and ConvertFromBase)
                else
                {
                    stock.Quantity -= ConvertQuantity(quantity, unit, stock.QuantityUnit);
                    stock.Quantity = Math.Round(stock.Quantity ??0 , 2);
                }

                if (stock.Quantity <= 0)
                {
                    db.Stocks.Remove(stock);
                }

               // int? fridgeid = stock.FridgeId;
                DateTime localDate = DateTime.Now;
                ConsumptionLog cl = new ConsumptionLog();
                cl.Date = localDate;
                cl.LogData = data;
               cl.FridgeId = fid;
                cl.FridgeItemId = stock.FridgeItemId;
                cl.Quantity = quantity;
                cl.QunatityUnit = unit;
                cl.UserId = uid;
                db.ConsumptionLogs.Add(cl);
                db.SaveChanges();
                db.SaveChanges();

                return Request.CreateResponse(HttpStatusCode.OK, "consumed");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        private double ConvertQuantity(double quantity, string fromUnit, string toUnit)
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
       

        
        [HttpGet]
        public HttpResponseMessage AllItemsNames() // FOR SHOPPING LIST  (maybe => Add items from fridgeid )
        {
            try
            {
                var items = db.Items.ToList(); 
                var name = items.Select(i => new { i.Id, i.Name, i.ItemUnit }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, name);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage FridgeItemsNames(int fid) // FOR Recipe Ingredients 
        {
            try
            {

                var items = db.FridgeItems
    .Where(fi => fi.FridgeId == fid) // Filter by FridgeId
    .Select(fi => new { fi.Id, fi.Name, fi.ItemUnit })
    .ToList();
           

                return Request.CreateResponse(HttpStatusCode.OK, items);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage AllItems()
        {
            try
            {
                var items = db.Items.ToList(); 
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage AllFridgeItems()
        {
            try
            {
                var items = db.FridgeItems.ToList();
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage AllStocks(int fiid)
        {
            try 
            {
                var stock = db.Stocks.Where(a => a.FridgeItemId==fiid).OrderBy(a => a.ExpiryDate).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, stock);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        } 
          
       
        [HttpGet]
        public HttpResponseMessage DeleteFridgeItem(int fiid)  // also delete stocks
        {
            try
            {
                var fridgeItem = db.FridgeItems.FirstOrDefault(fi => fi.Id == fiid);

                if (fridgeItem == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
                // delete  stock 
                var stock = db.Stocks.Where(s => s.FridgeItemId == fiid).ToList();
                db.Stocks.RemoveRange(stock);
                // delete  Ingredient
                var ing = db.Ingredients.Where(s => s.FridgeItemId == fiid).ToList();
                db.Ingredients.RemoveRange(ing);
                // delete consumption log
                var clog = db.ConsumptionLogs.Where(s => s.FridgeItemId == fiid).ToList();
                db.ConsumptionLogs.RemoveRange(clog);
                // delete bin log
                var blog = db.Bins.Where(s => s.FridgeItemId == fiid).ToList();
                db.Bins.RemoveRange(blog);
                //  delete item
                db.FridgeItems.Remove(fridgeItem);

                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        } 
       
       
        [HttpPost]
        public HttpResponseMessage EditStock(Stock stock)
        {
            try
            {
                var stock1 = db.Stocks.FirstOrDefault(u => u.Id == stock.Id);
                if (stock1 == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
                // if stock found
                stock1.Quantity = stock.Quantity;
                stock1.QuantityUnit = stock.QuantityUnit;
                stock1.PurchaseDate = stock.PurchaseDate;
                stock1.ExpiryDate = stock.ExpiryDate;
                stock1.IsFrozen = stock.IsFrozen;

                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Updated");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        

        [HttpPost]
        public HttpResponseMessage AddItem(int iid, int fid)
        {
            try
            {
                var fridgeitem = db.FridgeItems.Where(i => i.ItemId == iid && i.FridgeId == fid).FirstOrDefault();
                if (fridgeitem != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Exist");
                }
                var item = db.Items.FirstOrDefault(i => i.Id == iid);
                if (item == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "Item not found");
                }
                FridgeItem fi = new FridgeItem();
                fi.ItemId = iid;
                fi.FridgeId = fid;
                fi.Name = item.Name;
                fi.Category = item.Category;
                fi.ItemUnit = item.ItemUnit;
                fi.Image = item.Image;
                fi.FreezingTime = item.FreezingTime;
                fi.FridgeTime = item.FridgeTime;
                fi.ExpiryReminder = 4;
                db.FridgeItems.Add(fi);
                db.SaveChanges();
               
                var items = (
                      from f in db.Set<FridgeItem>()
                      join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                      from s in stockGroup.Where(x => x.FridgeItemId == f.Id).DefaultIfEmpty()
                      where f.Id == fi.Id // Filter by the newly inserted FridgeItem ID
                      select new { s, f }
               ).ToList()
               .Select(x => new {
                 //  ItemId = x.i.Id,
                   x.f.Name,
                   x.f.Image,
                   x.f.Category,
                   ItemFreezingTime = x.f.FreezingTime,
                   ItemFridgeTime = x.f.FridgeTime,
                   x.f.ItemUnit,
                   FridgeItemId = (int?)x.f?.Id,
                   x.f?.LowStockReminder,
                   x.f?.LowStockReminderUnit,
                   x.f?.DailyConsumption,
                   x.f?.DailyConsumptionUnit,
                   x.f?.ExpiryReminder,
                   UserFreezingTime = x.f?.FreezingTime,
                   UserFridgeTime = x.f?.FridgeTime,
                   Quantity = x.s?.Quantity ?? 0,
                   QuantityUnit = x.s?.QuantityUnit,
                   PurchaseDate = x.s?.PurchaseDate,
                   ExpiryDate = x.s?.ExpiryDate,
                   IsFrozen = x.s?.IsFrozen ?? false,
                   StockId = x.s?.Id ?? 0,
                   Status = GetStatus(x.s, x.f)
               })
               .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage EditItemDetail(int fiid, int? expiryreminderdays,double? dailyuse, String dailyuseunit, double? lowstock, String lowstockunit, String  unit )
        {
            try
            {
                var item1 = db.FridgeItems.FirstOrDefault(u => u.Id == fiid);
                if (item1 == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }

                //   item1.ExpiryReminder = expiryreminderdays;
                // item1.DailyConsumption =dailyuse;
                // item1.DailyConsumptionUnit = dailyuseunit;
                // item1.LowStockReminder =lowstock;
                //  item1.LowStockReminderUnit = lowstockunit;

                if (expiryreminderdays.HasValue)
                {
                    item1.ExpiryReminder = expiryreminderdays.Value;
                }
                if (dailyuse.HasValue)
                {
                    item1.DailyConsumption = dailyuse.Value;
                }
                if (!string.IsNullOrEmpty(dailyuseunit))
                {
                    item1.DailyConsumptionUnit = dailyuseunit;
                }
                if (lowstock.HasValue)
                {
                    item1.LowStockReminder = lowstock.Value;
                }
                if (!string.IsNullOrEmpty(lowstockunit))
                {
                    item1.LowStockReminderUnit = lowstockunit;
                }
                if (!string.IsNullOrEmpty(unit))
                {
                    item1.ItemUnit = unit;
                }
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Updated");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage AddStock(Stock stock)
        {
            try
            {

                db.Stocks.Add(stock);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage RestoreStock(int bid)
        {
            try
            {
                var bin = db.Bins.FirstOrDefault(b => b.Id == bid);
                if (bin == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                Stock stock = new Stock();
                stock.Label = bin.Label;
                stock.Quantity = bin.Quantity;
                stock.QuantityUnit = bin.QuantityUnit;
                stock.PurchaseDate = bin.PurchaseDate;
                stock.ExpiryDate = bin.ExpiryDate;
                stock.IsFrozen = bin.IsFrozen;
                stock.FridgeItemId = bin.FridgeItemId;
                db.Stocks.Add(stock);
                db.SaveChanges();
                db.Bins.Remove(bin);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Restored");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage StockDetail(int sid)
        {
            try
            {
                var stock = db.Stocks.Where(a => a.Id == sid);
                return Request.CreateResponse(HttpStatusCode.OK, stock);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage DeleteStock(int sid, int fid)
        {
            try
            {
                var stock = db.Stocks.FirstOrDefault(fi => fi.Id == sid);
                if (stock == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }

                DateTime localDate = DateTime.Now;
                Bin b = new Bin();
                b.Date = localDate;
                b.FridgeId = fid;
                b.Quantity = stock.Quantity;
                b.QuantityUnit = stock.QuantityUnit;
                b.FridgeItemId = stock.FridgeItemId;
                b.Label = stock.Label;
                b.IsFrozen = stock.IsFrozen;
                b.PurchaseDate = stock.PurchaseDate;
                b.ExpiryDate = stock.ExpiryDate;
                db.Bins.Add(b);
                db.SaveChanges();
                db.Stocks.Remove(stock);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public HttpResponseMessage GetExpiringItemCount(int fid)
        {
            try
            {
                var expiringItemCount = (
                    from i in db.Set<Item>()
                    join f in db.Set<FridgeItem>() on i.Id equals f.ItemId
                    join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                    from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                    where f.FridgeId == fid && f.Id != null && s != null && s.Quantity > 0
                    select new { s, f }
                )
                .ToList()
                .Where(x => GetStatus(x.s, x.f) == "Expired" || GetStatus(x.s, x.f) == "ExpiringSoon")
                .Count();

                return Request.CreateResponse(HttpStatusCode.OK, expiringItemCount);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


  

        [HttpGet]
        public HttpResponseMessage AllFridgeItems(int fid) // for search 
        {
            try
            {
                var items = (
                      from f in db.Set<FridgeItem>()
                      join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                      from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                      where  f.FridgeId == fid && f.Id != null
                      select new {  s, f }
                ).ToList()
                .Select(x => new {
                  //  ItemId = x.i.Id,
                    x.f.Name,
                    x.f.Image,
                    x.f.Category,
                    ItemFreezingTime = x.f.FreezingTime,
                    ItemFridgeTime = x.f.FridgeTime,
                    x.f.ItemUnit,
                    FridgeItemId = (int?)x.f?.Id,
                    x.f?.LowStockReminder,
                    x.f?.LowStockReminderUnit,
                    x.f?.DailyConsumption,
                    x.f?.DailyConsumptionUnit,
                    x.f?.ExpiryReminder,
                    UserFreezingTime = x.f?.FreezingTime,
                    UserFridgeTime = x.f?.FridgeTime,
                    Quantity = x.s?.Quantity ?? 0,
                    QuantityUnit = x.s?.QuantityUnit,
                    PurchaseDate = x.s?.PurchaseDate,
                    ExpiryDate = x.s?.ExpiryDate,
                    IsFrozen = x.s?.IsFrozen ?? false,
                    StockId = x.s?.Id ?? 0,
                    Status = GetStatus(x.s, x.f)
                })
                .OrderBy(x => x.StockId <= 0)
                .ThenBy(x => x.ExpiryDate)
                .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }



        [HttpGet]
        public HttpResponseMessage Cooked(int fid)
        {
            try
            {
                var items = (
                      from f in db.Set<FridgeItem>() 
                      join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                      from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                      where (f.Category == "Cooked" ) && f.FridgeId == fid && f.Id != null
                      select new {  s, f }
                ).ToList()
                .Select(x => new {
                //    ItemId = x.i.Id,
                    x.f.Name,
                    x.f.Image,
                    x.f.Category,
                    ItemFreezingTime = x.f.FreezingTime,
                    ItemFridgeTime = x.f.FridgeTime,
                    x.f.ItemUnit,
                    FridgeItemId = (int?)x.f?.Id,
                    x.f?.LowStockReminder,
                    x.f?.LowStockReminderUnit,
                    x.f?.DailyConsumption,
                    x.f?.DailyConsumptionUnit,
                    x.f?.ExpiryReminder,
                    UserFreezingTime = x.f?.FreezingTime,
                    UserFridgeTime = x.f?.FridgeTime,
                    Quantity = x.s?.Quantity ?? 0,
                    QuantityUnit = x.s?.QuantityUnit,
                    PurchaseDate = x.s?.PurchaseDate,
                    ExpiryDate = x.s?.ExpiryDate,
                    IsFrozen = x.s?.IsFrozen ?? false,
                    StockId = x.s?.Id ?? 0,
                    Status = GetStatus(x.s, x.f)
                })
                .OrderBy(x => x.StockId <= 0)
                .ThenBy(x => x.ExpiryDate)
                .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage FruitandVegetableDashboard(int fid)
        {
         try
            {
                var items = ( 
                      from f in db.Set<FridgeItem>() 
                      join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                      from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                      where (f.Category == "Fruit" || f.Category == "Vegetable") && f.FridgeId == fid && f.Id != null
                      select new { s, f }
                ).ToList()
                .Select(x => new {
                    //    ItemId = x.i.Id,
                    x.f.Name,
                    x.f.Image,
                    x.f.Category,
                    ItemFreezingTime = x.f.FreezingTime,
                    ItemFridgeTime = x.f.FridgeTime,
                    x.f.ItemUnit,
                    FridgeItemId = (int?)x.f?.Id,
                    x.f?.LowStockReminder,
                    x.f?.LowStockReminderUnit,
                    x.f?.DailyConsumption,
                    x.f?.DailyConsumptionUnit,
                    x.f?.ExpiryReminder,
                    UserFreezingTime = x.f?.FreezingTime,
                    UserFridgeTime = x.f?.FridgeTime,
                    Quantity = x.s?.Quantity ?? 0,
                    QuantityUnit = x.s?.QuantityUnit,
                    PurchaseDate = x.s?.PurchaseDate,
                    ExpiryDate = x.s?.ExpiryDate,
                    IsFrozen = x.s?.IsFrozen ?? false,
                    StockId = x.s?.Id ?? 0,
                    Status = GetStatus(x.s, x.f)
                })
                .OrderBy(x => x.StockId <= 0)
                .ThenBy(x => x.ExpiryDate)
                .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        
        
        [HttpGet]
        public HttpResponseMessage EggandBakeryDashboard(int fid)
        {
            try
            {
                var items = (
                /*   from i in db.Set<Item>()
                   join s in db.Set<Stock>() on i.Id equals s.FridgeItemId into stockGroup
                   from s in stockGroup.DefaultIfEmpty()
                   join f in db.Set<FridgeItem>() on i.Id equals f.ItemId into fridgeGroup
                   from f in fridgeGroup.Where(f => f.FridgeId == fid).DefaultIfEmpty()//i.Category == "Meat" || i.Category == "Seafood"
                   where (i.Category == "Eggs" || i.Category == "Bakery") && f.Id != null 
                   */
                   
                   from f in db.Set<FridgeItem>()
                   join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                   from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                   where (f.Category == "Eggs" || f.Category == "Bakery") && f.FridgeId == fid && f.Id != null 
                   select new { s, f }
               ).ToList()
               .Select(x => new {
                   //    ItemId = x.i.Id,
                   x.f.Name,
                   x.f.Image,
                   x.f.Category,
                   ItemFreezingTime = x.f.FreezingTime,
                   ItemFridgeTime = x.f.FridgeTime,
                   x.f.ItemUnit,
                   FridgeItemId = (int?)x.f?.Id,
                   x.f?.LowStockReminder,
                   x.f?.LowStockReminderUnit,
                   x.f?.DailyConsumption,
                   x.f?.DailyConsumptionUnit,
                   x.f?.ExpiryReminder,
                   UserFreezingTime = x.f?.FreezingTime,
                   UserFridgeTime = x.f?.FridgeTime,
                   Quantity = x.s?.Quantity ?? 0,
                   QuantityUnit = x.s?.QuantityUnit,
                   PurchaseDate = x.s?.PurchaseDate,
                   ExpiryDate = x.s?.ExpiryDate,
                   IsFrozen = x.s?.IsFrozen ?? false,
                   StockId = x.s?.Id ?? 0,
                   Status = GetStatus(x.s, x.f)
               })
               .OrderBy(x => x.StockId <= 0)
               .ThenBy(x => x.ExpiryDate)
               .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
              
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage MeatandSeafoodDashboard(int fid) // where (fi.Category == "Meat" || fi.Category == "Seafood")
        {
            try
            {
                var items = (
                     from f in db.Set<FridgeItem>() 
                     join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                     from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                     where (f.Category == "Meat" || f.Category == "Seafood") && f.FridgeId == fid && f.Id != null 
                 select new {  s, f }
             ).ToList()
             .Select(x => new {
                 //    ItemId = x.i.Id,
                 x.f.Name,
                 x.f.Image,
                 x.f.Category,
                 ItemFreezingTime = x.f.FreezingTime,
                 ItemFridgeTime = x.f.FridgeTime,
                 x.f.ItemUnit,
                 FridgeItemId = (int?)x.f?.Id,
                 x.f?.LowStockReminder,
                 x.f?.LowStockReminderUnit,
                 x.f?.DailyConsumption,
                 x.f?.DailyConsumptionUnit,
                 x.f?.ExpiryReminder,
                 UserFreezingTime = x.f?.FreezingTime,
                 UserFridgeTime = x.f?.FridgeTime,
                 Quantity = x.s?.Quantity ?? 0,
                 QuantityUnit = x.s?.QuantityUnit,
                 PurchaseDate = x.s?.PurchaseDate,
                 ExpiryDate = x.s?.ExpiryDate,
                 IsFrozen = x.s?.IsFrozen ?? false,
                 StockId = x.s?.Id ?? 0,
                 Status = GetStatus(x.s, x.f)
             })
             .OrderBy(x => x.StockId <= 0)
             .ThenBy(x => x.ExpiryDate)
             .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage DairyDashboard(int fid) //where (fi.Category == "Dairy")
        { 
            try
            {
                var items = (
                    from f in db.Set<FridgeItem>()
                    join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                    from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                    where (f.Category == "Dairy" ) && f.FridgeId == fid && f.Id != null 
               select new {  s, f }
           ).ToList()
           .Select(x => new {
               //    ItemId = x.i.Id,
               x.f.Name,
               x.f.Image,
               x.f.Category,
               ItemFreezingTime = x.f.FreezingTime,
               ItemFridgeTime = x.f.FridgeTime,
               x.f.ItemUnit,
               FridgeItemId = (int?)x.f?.Id,
               x.f?.LowStockReminder,
               x.f?.LowStockReminderUnit,
               x.f?.DailyConsumption,
               x.f?.DailyConsumptionUnit,
               x.f?.ExpiryReminder,
               UserFreezingTime = x.f?.FreezingTime,
               UserFridgeTime = x.f?.FridgeTime,
               Quantity = x.s?.Quantity ?? 0,
               QuantityUnit = x.s?.QuantityUnit,
               PurchaseDate = x.s?.PurchaseDate,
               ExpiryDate = x.s?.ExpiryDate,
               IsFrozen = x.s?.IsFrozen ?? false,
               StockId = x.s?.Id ?? 0,
               Status = GetStatus(x.s, x.f)
           })
           .OrderBy(x => x.StockId <= 0)
           .ThenBy(x => x.ExpiryDate)
           .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage OthersDashboard(int fid) //where (fi.Category == "Other")
        {
            try
            {
                var items = ( 
                    from f in db.Set<FridgeItem>() 
                    join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                    from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                    where (f.Category == "Other") && f.FridgeId == fid && f.Id != null
                    select new {  s, f }
             ).ToList()
             .Select(x => new {
                 //    ItemId = x.i.Id,
                 x.f.Name,
                 x.f.Image,
                 x.f.Category,
                 ItemFreezingTime = x.f.FreezingTime,
                 ItemFridgeTime = x.f.FridgeTime,
                 x.f.ItemUnit,
                 FridgeItemId = (int?)x.f?.Id,
                 x.f?.LowStockReminder,
                 x.f?.LowStockReminderUnit,
                 x.f?.DailyConsumption,
                 x.f?.DailyConsumptionUnit,
                 x.f?.ExpiryReminder,
                 UserFreezingTime = x.f?.FreezingTime,
                 UserFridgeTime = x.f?.FridgeTime,
                 Quantity = x.s?.Quantity ?? 0,
                 QuantityUnit = x.s?.QuantityUnit,
                 PurchaseDate = x.s?.PurchaseDate,
                 ExpiryDate = x.s?.ExpiryDate,
                 IsFrozen = x.s?.IsFrozen ?? false,
                 StockId = x.s?.Id ?? 0,
                 Status = GetStatus(x.s, x.f)
             })
             .OrderBy(x => x.StockId <= 0)
             .ThenBy(x => x.ExpiryDate)
             .ToList();


                string GetStatus(Stock stock, FridgeItem fridgeItem)
                {
                    if (stock == null || stock.ExpiryDate == null)
                    {
                        return null;
                    }

                    DateTime now = DateTime.Now;
                    DateTime expiryReminderDate;

                    if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
                    {
                        expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
                    }
                    else
                    {
                        expiryReminderDate = stock.ExpiryDate.Value;
                    }

                    if (now > expiryReminderDate)
                    {
                        if (stock.ExpiryDate < now)
                        {
                            return "Expired";
                        }
                        else
                        {
                            return "ExpiringSoon";
                        }
                    }
                    else
                    {
                        return "Good";
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, items);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }










        // ===============TASK====================
              private List<string> GetRecipeNames(int fridgeItemId)
          //   private string GetRecipeNames(int fridgeItemId)
        {
            var recipeNames = (
                from rec in db.Set<Recipe>()
                join i in db.Set<Ingredient>() on rec.Id equals i.RecipeId into grouping
                from i in grouping.DefaultIfEmpty()
                join fi in db.Set<FridgeItem>() on i.FridgeItemId equals fi.Id
                where fi.Id == fridgeItemId
                select rec.Name
            ).ToList();

            string concatenatedNames = string.Join(", ", recipeNames);
           // return concatenatedNames;
            return recipeNames;
        }

        public HttpResponseMessage GetExpiringItems(int fid)
        {
            try
            {
                var expiringItems = (
                    from f in db.Set<FridgeItem>() 
                    join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                    from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                    where f.FridgeId == fid && f.Id != null && s != null && s.Quantity > 0
                    select new { s, f }
                ).ToList()
                .Select(x => new {
                    //x.f.Name,  
                    //Quantity = x.s?.Quantity ?? 0,
                    //QuantityUnit = x.s?.QuantityUnit, 
                    //ExpiryDate = x.s?.ExpiryDate, 
                    //StockId = x.s?.Id ?? 0,
                    //Status = x.s != null ? GetStatus(x.s, x.f) : null ,
                    //FridgeItemId = x.f.Id,
                    x.f.Name,
                    x.f.Image,
                    x.f.Category,
                    ItemFreezingTime = x.f.FreezingTime,
                    ItemFridgeTime = x.f.FridgeTime,
                    x.f.ItemUnit,
                    FridgeItemId = (int?)x.f?.Id,
                    x.f?.LowStockReminder,
                    x.f?.LowStockReminderUnit,
                    x.f?.DailyConsumption,
                    x.f?.DailyConsumptionUnit,
                    x.f?.ExpiryReminder,
                    UserFreezingTime = x.f?.FreezingTime,
                    UserFridgeTime = x.f?.FridgeTime,
                    Quantity = x.s?.Quantity ?? 0,
                    QuantityUnit = x.s?.QuantityUnit,
                    PurchaseDate = x.s?.PurchaseDate,
                    ExpiryDate = x.s?.ExpiryDate,
                    IsFrozen = x.s?.IsFrozen ?? false,
                    StockId = x.s?.Id ?? 0,
                    Status = GetStatus(x.s, x.f),
                    RecipeNames = GetRecipeNames(x.f.Id),

                })
                .Where(x => x.Status == "ExpiringSoon")
                .OrderBy(x => x.StockId <= 0)
                .ThenBy(x => x.ExpiryDate)
                .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, expiringItems);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        private string GetStatus(Stock stock, FridgeItem fridgeItem)
        {
            if (stock.ExpiryDate == null)
            {
                return null;
            }

            DateTime now = DateTime.Now;
            DateTime expiryReminderDate;

            if (fridgeItem != null && fridgeItem.ExpiryReminder != null)
            {
                expiryReminderDate = stock.ExpiryDate.Value.AddDays(-(double)fridgeItem.ExpiryReminder);
            }
            else
            {
                expiryReminderDate = stock.ExpiryDate.Value;
            }

            if (now > expiryReminderDate)
            {
                if (stock.ExpiryDate < now)
                {
                    return "Expired";
                }
                else
                {
                    return "ExpiringSoon";
                }
            }
            else
            {
                return "Good";
            }
        }



        public HttpResponseMessage GetExpiring(int fid)
        {
            try
            {
                var expiringItems = (
                    from f in db.Set<FridgeItem>()
                    join s in db.Set<Stock>() on f.Id equals s.FridgeItemId into stockGroup
                    from s in stockGroup.Where(x => x.FridgeItemId == f.Id && f.FridgeId == fid).DefaultIfEmpty()
                    where f.FridgeId == fid && f.Id != null && s != null && s.Quantity > 0
                    select new { s, f }
                ).ToList()
                .Select(x => new {
                    x.f.Name,
                    Quantity = x.s?.Quantity ?? 0,
                    QuantityUnit = x.s?.QuantityUnit,
                    ExpiryDate = x.s?.ExpiryDate,
                    StockId = x.s?.Id ?? 0,
                    Status = x.s != null ? GetStatus(x.s, x.f) : null,
                    FridgeItemId = x.f.Id,

                    RecipeNames = GetRecipeNames(x.f.Id),

                })
                .Where(x => x.Status == "ExpiringSoon")
                .OrderBy(x => x.StockId <= 0)
                .ThenBy(x => x.ExpiryDate)
                .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, expiringItems);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

    }
}




