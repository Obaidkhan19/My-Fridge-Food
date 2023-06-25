using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class ShoppingListController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();

        [HttpGet]
        public HttpResponseMessage ShoppinglistCounter(int fid)
        {
            try
            {
                //  var shoppinglist = db.ShoppingLists.Where(s => s.FridgeId == fid).ToList(); 
                var slist = db.ShoppingLists.Where(s => s.FridgeId == fid && (s.ReplierId ==null || s.ReplierId == 0)).ToList();
                var count = slist.Count;
                return Request.CreateResponse(HttpStatusCode.OK, count);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage AllShoppinglist(int fid)
        {
            try
            {
                //  var shoppinglist = db.ShoppingLists.Where(s => s.FridgeId == fid).ToList(); 
                var shoppinglist = from s in db.Set<ShoppingList>()
                                   join u1 in db.Set<User>()
                                    on s.SenderId equals u1.Id into senderJoin  // use into keyword to create a new variable to represent the joined table
                                   from sender in senderJoin.DefaultIfEmpty() // use DefaultIfEmpty() method to ensure that a row is returned even if there is no match
                                   join u2 in db.Set<User>()
                                   on s.ReplierId equals u2.Id into replierJoin  // same modifications for the second join
                                   from replier in replierJoin.DefaultIfEmpty()
                                   where s.FridgeId == fid
                                   orderby s.Date descending
                                   select new
                                  {
                                       s.Id,
                                       s.SenderId,
                                       s.ReplierId,
                                       s.Body,
                                       s.Date,
                                       SenderName = sender.Name,
                                       ReplierName = replier.Name, 
                                       s.Header,
                                  };

                return Request.CreateResponse(HttpStatusCode.OK, shoppinglist);
            }

            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage AddToShoppinglistManually(ShoppingList shoppinglist)
        {
            try
            { 
                DateTime localDate = DateTime.Now;
                shoppinglist.Date = localDate;
                db.ShoppingLists.Add(shoppinglist);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage DeleteOrder(int oid)
        {
            try
            {
                var order = db.ShoppingLists.FirstOrDefault(i => i.Id == oid);

                if (order == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                db.ShoppingLists.Remove(order);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage replyOrder(ShoppingList shoppinglist)
        {
            try
            {
                int oid = shoppinglist.Id;
                var order = db.ShoppingLists.FirstOrDefault(i => i.Id == oid);

                if (order == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                order.ReplierId = shoppinglist.ReplierId; 
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Ok");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage cancelReply(int id)
        {
            try
            {
                int oid = id;
                var order = db.ShoppingLists.FirstOrDefault(i => i.Id == oid);
                if (order == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                order.ReplierId = 0;
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Cancel");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
