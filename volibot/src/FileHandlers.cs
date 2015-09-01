﻿using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RitoBot
{
    public static class FileHandlers
    {

        static string theFolder = AppDomain.CurrentDomain.BaseDirectory + @"config\\";
        static string accountsTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"config\\accounts.txt";
        static string configTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"config\\settings.ini";
        static string versionTxtLocation = AppDomain.CurrentDomain.BaseDirectory + @"config\\version.txt";

        public static void SettingsIni(string LauncherPath, string MaxBots, string MaxLevel, string ChampionPick, string Spell1, string Spell2, string Region, string BuyBoost)
        {
            try
            {
                if (File.Exists(configTxtLocation))
                {
                    File.Delete(configTxtLocation);
                }

                var newfile = File.Create(configTxtLocation);
                newfile.Close();
                var content = "[General]\nLauncherPath=" + LauncherPath + "\nLoadGUI=false\nMaxBots=" + MaxBots + "\nMaxLevel=" + MaxLevel + "\nChampionPick=" + ChampionPick + "\nSpell1=" + Spell1 + "\nSpell2=" + Spell2 + "\nRndSpell=false\nReplaceConfig=false\nAutoUpdate=false\n\n[Account]\nRegion=" + Region + "\nBuyBoost=" + BuyBoost;
                var separator = new string[] { "\n" };
                string[] contentlines = content.Split(separator, StringSplitOptions.None);
                File.WriteAllLines(configTxtLocation, contentlines);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.ToString());
            }
        }
        public static void AccountsTxt(string Username, string Password)
        {
            
            var content = Username + "|" + Password;
            try
            {
                string accs = File.ReadAllText(accountsTxtLocation);
                if (accs.Contains("username"))
                {
                    if (File.Exists(accountsTxtLocation))
                    {
                        File.Delete(accountsTxtLocation);
                    }

                    var newfile = File.Create(accountsTxtLocation);
                    newfile.Close();
                    var separator = new string[] { "\n" };
                    string[] contentlines = content.Split(separator, StringSplitOptions.None);
                    File.WriteAllLines(accountsTxtLocation, contentlines);
                }
                else File.AppendAllText(accountsTxtLocation, content + Environment.NewLine);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.ToString());
            }
        }
        public static void AccountsTxt(string Username, string Password, string QueueType)
        {

            var content = Username + "|" + Password + "|" + QueueType;
            try
            {
                string accs = File.ReadAllText(accountsTxtLocation);
                if (accs.Contains("username"))
                {
                    if (File.Exists(accountsTxtLocation))
                    {
                        File.Delete(accountsTxtLocation);
                    }

                    var newfile = File.Create(accountsTxtLocation);
                    newfile.Close();
                    var separator = new string[] { "\n" };
                    string[] contentlines = content.Split(separator, StringSplitOptions.None);
                    File.WriteAllLines(accountsTxtLocation, contentlines);
                }
                else File.AppendAllText(accountsTxtLocation, content + Environment.NewLine);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.ToString());
            }
        }
        public static void AccountsTxt(string Username, string Password, string QueueType, string maxLevel)
        {

            var content = Username + "|" + Password + "|" + QueueType + "|" + maxLevel;
            try
            {
                string accs = File.ReadAllText(accountsTxtLocation);
                if (accs.Contains("username"))
                {
                    if (File.Exists(accountsTxtLocation))
                    {
                        File.Delete(accountsTxtLocation);
                    }

                    var newfile = File.Create(accountsTxtLocation);
                    newfile.Close();
                    var separator = new string[] { "\n" };
                    string[] contentlines = content.Split(separator, StringSplitOptions.None);
                    File.WriteAllLines(accountsTxtLocation, contentlines);
                }
                else File.AppendAllText(accountsTxtLocation, content + Environment.NewLine);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.ToString());
            }
        }
        
    }
}
