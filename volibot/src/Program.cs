﻿

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ini;
using System.Collections;
using System.IO;
using System.Threading;
using System.Net;
using System.Management;
using LoLLauncher;
using System.Windows.Forms;

namespace RitoBot
{
    public class Program
    {

		public static bool QueueValid = true;
        public static string Path2;
        public static string Region;
        public static ArrayList accounts = new ArrayList();
        public static ArrayList accounts2 = new ArrayList();
        public static int maxBots = 1;
        public static bool replaceConfig =  false;
        public static int connectedAccs = 0;
        public static string championId = "";
        public static string championId2 = "";
        public static int maxLevel = 31;
        public static bool buyBoost = false;
        public static bool rndSpell = true;
        public static string spell1 = "flash";
        public static string spell2 = "ignite";
        public static string cversion = "5.13.15_07_07_21_19";
        public static bool AutoUpdate = false;
        public static bool LoadGUI = false;
        public static frm_MainWindow MainWindow = new frm_MainWindow();


        static void Main(string[] args)
        {
            InitChecks();
            loadVersion();
            loadConfiguration();
            if (replaceConfig)
            {
                gamecfg();
            }
            while (!File.Exists(Path2 + "lol.launcher.exe"))
            {
                Console.Out.WriteLine();
                Console.Out.WriteLine("Error -> Launcher settings");
                Console.Out.WriteLine();
                System.Threading.Thread.Sleep(5000);
                loadConfiguration();
            }
            ReloadAccounts:
            loadAccounts();
            int curRunning = 0;
            if (LoadGUI) MainWindow.ShowDialog();
            if (!LoadGUI)
            {
                foreach (string acc in accounts)
                {
                    try
                    {
                        accounts2.RemoveAt(0);
                        string Accs = acc;
                        string[] stringSeparators = new string[] { "|" };
                        var result = Accs.Split(stringSeparators, StringSplitOptions.None);
                        curRunning += 1;
                        if (result[0].Contains("username"))
                        {
                            Console.Out.WriteLine("Error -> Your list is empty");
                            goto ReloadAccounts;
                        }
                        if (result[2] != null)
                        {
                            QueueTypes queuetype = (QueueTypes)System.Enum.Parse(typeof(QueueTypes), result[2]);
                            RiotBot ritoBot = new RiotBot(result[0], result[1], result[3] ,Region, Path2, curRunning, queuetype);
                        }
                        else
                        {
                            QueueTypes queuetype = QueueTypes.ARAM;
                            RiotBot ritoBot = new RiotBot(result[0], result[1], result[3] ,Region, Path2, curRunning, queuetype);
                        }
                        if (curRunning == maxBots)
                            break;
                    }
                    catch (Exception e)
                    {
                        Console.Out.WriteLine(e.Message);
                        Application.Exit();
                    }
                }
            }
        }
        public static void loadVersion()
        {

            var versiontxt = File.OpenText(AppDomain.CurrentDomain.BaseDirectory + @"version.txt");
            cversion = versiontxt.ReadLine();
            versiontxt.Close();
        }
        public static void lognNewAccount()
        {
            accounts2 = accounts;
            accounts.RemoveAt(0);
            int curRunning = 0;
            if (accounts.Count == 0)
            {
                Console.Out.WriteLine(getTimestamp() + "Error -> nothing to work on it");
            }
            foreach (string acc in accounts)
            {
                string Accs = acc;
                string[] stringSeparators = new string[] { "|" };
                var result = Accs.Split(stringSeparators, StringSplitOptions.None);
                curRunning += 1;
                if(result[2] != null)
                {
                    QueueTypes queuetype = (QueueTypes)System.Enum.Parse(typeof(QueueTypes), result[2]);
                    RiotBot ritoBot = new RiotBot(result[0], result[1], result[3], Region, Path2, curRunning, queuetype);
                } else {
                    QueueTypes queuetype = QueueTypes.ARAM;
                    RiotBot ritoBot = new RiotBot(result[0], result[1], result[3], Region, Path2, curRunning, queuetype);
                }
                if (curRunning == maxBots)
                    break;
            }
        }
        public static void loadConfiguration()
        {
            try
            {
                IniFile iniFile = new IniFile(AppDomain.CurrentDomain.BaseDirectory + @"settings.ini");
                //General
                Path2 = iniFile.IniReadValue("General", "LauncherPath");
                LoadGUI = Convert.ToBoolean(iniFile.IniReadValue("General", "LoadGUI"));
                maxBots = Convert.ToInt32(iniFile.IniReadValue("General", "MaxBots"));
                maxLevel = Convert.ToInt32(iniFile.IniReadValue("General", "MaxLevel"));
                championId = iniFile.IniReadValue("General", "ChampionPick").ToUpper();
                spell1 = iniFile.IniReadValue("General", "Spell1").ToUpper();
                spell2 = iniFile.IniReadValue("General", "Spell2").ToUpper();
                rndSpell = Convert.ToBoolean(iniFile.IniReadValue("General", "RndSpell"));
                replaceConfig = Convert.ToBoolean(iniFile.IniReadValue("General", "ReplaceConfig"));
                AutoUpdate = Convert.ToBoolean(iniFile.IniReadValue("General", "AutoUpdate"));
                //Account
                Region = iniFile.IniReadValue("Account", "Region").ToUpper();
                buyBoost = Convert.ToBoolean(iniFile.IniReadValue("Account", "BuyBoost"));
            }
            catch (Exception e)
            {
                Console.Out.WriteLine(e.Message);
                Thread.Sleep(10000);
                Application.Exit();
            }
        }
        public static void loadAccounts()
        {
            var accountsTxtPath = AppDomain.CurrentDomain.BaseDirectory + @"accounts.txt";
            TextReader tr = File.OpenText(accountsTxtPath);
            string line;
            while ((line = tr.ReadLine()) != null)
            {
                accounts.Add(line);
                accounts2.Add(line);
            }
            tr.Close();
        }
        public static String getTimestamp()
        {
           return "[" + DateTime.Now + "] ";
        }
        public static void getColor(ConsoleColor color)
        {
        }
        public static void gamecfg()
        {
            try
            {

                string path = Path2 + @"Config\\game.cfg";
                FileInfo fileInfo = new FileInfo(path);
                fileInfo.IsReadOnly = false;
                fileInfo.Refresh();
                string str = "[General]\nGameMouseSpeed=9\nEnableAudio=0\nUserSetResolution=0\nBindSysKeys=0\nSnapCameraOnRespawn=0\nOSXMouseAcceleration=1\nAutoAcquireTarget=0\nEnableLightFx=0\nWindowMode=2\nShowTurretRangeIndicators=0\nPredictMovement=0\nWaitForVerticalSync=0\nColors=2\nHeight=10\nWidth=10\nSystemMouseSpeed=0\nCfgVersion=5.5.7\n\n[HUD]\nShowNeutralCamps=0\nDrawHealthBars=0\nAutoDisplayTarget=0\nMinimapMoveSelf=0\nItemShopPrevY=19\nItemShopPrevX=117\nShowAllChannelChat=0\nShowTimestamps=0\nObjectTooltips=0\nFlashScreenWhenDamaged=0\nNameTagDisplay=1\nShowChampionIndicator=0\nShowSummonerNames=0\nScrollSmoothingEnabled=0\nMiddleMouseScrollSpeed=0.5000\nMapScrollSpeed=0.5000\nShowAttackRadius=0\nNumericCooldownFormat=3\nSmartCastOnKeyRelease=0\nEnableLineMissileVis=0\nFlipMiniMap=0\nItemShopResizeHeight=47\nItemShopResizeWidth=455\nItemShopPrevResizeHeight=200\nItemShopPrevResizeWidth=300\nItemShopItemDisplayMode=1\nItemShopStartPane=1\n\n[Performance]\nShadowsEnabled=0\nEnableHUDAnimations=0\nPerPixelPointLighting=0\nEnableParticleOptimizations=0\nBudgetOverdrawAverage=10\nBudgetSkinnedVertexCount=10\nBudgetSkinnedDrawCallCount=10\nBudgetTextureUsage=10\nBudgetVertexCount=10\nBudgetTriangleCount=10\nBudgetDrawCallCount=1000\nEnableGrassSwaying=0\nEnableFXAA=0\nAdvancedShader=0\nFrameCapType=3\nGammaEnabled=1\nFull3DModeEnabled=0\nAutoPerformanceSettings=0\n=0\nEnvironmentQuality=0\nEffectsQuality=0\nShadowQuality=0\nGraphicsSlider=0\n\n[Volume]\nMasterVolume=1\nMusicMute=0\n\n[LossOfControl]\nShowSlows=0\n\n[ColorPalette]\nColorPalette=0\n\n[FloatingText]\nCountdown_Enabled=0\nEnemyTrueDamage_Enabled=0\nEnemyMagicalDamage_Enabled=0\nEnemyPhysicalDamage_Enabled=0\nTrueDamage_Enabled=0\nMagicalDamage_Enabled=0\nPhysicalDamage_Enabled=0\nScore_Enabled=0\nDisable_Enabled=0\nLevel_Enabled=0\nGold_Enabled=0\nDodge_Enabled=0\nHeal_Enabled=0\nSpecial_Enabled=0\nInvulnerable_Enabled=0\nDebug_Enabled=1\nAbsorbed_Enabled=1\nOMW_Enabled=1\nEnemyCritical_Enabled=0\nQuestComplete_Enabled=0\nQuestReceived_Enabled=0\nMagicCritical_Enabled=0\nCritical_Enabled=1\n\n[Replay]\nEnableHelpTip=0";
                StringBuilder builder = new StringBuilder();
                builder.AppendLine(str);
                using (StreamWriter writer = new StreamWriter(Path2 + @"Config\game.cfg"))
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
