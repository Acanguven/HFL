using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Xml;
using System.Xml.Linq;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Web.Script.Serialization;
using WebSocketSharp;
using Microsoft.Win32;
using System.IO;
using System.Threading;
using System.Diagnostics;
using UITimer = System.Windows.Forms.Timer;


namespace HandsFreeLeveler
{
    public partial class Dashboard : Form
    {
        public WebSocket ws;
        public static Boolean warned = false;
        public Boolean wsLoggedIn = false;

        public Dashboard()
        {
            
            InitializeComponent();
            pictureBox1.Image = Properties.Resources.jinxSprite;
            toolStripStatusLabel1.Text = "Remote connection not working.";
            ws = new WebSocket("ws://handsfreeleveler.com:4444");
            ws.OnMessage += commandManager;
            ws.OnOpen += wsConnect;
            ws.OnClose += wsEnded;
            ws.OnError += wsFailed;
            

            UITimer timer;
            timer = new UITimer();
            timer.Interval = 1000;
            timer.Tick += new EventHandler(updateSettings);
            timer.Start();
        }

        public void wsConnect(Object sender, EventArgs msg){
            HandsFreeLeveler.Program.homePage.Invoke(new Action(
            delegate()
            {
                toolStripStatusLabel1.Text = "Waiting commands from remote panel, http://www.handsfreeleveler.com/Dashboard";
                offlineStart.Visible = false;
                RemoteButton.ForeColor = System.Drawing.Color.Green;
                RemoteButton.Text = "Remote";
            }));
        }

        public void wsEnded(Object sender, CloseEventArgs msg)
        {
            HandsFreeLeveler.Program.homePage.Invoke(new Action(
            delegate()
            {
                toolStripStatusLabel1.Text = "Remote system is not working or disabled, offline mode enabled.";
                offlineStart.Visible = true;
                RemoteButton.ForeColor = System.Drawing.Color.Red;
                RemoteButton.Text = "Offline";
                wsLoggedIn = false;
            }));
        }

        public void wsFailed(Object sender, WebSocketSharp.ErrorEventArgs msg)
        {
            HandsFreeLeveler.Program.homePage.Invoke(new Action(
            delegate()
            {
                toolStripStatusLabel1.Text = "Remote system crashed, offline mode enabled. Created error report.";
                Program.traceReporter("WsError:" + msg.Exception);
                RemoteButton.ForeColor = System.Drawing.Color.Red;
                RemoteButton.Text = "Offline";
                wsLoggedIn = false;
                offlineStart.Visible = true;
            }));
        }

        private void Dashboard_SizeChanged(object sender, EventArgs e)
        {

            if (this.WindowState == FormWindowState.Minimized)
            {
                this.Hide();
                notifyIcon1.Icon = Properties.Resources.fe1iHm3;
                notifyIcon1.BalloonTipText = "HFL is running minimized now";
                notifyIcon1.ShowBalloonTip(1000);
                
            }
        }

        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            this.Show();
            this.Activate();
            this.BringToFront();
        }

        public void fillList(List<smurfData> smurfs)
        {
            listView1.Items.Clear();
            Program.accounts.Clear();

            foreach (smurfData smurf in smurfs)
            {
                ListViewItem t = new ListViewItem(smurf.username);
                t.SubItems.Add(smurf.password);
                t.SubItems.Add(smurf.currentLevel);
                t.SubItems.Add(smurf.maxLevel);
                t.SubItems.Add(smurf.status != null ? smurf.status  : "Idle");
                listView1.Items.Add(t);
                Program.accounts.Add(smurf);
            }
            
        }
        public class socketRecieve
        {
            public string data;
        }

        public void commandManager(Object sender, MessageEventArgs msg)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serverCommand command = serializer.Deserialize<serverCommand>(msg.Data);

            switch (command.cmd)
            {
                case "start bol":
                    startBol();
                break;
                case "close bol":
                    Process[] proc = Process.GetProcessesByName("Bol Studio");
	                proc[0].Kill();
                break;
                case "start queue":
                    pathSettings("NP");
                    Program.startBotting();
                break;
                case "stop queue":
                    Program.stopBotting();
                break;
                case "stop pc":
                    Process.Start("shutdown", "/s /t 0");
                break;
                case "hiber start":
                    throw new System.ArgumentNullException();
                break;
            }
        }

        public void login()
        {
            ws.Connect();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string dataStr = serializer.Serialize(new loginPacket() { type = "client", username = Program.login.username, key=Program.login.key});
            ws.Send(dataStr);
            wsLoggedIn = true;
        }

        public void updateList(string username, string currentLevel, string status)
        {
            foreach (ListViewItem current in listView1.Items)
            {
                if (username == current.SubItems[0].Text) {
                    current.SubItems[2].Text = currentLevel;
                    current.SubItems[4].Text = status;
                }
            }
        }

        public string pathSettings(string type)
        {
            XDocument settings = XDocument.Load("settings.xml");
            
            /* For BOL */
            string bolPath = settings.Element("HFL").Element("Paths").Element("BOL").Value.ToString();
            if (bolPath == null || bolPath == "null" || !File.Exists(bolPath) || bolPath == "")
            {
                bolPath = Prompt.ShowFileDialog("Bol Studio", "Bol Studio.exe", openFileDialog1, this);
                settings.Element("HFL").Element("Paths").Element("BOL").SetValue(bolPath);
            }
            Program.dllPath = Path.GetDirectoryName(bolPath)+"\\tangerine.dll";


            /* For Game */
            string gamePath = settings.Element("HFL").Element("Paths").Element("GAME").Value.ToString();
            if (gamePath == null || gamePath == "null" || !File.Exists(gamePath) || gamePath == "")
            {
                gamePath = Prompt.ShowFileDialog("lol.launcher.admin", "lol.launcher.admin.exe", openFileDialog1, this);
                settings.Element("HFL").Element("Paths").Element("GAME").SetValue(gamePath);
            }

            settings.Save("settings.xml");

            Program.gamePath = Path.GetDirectoryName(gamePath) + "\\";

            if (type == "BOL")
            {
                return bolPath;
            }
            else
            {
                return gamePath;
            }
        }

        public void startBol()
        {
            var startInfo = new ProcessStartInfo();
            startInfo.WorkingDirectory = Path.GetDirectoryName(pathSettings("BOL")); // working directory
            startInfo.FileName = "Bol Studio.exe";
            Process proc = Process.Start(startInfo);
        }

        private void updateSettings(object sender, EventArgs ea)
        {
            try { 
            if (Program.loggedIn) { 
                Api.getSettings(Program.login.username, Program.login.password, this);
                if (Program.started){
                    offlineStart.Text = "Stop";
                }else{
                    offlineStart.Text = "Start";
                }
            }
            if (Program.loggedIn && ws.IsAlive && wsLoggedIn)
            {
                status ping = new status();
                ping.hfl = Program.started;
                Process[] pname = Process.GetProcessesByName("Bol Studio");
                if (pname.Length == 0){
                    ping.bol = false;
                    Program.bolRunning = false;
                }else { 
                    ping.bol = true;
                    Program.bolRunning = true;
                }
                ping.rs = Program.accounts.Count;
                ping.ut = DateTime.Now.ToString();
                ping.ng = Program.gamesPlayed;
                ping.wg = Program.gamesPlayed;

                foreach(smurfData smurf in Program.accounts){
                    ping.smurfUpdate.Add(smurf);
                }

                serverUpdate newUpdate = new serverUpdate();
                newUpdate.status = ping;

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                string dataStr = serializer.Serialize(newUpdate);
                ws.SendAsync(dataStr, null);
            }
            }
            catch (Exception ex)
            {
                Program.traceReporter(ex.Message);
            }
        }

        public class status
        {
            public Boolean hfl;
            public Boolean bol;
            public int rs;
            public String ut;
            public int ng;
            public int wg;
            public List<smurfData> smurfUpdate = new List<smurfData>();
        }

        public class serverUpdate
        {
            public string type = "clientUpdate";
            public string key = Program.login.key;
            public string username = Program.login.username;
            public status status;
        }

        public void recieveSettings(string settingsJSON)
        {
            if (!Program.started) { 
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                settings serverSettings = serializer.Deserialize<settings>(settingsJSON);
                fillList(serverSettings.smurfs);

                Program.Region = serverSettings.rg;
                Program.maxBots = Program.login.type != "1" ? serverSettings.ms : Int32.Parse("1");
                Program.replaceConfig = serverSettings.gpuD;
            }
        }

        public class serverCommand
        {
            public string type;
            public string cmd;
            public string hours;
            public string minutes;
        }

        public class settings
        {
            public List<smurfData> smurfs;
            public Boolean bb;
            public string rg;
            public int ms;
            public Boolean gpuD;
            public string bolFolder;
            public string gameFolder;
        }

        public class loginPacket
        {
            public string type { get; set; }
            public string username { get; set; }
            public string key { get; set; }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://handsfreeleveler.com/client");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Tutorial will be ready soon.");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            XDocument settings = XDocument.Load("settings.xml");
            settings.Element("HFL").Element("Account").Element("Username").SetValue("null");
            settings.Element("HFL").Element("Account").Element("Password").SetValue("null");
            settings.Save("settings.xml");
            Environment.Exit(1);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://forum.botoflegends.com/topic/78053-paid48h-trialbot-hands-free-leveler517/");
        }

        private void button5_Click(object sender, EventArgs e)
        {
            Button clickedButton = (Button)sender;
            if (!warned)
            {
                warned = true;
                MessageBox.Show("WARNING\nHFL supports only INTRO BOTS and 'not so good' ARAM.\nSo I will only accept reports of Intro Bots for now, don't post bugs of others!!!");
            }
            if (Program.qType == "INTRO_BOT")
            {
                clickedButton.Text = "Beginner Bots";
                Program.qType = "BEGINNER_BOT";
                return;
            }

            if (Program.qType == "BEGINNER_BOT")
            {
                Program.qType = "MEDIUM_BOT";
                clickedButton.Text = "Medium Bots";
                return;
            }

            if (Program.qType == "MEDIUM_BOT")
            {
                Program.qType = "ARAM";
                clickedButton.Text = "Aram";
                return;
            }

            if (Program.qType == "ARAM")
            {
                Program.qType = "NORMAL_5x5";
                clickedButton.Text = "Normal 5v5";
                return;
            }

            if (Program.qType == "NORMAL_5x5")
            {
                Program.qType = "NORMAL_3x3";
                clickedButton.Text = "Normal 3v3";
                return;
            }

            if (Program.qType == "NORMAL_3x3")
            {
                Program.qType = "INTRO_BOT";
                clickedButton.Text = "Intro Bots";
                return;
            }
        }

        public void offlineStart_Click(object sender, EventArgs e)
        {
            if (Program.started){
                Program.stopBotting();
            }else{
                pathSettings("NP");
                Program.startBotting();
            }
        }

        private void RemoteButton_Click(object sender, EventArgs e)
        {
            if (ws.IsAlive) { 
                ws.Close();
            }
            else
            {
                login();
            }
        }

    }
}
