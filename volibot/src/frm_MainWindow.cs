

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Diagnostics;
using System.Linq;
using System.Text;
using LoLLauncher;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RitoBot
{
    public partial class frm_MainWindow : Form
    {
        public frm_MainWindow()
        {
            InitializeComponent();
        }

        public bool IsProcessOpen(string name)
        {
            //here we're going to get a list of all running processes on
            //the computer
            foreach (Process clsProcess in Process.GetProcesses())
            {
                //now we're going to see if any of the running processes
                //match the currently running processes. Be sure to not
                //add the .exe to the name you provide, i.e: NOTEPAD,
                //not NOTEPAD.EXE or false is always returned even if
                //notepad is running.
                //Remember, if you have the process running more than once, 
                //say IE open 4 times the loop thr way it is now will close all 4,
                //if you want it to just close the first one it finds
                //then add a return; after the Kill
                if (clsProcess.ProcessName.Contains(name))
                {
                    //if the process is found to be running then we
                    //return a true
                    return true;
                }
            }
            //otherwise we return a false
            return false;
        }

        public void Print(string text)
        {
            Console.Out.WriteLine("[" + DateTime.Now + "] : " + text + "\n");
        }
        public void Print(string text, int newlines)
        {
            Console.Out.WriteLine("[" + DateTime.Now + "] : " + text);
            for (int i = 0; i < newlines; i++)
            {
                Console.Out.WriteLine("\n");
            }
        }
        public void ShowAccount(string account, string password, string queuetype)
        {
            LoadedAccounts.AppendText("A: " + account + " Pw: " + password + " Q: " + queuetype );
        }

        private void addAccountsBtn_Click(object sender, EventArgs e)
        {
            if (newUserNameInput.Text.Length == 0 || newPasswordInput.Text.Length == 0)
            {
                MessageBox.Show("Username and Password cannot be empty!!!");
            }
            else
            {
                if (QueueTypeInput.SelectedIndex == -1 && SelectChampionInput.SelectedIndex == -1) FileHandlers.AccountsTxt(newUserNameInput.Text, newPasswordInput.Text);
                else if (SelectChampionInput.SelectedIndex == -1) FileHandlers.AccountsTxt(newUserNameInput.Text, newPasswordInput.Text, QueueTypeInput.SelectedItem.ToString());
                else FileHandlers.AccountsTxt(newUserNameInput.Text, newPasswordInput.Text, QueueTypeInput.SelectedItem.ToString(), SelectChampionInput.SelectedItem.ToString());
                Program.loadAccounts();
                Thread.Sleep(1000);
                queueLoop();
            }
        }

        private void saveBtn_Click(object sender, EventArgs e)
        {
            FileHandlers.SettingsIni(LauncherPathInput.Text, MaxBotsInput.Text, MaxLevelInput.Text, DefaultChampionInput.SelectedItem.ToString(), Spell1Input.SelectedItem.ToString(), Spell2Input.SelectedItem.ToString(), RegionInput.SelectedItem.ToString(), BuyBoostInput.SelectedItem.ToString());
            Program.loadConfiguration();
        }

        private void replaceConfigBtn_Click(object sender, EventArgs e)
        {
            Print("Game configuration was optimized successfuly!");
            Program.gamecfg();
        }

        private void queueLoop()
        {
            foreach (string acc in Program.accounts)
            {
                int curRunning = 0;
                try
                {
                    Program.accounts2.RemoveAt(0);
                    string Accs = acc;
                    string[] stringSeparators = new string[] { "|" };
                    var result = Accs.Split(stringSeparators, StringSplitOptions.None);
                    curRunning += 1;
                    if (result[0].Contains("username"))
                    {
                        Print("No accounts found. Please add an account.", 2);
                    }
                    if (result[2] != null)
                    {
                        QueueTypes queuetype = (QueueTypes)System.Enum.Parse(typeof(QueueTypes), result[2]);
                        RiotBot ritoBot = new RiotBot(result[0], result[1], result[3] ,Program.Region, Program.Path2, curRunning, queuetype);
                        ShowAccount(result[0], result[1], result[2]);
                    }
                    else
                    {
                        QueueTypes queuetype = QueueTypes.ARAM;
                        RiotBot ritoBot = new RiotBot(result[0], result[1], result[3], Program.Region, Program.Path2, curRunning, queuetype);
                        ShowAccount(result[0], result[1], "ARAM");
                    }
                    Program.MainWindow.Text = "" + Program.connectedAccs;
                    if (curRunning == Program.maxBots)
                        break;
                }
                catch (Exception)
                {
                    Print("You may have an error in accounts.txt.");
                }
            }
        }

        private void frm_MainWindow_Load(object sender, EventArgs e)
        {
            Print("Starting Queue Loop");
            queueLoop();
        }

        private void LauncherPathInput_Click(object sender, EventArgs e)
        {

        }


    }
}
