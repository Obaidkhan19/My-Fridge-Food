using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class UserController : ApiController
    {

         
FridgefoodEntities db = new FridgefoodEntities();
        [HttpGet]
        public HttpResponseMessage AllUsers()
        {
            try
            { 
                // var r = from u in db.Users join f in db.Fridges on u.Id equals 
                // select* from user
                var users = db.Users.ToList(); //users array with all users data
                return Request.CreateResponse(HttpStatusCode.OK, users);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage GetAllConnectedUsersByFridgeId(int fid,int uid)
        {
            try
            {

                var users = from fu in db.FridgeUsers
                            join u in db.Users on fu.UserId equals u.Id
                            where fu.FridgeId == fid && fu.UserId != uid
                            select new { UserId = fu.UserId, Name = u.Name, Id =fu.Id, Role = fu.Role };
                // var users = db.FridgeUsers.Where(s => s.FridgeId == fid);
                
                return Request.CreateResponse(HttpStatusCode.OK, users);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage UserAllFridges(int uid)
        {
            try
            {
                //fridge and username also
                var fridges = db.FridgeUsers
                .Where(f => f.UserId == uid)
               .Join(db.Users, f => f.UserId, u => u.Id, (f, u) => new { f, u })
                .Join(db.Fridges, fu => fu.f.FridgeId, fr => fr.Id, (fu, fr) => new { fu, fr })
                .Select(x => new {
                    Id = x.fu.f.Id,
                    FridgeName = x.fr.Name,  
                    Role = x.fu.f.Role,
                    FridgeId = x.fu.f.FridgeId,
                    FreezerType = x.fr.FreezerType,
                })
                 .ToList();
                //  var fridges = db.FridgeUsers.Where(f => f.UserId == uid).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, fridges);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage RegisterUser(User user)
        {
            try
            {
                string email = user.Email;
                var users = db.Users.Where(s => s.Email == email).FirstOrDefault();
                if (users != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Exist");
                }
                else
                {
                    db.Users.Add(user);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Created");
                }
                // inset into user

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage Login(string email, string password)
        {
            try

            {
                var user = db.Users.Where(s => s.Email == email && s.Password == password).FirstOrDefault();
                if (user == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "false");

                }
                return Request.CreateResponse(HttpStatusCode.OK, user);

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }

       
        [HttpPost]
        public HttpResponseMessage EditUser(User user)
        {
            try
            {
                var user1 = db.Users.FirstOrDefault(u => u.Id == user.Id);
                if (user1 == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnotexist");
                }
                // if user found
                user1.Name = user.Name;
                user1.Email = user.Email;
                user1.Password = user.Password;
                db.SaveChanges();
                // return Request.CreateResponse(HttpStatusCode.OK, "Updated");
                return Request.CreateResponse(HttpStatusCode.OK, user1);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage MakeAdmin(int fuid)
        {
            try
            {
                var fridgeuser = db.FridgeUsers.FirstOrDefault(i => i.Id == fuid);

                if (fridgeuser == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                fridgeuser.Role = "admin";
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Ok");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage MakeOwner(int fuid)
        {
            try
            {
                var fridgeuser = db.FridgeUsers.FirstOrDefault(i => i.Id == fuid);

                if (fridgeuser == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                fridgeuser.Role = "owner";
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Ok");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage RemoveAdmin(int fuid)
        {
            try
            {
                var fridgeuser = db.FridgeUsers.FirstOrDefault(i => i.Id == fuid);

                if (fridgeuser == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "doesnot");
                }
                fridgeuser.Role = null;
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Ok");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
