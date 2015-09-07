using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ini;
using System.Collections;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Net;
using System.Management;
using LoLLauncher;
using System.Windows.Forms;
using Microsoft.Win32;

namespace HandsFreeLeveler
{
    public class Program
    {

		public static bool QueueValid = true;
        public static string gamePath;
        public static string Region;
        public static List<smurfData> accounts = new List<smurfData>();
        public static List<RiotBot> runningSmurfs = new List<RiotBot>();
        public static int maxBots = 1;
        public static bool replaceConfig =  false;
        public static int connectedAccs = 0;
        public static string championId = "";
        public static int gamesPlayed = 0;
        public static string championId2 = "";
        public static int maxLevel = 31;
        public static string qType = "INTRO_BOT";
        public static bool started = false;
        public static float version = 2.1f;
        public static bool buyBoost = false;
        public static bool rndSpell = false;
        public static string spell1 = "GHOST";
        public static string spell2 = "HEAL";
        public static string cversion = "5.13.15_07_07_21_19";
        public static bool AutoUpdate = true;
        public static bool loggedIn = false;
        public static wsLogin login = new wsLogin();
        public static System.Windows.Forms.Timer timer = new System.Windows.Forms.Timer();
        public static bool LoadGUI = false;
        public static Dashboard homePage;

        [STAThread]
        static void Main(string[] args)
        {
            /* .NET */
            try
            {
                if (File.Exists("HFLOLD.exe"))
                {
                    File.Delete("HFLOLD.exe");
                }
                /* Update */
                UpdateCheck();
                /*Set Registry*/
                registery();
                /* Init starter */
                homePage = new Dashboard();
                trylogin();
                Application.Run(homePage);
            }
            catch (Exception ex)
            {
                string filePath = "Error.txt";
                using (StreamWriter writer = new StreamWriter(filePath, true))
                {
                    writer.WriteLine("Message :" + ex.Message + "<br/>" + Environment.NewLine + "StackTrace :" + ex.StackTrace +
                       "" + Environment.NewLine + "Date :" + DateTime.Now.ToString());
                    writer.WriteLine(Environment.NewLine + "-----------------------------------------------------------------------------" + Environment.NewLine);
                }
                MessageBox.Show("HFL client just crashed and I created a file called 'Errors.txt' in the directory. Please send it to The Law.");
            }

        }

        public static void UpdateCheck()
        {
            Api.getVersion();
        }

        public static void startBotting() {
            int curRunning = 0;
            started = true;
            foreach (smurfData acc in accounts)
            {
                curRunning += 1;
                QueueTypes queuetype = (QueueTypes)System.Enum.Parse(typeof(QueueTypes), qType);
                RiotBot ritoBot = new RiotBot(acc.username, acc.password, acc.maxLevel, Region, gamePath, curRunning, queuetype);
                runningSmurfs.Add(ritoBot);
                if (curRunning == maxBots) { 
                    break;
                }
            }
        
        }

        public static void restartSystem()
        {
            stopBotting();
            registery();
            startBotting();
        }

        public static void stopBotting()
        {
            started = false;
            foreach (RiotBot thread in runningSmurfs)
            {
                thread.connection.Disconnect();
            }
            Thread.Sleep(500);
            runningSmurfs.Clear();
            Thread.Sleep(500);
            
        }

        public static void trylogin()
        {
            RegistryKey regKey = Registry.CurrentUser;
            regKey = regKey.OpenSubKey(@"Software\HFL\Account");
            login.username = regKey.GetValue("Username").ToString();
            login.password = regKey.GetValue("Password").ToString();

            if (login.username == null || login.password == null || (login.username == "null" && login.password == "null")) { 
                login.username = Prompt.ShowDialog("Username", "Authenticating user");
                login.password = Prompt.ShowDialog("Password", "Authenticating user");
            }

            login.key = HWID.Generate();
            Api.checkAuth(login.username, login.key, login.password,homePage);
        }

        /* Websocket Part */
        public class wsLogin
        {
            public string username { get; set; }
            public string password { get; set; }
            public string type { get; set; }
            public string key { get; set; }
        }

        public static String getTimestamp()
        {
           return "[" + DateTime.Now + "] ";
        }

        public static void registery()
        {
            RegistryKey pathkey = Registry.CurrentUser.OpenSubKey("Software", true);
            RegistryKey hflKey = pathkey.OpenSubKey("HFL", true);
            if (hflKey == null) { 
                hflKey = pathkey.CreateSubKey("HFL");
                RegistryKey accountKey = hflKey.CreateSubKey("Account");
                accountKey.SetValue("Username", "null");
                accountKey.SetValue("Password", "null");
                RegistryKey pathKey = hflKey.CreateSubKey("Paths");
                pathKey.SetValue("BOL", "null");
                pathKey.SetValue("GAME", "null");
                pathKey.SetValue("GAMEVERSION", cversion);
            }
            else
            {
                RegistryKey regKey = hflKey.OpenSubKey(@"Paths");
                cversion = regKey.GetValue("GAMEVERSION").ToString();
                gamePath = Path.GetDirectoryName(regKey.GetValue("GAME").ToString() + "\\");
            }            
        }


        public static void gamecfg()
        {
            try
            {

                string path = gamePath + @"Config\\game.cfg";
                FileInfo fileInfo = new FileInfo(path);
                fileInfo.IsReadOnly = false;
                fileInfo.Refresh();
                string str = "[General]\nGameMouseSpeed=9\nEnableAudio=0\nUserSetResolution=0\nBindSysKeys=0\nSnapCameraOnRespawn=0\nOSXMouseAcceleration=1\nAutoAcquireTarget=0\nEnableLightFx=0\nWindowMode=2\nShowTurretRangeIndicators=0\nPredictMovement=0\nWaitForVerticalSync=0\nColors=2\nHeight=10\nWidth=10\nSystemMouseSpeed=0\nCfgVersion=5.5.7\n\n[HUD]\nShowNeutralCamps=0\nDrawHealthBars=0\nAutoDisplayTarget=0\nMinimapMoveSelf=0\nItemShopPrevY=19\nItemShopPrevX=117\nShowAllChannelChat=0\nShowTimestamps=0\nObjectTooltips=0\nFlashScreenWhenDamaged=0\nNameTagDisplay=1\nShowChampionIndicator=0\nShowSummonerNames=0\nScrollSmoothingEnabled=0\nMiddleMouseScrollSpeed=0.5000\nMapScrollSpeed=0.5000\nShowAttackRadius=0\nNumericCooldownFormat=3\nSmartCastOnKeyRelease=0\nEnableLineMissileVis=0\nFlipMiniMap=0\nItemShopResizeHeight=47\nItemShopResizeWidth=455\nItemShopPrevResizeHeight=200\nItemShopPrevResizeWidth=300\nItemShopItemDisplayMode=1\nItemShopStartPane=1\n\n[Performance]\nShadowsEnabled=0\nEnableHUDAnimations=0\nPerPixelPointLighting=0\nEnableParticleOptimizations=0\nBudgetOverdrawAverage=10\nBudgetSkinnedVertexCount=10\nBudgetSkinnedDrawCallCount=10\nBudgetTextureUsage=10\nBudgetVertexCount=10\nBudgetTriangleCount=10\nBudgetDrawCallCount=1000\nEnableGrassSwaying=0\nEnableFXAA=0\nAdvancedShader=0\nFrameCapType=3\nGammaEnabled=1\nFull3DModeEnabled=0\nAutoPerformanceSettings=0\n=0\nEnvironmentQuality=0\nEffectsQuality=0\nShadowQuality=0\nGraphicsSlider=0\n\n[Volume]\nMasterVolume=1\nMusicMute=0\n\n[LossOfControl]\nShowSlows=0\n\n[ColorPalette]\nColorPalette=0\n\n[FloatingText]\nCountdown_Enabled=0\nEnemyTrueDamage_Enabled=0\nEnemyMagicalDamage_Enabled=0\nEnemyPhysicalDamage_Enabled=0\nTrueDamage_Enabled=0\nMagicalDamage_Enabled=0\nPhysicalDamage_Enabled=0\nScore_Enabled=0\nDisable_Enabled=0\nLevel_Enabled=0\nGold_Enabled=0\nDodge_Enabled=0\nHeal_Enabled=0\nSpecial_Enabled=0\nInvulnerable_Enabled=0\nDebug_Enabled=1\nAbsorbed_Enabled=1\nOMW_Enabled=1\nEnemyCritical_Enabled=0\nQuestComplete_Enabled=0\nQuestReceived_Enabled=0\nMagicCritical_Enabled=0\nCritical_Enabled=1\n\n[Replay]\nEnableHelpTip=0";
                StringBuilder builder = new StringBuilder();
                builder.AppendLine(str);
                using (StreamWriter writer = new StreamWriter(gamePath + @"Config\game.cfg"))
                {
                    writer.Write(builder.ToString());
                }
                fileInfo.IsReadOnly = true;
                fileInfo.Refresh();
            }
            catch (Exception exception2)
            {
                //Console.Out.WriteLine("Error -> .cfg Error");
            }
        }

        private static string RandomString(int size)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;
            for (int i = 0; i < size; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
                builder.Append(ch);
            }

            return builder.ToString();
        }

        private static void InitChecks()
        {
            var accountsTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"accounts.txt";
            var configTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"settings.ini";
            var versionTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"version.txt";
        }
   }
}
