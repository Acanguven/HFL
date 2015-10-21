using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HandsFreeLeveler
{
    public class Smurf
    {
        public string username { get; set; }
        public string password { get; set; }
        public LoLLauncher.Region region { get; set; }
        public int level { get; set; }
        public int maxLevel { get; set; }
        public string Status { get; set; }
        internal RiotBot thread { get; set; }

        public void start(){
            thread = new RiotBot(username, password, maxLevel, region.ToString(), Settings.gamePath, Settings.queueType);
        }
    }


}
