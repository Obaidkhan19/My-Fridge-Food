using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class FridgeController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();


        [HttpGet]
        public HttpResponseMessage AllFridges()
        {
            try
            {
                
                var f = db.Fridges.ToList(); //users array with all users data
                return Request.CreateResponse(HttpStatusCode.OK, f);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage FridgeDetail(int fid)
        {
            try
            {
                var f = db.Fridges.Where(a => a.Id == fid).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, f);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        


        string Generate()
        {
            var random = new Random();
            var no = random.Next(100, 999); 
            var randomAlphabets = Enumerable.Range(0, 3).Select(x => (char)('a' + random.Next(26))).ToArray();
            return string.Join("", randomAlphabets) + string.Join("",no);
        }

     
         // new
        [HttpPost]
        public HttpResponseMessage CreateFridge(String name,bool dailyuse, int userid, int freezertype)
        {
            try
            {  
            var connectionid = Generate(); 
                var cid = db.Fridges.Where(s => s.ConnectionId == connectionid).FirstOrDefault();
                if (cid != null)
                { 
                    return Request.CreateResponse(HttpStatusCode.Redirect, "CreatedFridge");
                }
                else {
                    Fridge f = new Fridge();
                    f.ConnectionId = connectionid;
                    f.Name = name;
                    f.AllDailyConsumption = dailyuse;
                    f.FreezerType = freezertype;
                    db.Fridges.Add(f);
                    db.SaveChanges();
                    FridgeUser fu = new FridgeUser();
                    var newfridge = db.Fridges.Where(s => s.ConnectionId == connectionid).FirstOrDefault();
                    fu.UserId = userid;
                    fu.Role = "owner";
                    fu.FridgeId = newfridge.Id;
                    db.FridgeUsers.Add(fu);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Created");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        

    [HttpPost]
    public HttpResponseMessage JoinFridge(int uid, String connectionid)
    {
             try
            {
                var fridge = db.Fridges.FirstOrDefault(f => f.ConnectionId == connectionid);
                if (fridge == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK,"wrongid");
                }
                bool alreadyConnected = db.FridgeUsers.Any(a => a.UserId == uid && a.FridgeId == fridge.Id);
                if (alreadyConnected)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "AlreadyConnected");
                } 
                FridgeUser fu = new FridgeUser();
                int fid = fridge.Id;
                fu.UserId = uid;
                fu.FridgeId = fid;
                db.FridgeUsers.Add(fu);
                db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK,"joined");
                
            }
            catch (Exception ex)
        {
            return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        }
    }

        [HttpGet]
        public HttpResponseMessage JoinFridgenewuser(int uid, String connectionid)
        {
            try
            {
                var fridge = db.Fridges.FirstOrDefault(f => f.ConnectionId == connectionid);
                if (fridge == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "wrongid");
                }
                
                FridgeUser fu = new FridgeUser();
                int fid = fridge.Id;
                fu.UserId = uid;
                fu.FridgeId = fid;
                db.FridgeUsers.Add(fu);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, fu);

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        /*
       [HttpGet]
       public HttpResponseMessage DisconnectFridge(int id)
       {
           try
           {
               var user = db.Users.FirstOrDefault(u => u.Id == id);
               if (user == null)
               {
                   return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
               }
               else if (user.FridgeId == null)
               {
                   return Request.CreateResponse(HttpStatusCode.OK, "AlreadyDisconnected");
               }
               else {
                   user.FridgeId = null;
                   db.SaveChanges();
                   return Request.CreateResponse(HttpStatusCode.OK, "DisconnectedSucessfully");
               }

           }
           catch (Exception ex)
           {
               return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
           }
       }
       */

        [HttpGet]
        public HttpResponseMessage LeaveFridge(int fuid)
        {
            try
            {
                var fridgeuser = db.FridgeUsers.FirstOrDefault(u => u.Id == fuid);
                if (fridgeuser == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                } 
                db.FridgeUsers.Remove(fridgeuser);
                db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "DisconnectedSucessfully");
               

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

     

   [HttpPost]
   public HttpResponseMessage EditFridge(Fridge fridge)
   {
       try
       {
           var fridge1 = db.Fridges.FirstOrDefault(f => f.Id == fridge.Id);
           if (fridge1 == null)
           {
               return Request.CreateResponse(HttpStatusCode.NotFound, "Doesnotexist");
           }
           // if fridge found
           fridge1.Name = fridge.Name;
          fridge1.AllDailyConsumption = fridge.AllDailyConsumption;
                fridge1.FreezerType = fridge.FreezerType;
           db.SaveChanges();
           return Request.CreateResponse(HttpStatusCode.OK, "Updated");
       }
       catch (Exception ex)
       {
           return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
       }
   }
 
    }

}
