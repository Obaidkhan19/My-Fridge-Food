using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class RecipeController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();

        [HttpGet]
        public HttpResponseMessage AllRecipes()
        {
            try
            {
                var recipes = db.Recipes.ToList();
                return Request.CreateResponse(HttpStatusCode.OK, recipes);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
          
        [HttpGet]
        public HttpResponseMessage RecipeDashboard(int fid)
        {
            try
            {
                var recipe = db.Recipes.Where(a => a.FridgeId == fid).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, recipe);
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
                var recipe = db.Recipes.Where(r => r.Id == rid).FirstOrDefault();
                // var fid = recipe.FridgeId;
                var ingredients = from ing in db.Set<Ingredient>()
                                  join fi in db.Set<FridgeItem>()
                                  on ing.FridgeItemId equals fi.Id
                                 // join i in db.Set<Item>()
                // on fi.ItemId equals i.Id
                                  where ing.RecipeId == rid
                                  select new
                                  {
                                      Id = ing.Id,
                                      IngQuantity = ing.Quantity,
                                      IngUnit = ing.Unit,
                                      ItemName = fi.Name,
                                      ItemUnit = fi.ItemUnit,
                                      IngUnitoriginal = ing.Unit,
                                      IngQuantityoriginal = ing.Quantity,
                                      FridgeItemId =fi.Id,
                                      RecipeId = rid,
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

                    double modifiedQuantity = ingredient.IngQuantity ?? 0;
                    string modifiedUnit = ingredient.IngUnit;

                    // Convert ingredient quantity to g or ml based on the unit
                    if (modifiedUnit == "kg")
                    {
                        modifiedQuantity *= 1000;
                        modifiedUnit = "g";
                    }
                    else if (modifiedUnit == "l")
                    {
                        modifiedQuantity *= 1000;
                        modifiedUnit = "ml";
                    }
                    bool Avaliability = true;


                    // IF WHEN I DONT HAVE ENOUGH QUANTITY
                    // 500g 100g
                    if (modifiedQuantity > totalStockQuantity)
                    {
                        Avaliability = false;
                        double missingQuantity = modifiedQuantity - totalStockQuantity;
                        string missingUnit = modifiedUnit;
                        // Convert missing quantity to original unit
                        if (missingUnit == "g")
                        {
                            if (missingQuantity < 1000)
                            {
                                missingUnit = "g";
                            }
                            else
                            {
                                missingQuantity /= 1000;
                                missingUnit = "kg";
                            }
                        }
                        else if (missingUnit == "ml")
                        {
                            if (missingQuantity < 1000)
                            {
                                missingUnit = "ml";
                            }
                            else
                            {
                                missingQuantity /= 1000;
                                missingUnit = "l";
                            }
                        }

                        modifiedQuantity = totalStockQuantity;
                        modifiedUnit = stockQuantityUnit;
                        var modifiedIngredient = new
                        {
                            ingredient.Id,
                            IngQuantity = modifiedQuantity,  // Display in gram
                            IngUnit = modifiedUnit,
                            ingredient.ItemName,
                            ingredient.ItemUnit,
                            ingredient.FridgeItemId,
                            ingredient.IngUnitoriginal,
                            ingredient.IngQuantityoriginal,
                            RecipeId = rid,
                            RequiredQuantity = missingQuantity,
                            RequiredUnit = missingUnit,
                           AvaliableQuantity = totalStockQuantity,
                            AvaliableUnit = stockQuantityUnit,
                            Avaliable = Avaliability,
                        };
                        modifiedIngredients.Add(modifiedIngredient);
                    }
                    else
                    {
                        var modifiedIngredient = new
                        {
                            ingredient.Id,
                           IngQuantity = modifiedQuantity,  // Display original quantity in gram or ml
                            IngUnit = modifiedUnit,
                            ingredient.ItemName,
                            
                            ingredient.FridgeItemId,
                            ingredient.IngUnitoriginal,
                            ingredient.IngQuantityoriginal,
                            RecipeId = rid,
                            RequiredQuantity = 0,
                            RequiredUnit = "",
                           AvaliableQuantity = totalStockQuantity,
                          AvaliableUnit = stockQuantityUnit,
                            Avaliable = Avaliability,

                        };
                        modifiedIngredients.Add(modifiedIngredient);
                    }
                }
                return Request.CreateResponse(HttpStatusCode.OK, modifiedIngredients);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
       public HttpResponseMessage RecipeByIngredientName( int fridgeitemid, int fid) 
       {
           try
           {
               var recipe = from rec in db.Set<Recipe>()
                            join i in db.Set<Ingredient>()
                            on rec.Id equals i.RecipeId into grouping
                            from i in grouping.DefaultIfEmpty()
                            join fi in db.Set<FridgeItem>()
                            on i.FridgeItemId equals fi.Id
                            where fi.Id ==  fridgeitemid && rec.FridgeId == fid
                            select new
                            {
                                Id = rec.Id,
                                Name = rec.Name,
                                Image = rec.Image,
                                Servings = rec.Servings,
                                FridgeId = rec.FridgeId,
                            };
               return Request.CreateResponse(HttpStatusCode.OK, recipe);
           }
           catch (Exception ex)
           {
               return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
           }
       }

        [HttpPost]
        public HttpResponseMessage RecipeAdd()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                var imagefile = request.Files["Image"];
                var name = request.Form["Name"].ToString();

                var servings = request.Form["Servings"];
                var fridgeid = request.Form["FridgeId"];
                int fid = int.Parse(fridgeid);
                
                var recipe = db.Recipes.Where(i => i.Name == name && i.FridgeId ==fid).FirstOrDefault();
                if (recipe != null)
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

                    Recipe r = new Recipe();
                    r.Image = filename;
                    r.Name = name;
                    r.Servings = int.Parse(servings);
                    r.FridgeId = int.Parse(fridgeid);

                    db.Recipes.Add(r);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Successfully");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage IngredientAdd(Ingredient ingredient)
        {
            try
            {
                    db.Ingredients.Add(ingredient);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage DeleteRecipe(int id)  // also delete Ingredients
        {
            try
            {
                var recipe = db.Recipes.FirstOrDefault(r => r.Id == id);

                if (recipe == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                // delete  ing 
                var ing = db.Ingredients.Where(i => i.RecipeId == id).ToList();
                db.Ingredients.RemoveRange(ing);
                //  delete item
                db.Recipes.Remove(recipe);

                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage DeleteIngredient(int id)  
        {
            try
            {
                var ing = db.Ingredients.FirstOrDefault(i => i.Id == id);

                if (ing == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                db.Ingredients.Remove(ing);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        
        [HttpPost]
        public HttpResponseMessage EditRecipe()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                var imagefile = request.Files["Image"];
                var name = request.Form["Name"].ToString();
                var servings = request.Form["Servings"];
                int id = int.Parse(request.Form["Id"]);
               
                var recipe = db.Recipes.FirstOrDefault(r => r.Id == id );
                if (recipe == null)
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
                        imagefile.SaveAs(HttpContext.Current.Server.MapPath("~/Images/" + filename));
                    }
                    else
                    {
                        filename = recipe.Image;
                    }

                    //recipe  initialize above
                    recipe.Image = filename;
                    recipe.Name = name;
                    recipe.Servings = int.Parse(servings);

                   // db.Recipes.Add(recipe);
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
        public HttpResponseMessage EditIngredient(Ingredient ingredient)
        {
            try
            {
                var ingredient1 = db.Ingredients.FirstOrDefault(u => u.Id == ingredient.Id);
                if (ingredient1 == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                // if ingredient found
                ingredient1.Quantity = ingredient.Quantity;
                ingredient1.Unit = ingredient.Unit;
                ingredient1.FridgeItemId = ingredient.FridgeItemId;

                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Updated");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        /*
        [HttpGet]
        public HttpResponseMessage SearchRecipeByName(string name, int fid)
        {
            try
            {
                //var recipe = db.Recipes.SqlQuery("Select r.id, r.Name, r.Image, r.Servings, fi.Id, fi.Name, i.Quantity, i.Unit, r.FridgeId from Recipe r Join  Ingredient i ON r.Id = i.RecipeId join FridgeItem fi on i.FridgeItemId = fi.Id Where r.Name=@p0  and r.FridgeId=@p1", name,id).ToList();

                var recipe = from rec in db.Set<Recipe>()
                             join i in db.Set<Ingredient>()
                             on rec.Id equals i.RecipeId into grouping 
                             from i in grouping.DefaultIfEmpty()
                             join fi in db.Set<FridgeItem>()
                             on i.FridgeItemId equals fi.Id
                             where rec.Name == name && rec.FridgeId == fid
                             select new
                             {
                                 recipeid = rec.Id,
                                 recipename = rec.Name,
                                 recipeimg = rec.Image,
                                 recipeserving = rec.Servings, 
                             };
                return Request.CreateResponse(HttpStatusCode.OK, recipe);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        */

    }
}
