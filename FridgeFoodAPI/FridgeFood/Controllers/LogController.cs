using FridgeFood.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace FridgeFood.Controllers
{
    public class LogController : ApiController
    {
        FridgefoodEntities db = new FridgefoodEntities();

        /*
        [HttpGet]
        public HttpResponseMessage AllLogs(int fid, int iid)
        {
            try
            {
               
                var logs = db.ConsumptionLogs.Where(f => f.FridgeId ==fid && f.ItemId ==iid).OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }s
        */
        [HttpGet]
        public HttpResponseMessage UserLogs(int fid, int iid,int uid )
        {
            try
            { 
                var logs = db.ConsumptionLogs.Where(f => f.FridgeId == fid && f.UserId == uid && f.FridgeItemId == iid).OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        //http://localhost/FridgeFood/api/log/AllLogswithfilter?fiid=8&sd=2023-03-10&ed=2023-03-15

        [HttpGet]
        public HttpResponseMessage AllLogswithfilter(int fiid, DateTime sd, DateTime ed)
        {
            try
            {
                var startDate = sd.Date;
                var endDate = ed.Date.AddDays(1); // Add 1 day to include the end date in the range

                var logs = db.ConsumptionLogs
                    .Where(log => log.FridgeItemId == fiid &&
                        log.Date >= startDate && log.Date < endDate)
                    .OrderByDescending(log => log.Date)
                    .ToList();

                var sumQuantity = logs.Sum(log => log.Quantity) ?? 0.0;
                decimal totalQuantity = (decimal)sumQuantity;

                var logsWithTotalQuantity = logs.Select(log => new
                {
                    log.Id,
                    log.LogData,
                    log.Date,
                    log.Quantity,
                    log.UserId,
                    log.QunatityUnit,
                    log.FridgeItemId,
                    log.FridgeId,
                    TotalQuantity = totalQuantity
                }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, logsWithTotalQuantity);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        //[HttpGet]
        //public HttpResponseMessage AllLogswithfilter(int fiid, DateTime sd, DateTime ed)
        //{
        //    try
        //    {
        //        var startDate = sd.Date;
        //        var endDate = ed.Date.AddDays(1); // Add 1 day to include the end date in the range

        //        var logs = db.ConsumptionLogs
        //            .Where(log => log.FridgeItemId == fiid &&
        //                log.Date >= startDate && log.Date < endDate)
        //            .OrderByDescending(log => log.Date)
        //            .ToList();

        //        return Request.CreateResponse(HttpStatusCode.OK, logs);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}

        //http://localhost/FridgeFood/api/log/Logswithfilter?fiid=8&tf=month

        [HttpGet]
        public HttpResponseMessage LogsWithFilter(int fiid, string tf)
        {
            try
            {
                DateTime startDate, endDate;

                // Calculate the start and end dates based on the timeframe
                if (tf == "week")
                {
                    startDate = DateTime.Today.AddDays(-7); // Start date is 7 days ago
                    endDate = DateTime.Today; // End date is today
                }
                else if (tf == "month")
                {
                    startDate = DateTime.Today.AddMonths(-1); // Start date is 1 month ago
                    endDate = DateTime.Today; // End date is today
                }
                else
                {
                    // Handle unsupported timeframe
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid timeframe. Supported values are 'week' and 'month'.");
                }

                var logs = db.ConsumptionLogs
                    .Where(log => log.FridgeItemId == fiid &&
                        System.Data.Entity.DbFunctions.TruncateTime(log.Date) >= startDate.Date &&
                        System.Data.Entity.DbFunctions.TruncateTime(log.Date) <= endDate.Date)
                    .OrderByDescending(log => log.Date)
                    .ToList();

                var sumQuantity = logs.Sum(log => log.Quantity) ?? 0.0;
                decimal totalQuantity = (decimal)sumQuantity;

                var logsWithTotalQuantity = logs.Select(log => new
                {
                    log.Id,
                    log.LogData,
                    log.Date,
                    log.Quantity,
                    log.UserId,
                    log.QunatityUnit,
                    log.FridgeItemId,
                    log.FridgeId,
                    TotalQuantity = totalQuantity
                }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, logsWithTotalQuantity);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]
        public HttpResponseMessage AdminAllLogs(int fid )
        {
            try
            {

                var logs = db.ConsumptionLogs.Where(f => f.FridgeId == fid ).OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        // 1 ITEM ALL USAGE LOGS
        [HttpGet]
        public HttpResponseMessage AdminItemLogs(int fiid )
        {
            try
            {

                var logs = db.ConsumptionLogs.Where(f => f.FridgeItemId == fiid ).OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


          

        // BIN OF ALL ITEMS  (not used by me)
        [HttpGet]
        public HttpResponseMessage AdminAllBinLogs(int fid)
        {
            try
            {

                //  var blogs = db.Bins.Where(f => f.FridgeId == fid).OrderByDescending(l => l.Date).ToList();
                var blogs = db.Bins
             .Where(f => f.FridgeId == fid)
             .OrderByDescending(l => l.Date)
             .Join(db.FridgeItems, b => b.FridgeItemId, fi => fi.Id, (b, fi) => new { Bin = b, FridgeItem = fi })
           //  .Join(db.Items, bf => bf.FridgeItem.ItemId, i => i.Id, (bf, i) => new { Bin = bf.Bin, LogData = i.Name })
             .Select(bfi => new { bfi.Bin.Id, bfi.Bin.Quantity, bfi.Bin.QuantityUnit, bfi.Bin.Date, bfi.Bin.FridgeItemId, bfi.Bin.FridgeId, LogData = bfi.FridgeItem.Name })
             .OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, blogs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        // BINS OF 1 ITEM
          [HttpGet]
        public HttpResponseMessage ItemBinLogs(int fiid)
        {
            try
            {

                //  var blogs = db.Bins.Where(f => f.FridgeId == fid).OrderByDescending(l => l.Date).ToList();
                var blogs = db.Bins
             .Where(f => f.FridgeItemId == fiid)
             .OrderByDescending(l => l.Date)
             .Join(db.FridgeItems, b => b.FridgeItemId, fi => fi.Id, (b, fi) => new { Bin = b, FridgeItem = fi })
            // .Join(db.Items, bf => bf.FridgeItem.ItemId, i => i.Id, (bf, i) => new { Bin = bf.Bin, LogData = i.Name })
             .Select(bfi => new { bfi.Bin.Id, bfi.Bin.Quantity, bfi.Bin.QuantityUnit, bfi.Bin.Date, bfi.Bin.FridgeItemId, bfi.Bin.FridgeId, LogData = bfi.FridgeItem.Name })
             .OrderByDescending(l => l.Date).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, blogs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        //  [HttpGet]
        //public HttpResponseMessage ChartBinLogs(int fid)
        //{
        //    try
        //    {
        //         var logs = db.Bins
        //             .Where(f => f.FridgeId == fid)
        //             .GroupBy(l => l.FridgeItemId)
        //             .Select(g => new {
        //                 FridgeItemId = g.Key,
        //                 TotalQuantity = g.Sum(l => l.Quantity),
        //                 Name = db.FridgeItems

        //    .Where(fi => fi.Id == g.Key)
        //    .Select(fi => fi.Name)
        //    .FirstOrDefault()
        //             })
        //             .ToList();

        //return Request.CreateResponse(HttpStatusCode.OK, logs);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage ChartConsumptionLogs(int fid)
        {
            try
            {
                var logs = db.ConsumptionLogs
                    .Where(f => f.FridgeId == fid)
                    .GroupBy(l => l.FridgeItemId)
                    .Select(g => new {
                        FridgeItemId = g.Key,
                        TotalQuantity = g.Sum(l => l.QunatityUnit == "kg" ? l.Quantity * 1000 : l.QunatityUnit == "l" ? l.Quantity * 1000 : l.Quantity),
                        Name = db.FridgeItems
           .Where(fi => fi.Id == g.Key)
           .Select(fi => fi.Name)
           .FirstOrDefault(),
                        QuantityUnit = db.FridgeItems
                            .Where(fi => fi.Id == g.Key)
                            .Select(fi => fi.ItemUnit)
                            .FirstOrDefault()
                    })
                    .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ChartBinLogs(int fid)
        {
            try
            { 
                var logs = db.Bins
                    .Where(f => f.FridgeId == fid)
                    .GroupBy(l => l.FridgeItemId)
                    .Select(g => new
                    {
                        FridgeItemId = g.Key,
                        TotalQuantity = g.Sum(l => l.QuantityUnit == "kg" ? l.Quantity * 1000 : l.QuantityUnit == "l" ? l.Quantity * 1000 : l.Quantity),
                       
                        Name = db.FridgeItems
                            .Where(fi => fi.Id == g.Key)
                            .Select(fi => fi.Name)
                            .FirstOrDefault(),
                             QuantityUnit = db.FridgeItems
                            .Where(fi => fi.Id == g.Key)
                            .Select(fi => fi.ItemUnit)
                            .FirstOrDefault()
                    })
                    .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, logs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

    }
}
