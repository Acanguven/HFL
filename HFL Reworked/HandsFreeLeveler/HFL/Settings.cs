using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.IO;
using System.Collections.ObjectModel;

namespace HandsFreeLeveler
{
    public static class Settings
    {
        public static int maxSmurf { get; set; }
        public static bool disableGpu { get; set; }
        public static bool buyBoost { get; set; }
        public static bool firstTime { get; set; }
        public static string bolPath { get; set; }
        public static string gamePath { get; set; }
        public static LoLLauncher.QueueTypes queueType = LoLLauncher.QueueTypes.INTRO_BOT;
        public static string dllPath { get; set; }
        public static string championId = "";
        public static string spell1 = "GHOST";
        public static string spell2 = "HEAL";
        public static bool rndSpell = false;
        public static int version = 1;
        public static string language = "English";

        public static void update()
        {

            var xs = new XmlSerializer(typeof(ObservableCollection<Smurf>));

            // serialize to disk
            using (Stream s = File.Create("Smurfs.xml"))
            {
                xs.Serialize(s, App.smurfList);
            }

            XDocument settings = new XDocument(
                   new XElement("HFL",
                       new XElement("Account",
                           new XElement("Username", User.username),
                           new XElement("Password", User.password)
                       ),
                       new XElement("Paths",
                           new XElement("BolPath", bolPath),
                           new XElement("GamePath", gamePath)
                       ),
                       new XElement("Settings",
                           new XElement("MaxSmurf", maxSmurf),
                           new XElement("DisableGpu", disableGpu),   
                           new XElement("BuyBoost", buyBoost), 
                           new XElement("FirstTime", firstTime)
                       ),
                       new XElement("Smurfs", App.smurfList)
                   )
               );
            settings.Save("settings.xml");
        }
    }
}
