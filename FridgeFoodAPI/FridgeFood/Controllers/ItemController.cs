using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class ItemController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();

        [HttpGet]
        public HttpResponseMessage Cooked(int fid)
        {
            try
            {

                var fv = (from i in db.Items
                          join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                          from subfi in gj.DefaultIfEmpty()
                          where i.Category == "Cooked"
                          orderby (subfi == null) ascending
                          select new
                          {
                              Id = i.Id,
                              Name = i.Name,
                              Image = i.Image,
                              Added = (subfi != null) ? "added" : "",
                              FridgeItemId = (subfi != null) ? subfi.Id : 0
                          }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, fv);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage AllFruitsandVegetables(int fid)
        {
            try
            {

                var fv = (from i in db.Items
                          join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                          from subfi in gj.DefaultIfEmpty()
                          where i.Category == "Fruit" || i.Category == "Vegetable"
                          orderby (subfi == null) ascending
                          select new
                          {
                              Id = i.Id,
                              Name = i.Name,
                              Image = i.Image, 
                              Added = (subfi != null) ? "added" : "",
                              FridgeItemId = (subfi != null) ? subfi.Id : 0
                          }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, fv);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage MeatandSeafood(int fid)
        {
            try
            {
                var ms = (from i in db.Items
                          join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                          from subfi in gj.DefaultIfEmpty()
                          where i.Category == "Meat" || i.Category == "Seafood"
                          orderby (subfi == null) ascending
                          select new
                          {
                              Id = i.Id,
                              Name = i.Name,
                              Image = i.Image,
                              Added = (subfi != null) ? "added" : "",
                              FridgeItemId = (subfi != null) ? subfi.Id : 0
                          }).ToList();
               
                return Request.CreateResponse(HttpStatusCode.OK, ms);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage EggsandBakery(int fid)
        {
            try
            {

                var eb = (from i in db.Items
                          join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                          from subfi in gj.DefaultIfEmpty()
                          where i.Category == "Eggs" || i.Category == "Bakery"
                          orderby (subfi == null) ascending
                          select new
                          {
                              Id = i.Id,
                              Name = i.Name,
                              Image = i.Image,
                              Added = (subfi != null) ? "added" : "",
                              FridgeItemId = (subfi != null) ? subfi.Id : 0
                          }).ToList();
               
                return Request.CreateResponse(HttpStatusCode.OK, eb);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage Dairy(int fid)
        {
            try
            {

                var d = (from i in db.Items
                          join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                          from subfi in gj.DefaultIfEmpty()
                          where i.Category == "Dairy"
                          orderby (subfi == null) ascending
                          select new
                          {
                              Id = i.Id,
                              Name = i.Name,
                              Image = i.Image,
                              Added = (subfi != null) ? "added" : "",
                              FridgeItemId = (subfi != null) ? subfi.Id : 0
                          }).ToList();

               
                return Request.CreateResponse(HttpStatusCode.OK, d);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage Others(int fid)
        {
            try
            {

                var d = (from i in db.Items
                         join fi in db.FridgeItems.Where(x => x.FridgeId == fid) on i.Id equals fi.ItemId into gj
                         from subfi in gj.DefaultIfEmpty()
                         where i.Category == "Other"
                         orderby (subfi == null) ascending
                         select new
                         {
                             Id = i.Id,
                             Name = i.Name,
                             Image = i.Image,
                             Added = (subfi != null) ? "added" : "",
                             FridgeItemId = (subfi != null) ? subfi.Id : 0
                         }).ToList();


                return Request.CreateResponse(HttpStatusCode.OK, d);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
