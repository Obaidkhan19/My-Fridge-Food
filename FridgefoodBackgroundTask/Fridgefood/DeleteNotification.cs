using System;
using System.Linq;
using System.Threading; 

namespace Fridgefood
{
   public class DeleteNotification
    {

        // DELETE MEAL NOTIFICATION 
        public static void DeleteNotificationsThread()
        {
            while (true)
            {
                string result = DeleteNotifications();
                Console.WriteLine($"Delete Meal Notification :{DateTime.Now}: {result}");
                Thread.Sleep(TimeSpan.FromHours(12));
               // Thread.Sleep(TimeSpan.FromMinutes(1));
            }
        }
        static string DeleteNotifications()
        {
            FridgefoodEntities db = new FridgefoodEntities();
            try
            {
                var dateToCompare = DateTime.Now.AddDays(-1);
                var notificationsToDelete = db.RecipeNotifications.Where(n => n.MealDate < dateToCompare);
                db.RecipeNotifications.RemoveRange(notificationsToDelete);
                int rowsAffected = db.SaveChanges();

                return $"{rowsAffected} rows deleted. ";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
    }
}
