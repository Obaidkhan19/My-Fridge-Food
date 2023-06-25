using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using System.Threading;
using Fridgefood;

namespace DeleteNotificationsConsoleApp
{
    class Program
    {

        static void Main(string[] args)
        {
            // DELETE MEAL NOTIFICATION THREAD
            //Thread thread = new Thread(new ThreadStart(DeleteNotification.DeleteNotificationsThread));
            //thread.Start();


            //Console.WriteLine("Press any key to exit...");
            //Console.ReadKey();

            //  low stock

            //while (true)
            //{
            //    LowStock.GetLowStockItems();
            //    Thread.Sleep(1000);
            //    //  thread.sleep(timespan.fromminutes(1)); 
            //}

            var delayDuration = new TimeSpan(1, 15, 30);
            var task = Task.Run(async () =>
            {
             //  await Task.Delay(15000);
              //  await task.delay(timespan.fromminutes(1));
             //   await task.delay(timespan.fromhours(1));
             //   await task.delay(delayduration);
                while (true)
                {
                    var consumeditems = DailyConsumption.DailyConsume();

                    foreach (var item in consumeditems)
                    {
                        Console.WriteLine($"consumed: {item.Quantity} {item.QuantityUnit} of {item.Name} in fridge {item.FridgeId}");
                    }

                    //  await Task.Delay(15000); // delay for 15 seconds
                    await Task.Delay(TimeSpan.FromHours(1));
                }
            });

            task.Wait();


        
        }
    }
    }
