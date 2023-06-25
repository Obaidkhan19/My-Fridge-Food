using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class NotificationController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();
        
       
        [HttpGet]
        public HttpResponseMessage GetMeals(int fiid)
        {
            try
            {
                var sortOrder = new Dictionary<string, int>
             {
              { "Breakfast", 0 },
              { "Lunch", 1 },
              { "Dinner", 2 }
             };

                var sortedMeals = db.RecipeNotifications
     .Where(r => r.FridgeId == fiid && r.Reply == "ok")
     .Join(db.Recipes,
         rn => rn.RecipeId,
         r => r.Id,
         (rn, r) => new {
             Notification = rn,
             Recipe = r,
             MealTime = rn.MealTime
         })
     .ToList() // materialize the data into memory
     .Select(m => new {
         Notification = m.Notification,
         Recipe = m.Recipe,
         SortOrder = sortOrder.ContainsKey(m.MealTime) ? sortOrder[m.MealTime] : 3
     })
     .OrderBy(m => m.SortOrder)
     .OrderBy(m => m.Notification.MealDate)
     .ThenBy(m => m.Notification.MealDate)
     .ToList();


                var meals = sortedMeals
       .GroupBy(m => m.Notification.MealDate)
       .Select(g => new {
           MealDate = g.Key,
           Meals = g.Select(m => new {
               RecipeId = m.Recipe.Id,
               m.Recipe.Name,
               m.Recipe.Image,
               m.Recipe.Servings,
               NotificationId = m.Notification.Id,
               //m.Notification.Body,
               m.Notification.MealTime,
              // m.Notification.MealDate
           })
       })
       .ToList(); 

                return Request.CreateResponse(HttpStatusCode.OK, meals);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage DeleteNotifications()
        {
            try
            {
                var dateToCompare = DateTime.Now.AddDays(-1);
                var notificationsToDelete = db.RecipeNotifications.Where(n => n.MealDate < dateToCompare); 
                db.RecipeNotifications.RemoveRange(notificationsToDelete);
                int rowsAffected = db.SaveChanges();

                return Request.CreateResponse(HttpStatusCode.OK, $"{rowsAffected} rows deleted.");
                 
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage AllNotifications()
        {
            try
            {
                var notification = db.RecipeNotifications.ToList();
                return Request.CreateResponse(HttpStatusCode.OK, notification);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage notificationCount(int uid, int fid)
        {
            try
            {
                var notificationcount = (from n in db.Set<RecipeNotification>()
                                    where (n.SenderId == uid || n.RecieverId == uid) && (n.FridgeId == fid)
                                    select n).Count();



                return Request.CreateResponse(HttpStatusCode.OK, notificationcount);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ViewNotification(int uid, int fid)  
        {
            try
            {
                var notification = from n in db.Set<RecipeNotification>()
                                   join u1 in db.Set<User>()
                                      on n.RecieverId equals u1.Id into recievergrouping
                                   from u1 in recievergrouping.DefaultIfEmpty()
                                   join u2 in db.Set<User>()
                                     on n.SenderId equals u2.Id into sendergrouping
                                   from u2 in sendergrouping.DefaultIfEmpty()
                                   where (n.SenderId == uid || n.RecieverId == uid) && (n.FridgeId == fid)
                                   orderby n.Date descending
                                   select new
                                   {
                                       n.Id,
                                       n.Title,
                                       n.Body,
                                       n.Reply,
                                         n.MealDate,
                                       SenderName = u2.Name,
                                       n.SenderId,
                                       RecieverName = u1.Name,
                                       n.RecieverId,
                           };
                return Request.CreateResponse(HttpStatusCode.OK, notification);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        /*
        [HttpGet]
        public HttpResponseMessage ViewRecieveNotification(int id)  // ap ko kis kis na noti bejhi
        {
            try
            {
                var notification = from n in db.Set<Notification>()
                                   join u in db.Set<User>()
                                     on n.SenderId equals u.Id into grouping
                                   from u in grouping.DefaultIfEmpty()
                                   where n.RecieverId == id
                                   select new
                                   {
                                       nid = n.Id,
                                       title = n.Title,
                                       body = n.Body,
                                       reply = n.Reply, 
                                       date = n.Date,
                                       Sender = u.Name,
                                   };
                return Request.CreateResponse(HttpStatusCode.OK, notification);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        */
        [HttpPost]
        public HttpResponseMessage AddNotification(RecipeNotification notification)
        {
            try
            {
                // data time autogenerated
               DateTime localDate = DateTime.Now;
               notification.Date = localDate;
                // reply and isseen not add from here
                db.RecipeNotifications.Add(notification);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Sent");
                
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage AddMeal(RecipeNotification notification)
        {
            try
            {
                // data time autogenerated
                DateTime localDate = DateTime.Now;
                notification.Date = localDate;
                db.RecipeNotifications.Add(notification);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Sent");

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpPost]
        public HttpResponseMessage NotificationReply(String reply, int nid)    // n id
        {
            try
            {
                //db.Notifications.SqlQuery("Update Notification set Reply=@p0 where Id=@p1",reply,nid);
                var notification = db.RecipeNotifications.FirstOrDefault(n => n.Id == nid);
                notification.Reply = reply;
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Replied");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        /*
        [HttpPost]
        public HttpResponseMessage NotificationSeen( int nid)    // n id
        {
            try
            { 
                var notification = db.Notifications.FirstOrDefault(n => n.Id == nid);
                notification.IsSeen = true;
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "seen");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        */
        // delete  = notification /    delete = reply
        [HttpGet]
        public HttpResponseMessage DeleteNotification(int nid)
        {
            try
            {
                var noti = db.RecipeNotifications.FirstOrDefault(fi => fi.Id == nid);
                if (noti == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
                db.RecipeNotifications.Remove(noti);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage DeleteReply(int nid)
        {
            try
            {
                var noti = db.RecipeNotifications.FirstOrDefault(fi => fi.Id == nid);
                if (noti == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
                else if (noti.Reply == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "noreply");
                }
                else
                {
                    noti.Reply = null;
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "deleted");
                }

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

    }
}
