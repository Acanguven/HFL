using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Text;
using System.Windows.Forms;
using System.Threading.Tasks;
using System.Net.Http;
using System.Xml;
using System.Xml.Linq;
using System.Text.RegularExpressions;
using System.Net.Http.Headers;
using Microsoft.Win32;
using System.IO;

namespace HandsFreeLeveler
{
    public static class Api
    {
        public static async void checkAuth(string username, string hwid, string password, Dashboard homepage)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://handsfreeleveler.com/api/");
                client.DefaultRequestHeaders.Accept.Clear();

                // HTTP GET
                try
                {
                    HttpResponseMessage response = await client.GetAsync("clientHwid/" + username + "/" + hwid + "/" + password);
                    if (response.IsSuccessStatusCode)
                    {
                        String data = await response.Content.ReadAsStringAsync();
                        // if(body.indexOf("Authenticated") == 0 || body.indexOf("is now registered") > 0){
                        if (data.IndexOf("Authenticated") > -1 || data.IndexOf("is now registered") > -1)
                        {
                            Match match = Regex.Match(data, "(.*) (.*) ");
                            if (match.Length < 1)
                            {
                                Program.login.type = "2";
                                Program.maxBots = 1000;
                                Program.loggedIn = true;
                            }
                            else
                            {
                                Program.login.type = "1";
                                Program.maxBots = 1000;
                                Program.loggedIn = true;
                            }


                            XDocument settings = XDocument.Load("settings.xml");
                            settings.Element("HFL").Element("Account").Element("Username").SetValue(Program.login.username);
                            settings.Element("HFL").Element("Account").Element("Password").SetValue(Program.login.password);
                            settings.Save("settings.xml");
                            homepage.login();
                        }
                        else
                        {
                            MessageBox.Show(data);
                            XDocument settings = XDocument.Load("settings.xml");
                            settings.Element("HFL").Element("Account").Element("Username").SetValue("null");
                            settings.Element("HFL").Element("Account").Element("Password").SetValue("null");
                            settings.Save("settings.xml");
                            Environment.Exit(1);
                        }

                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Can't authenticate you from Law server, probably server is down. It should be online soon");
                    Program.traceReporter("Can't connect authentication api.");
                    Environment.Exit(1);
                }
            }
        }

        public static async void getSettings(string username, string password, Dashboard homepage)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://handsfreeleveler.com/api/");
                client.DefaultRequestHeaders.Accept.Clear();

                // HTTP GET
                try { 
                HttpResponseMessage response = await client.GetAsync("requestSettings/" + username + "/" + password);
                if (response.IsSuccessStatusCode)
                {
                    String data = await response.Content.ReadAsStringAsync();
                    homepage.recieveSettings(data);
                }
                }
                catch (Exception ex)
                {
                    Program.traceReporter("Can't fetch settings from remote server");
                }
            }
        }

        public static async void getVersion()
        {
            Random rnd = new Random();
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://handsfreeleveler.com/");
                client.DefaultRequestHeaders.Accept.Clear();

                // HTTP GET
                try { 
                    HttpResponseMessage response = await client.GetAsync("client_version.txt?Random=" + rnd.Next(0, 20000));
                    if (response.IsSuccessStatusCode)
                    {
                        String data = await response.Content.ReadAsStringAsync();
                        float version = float.Parse(data.Replace(',', '.'), System.Globalization.CultureInfo.InvariantCulture);
                        if (version > Program.version)
                        {
                            using (var downloader = new System.Net.WebClient())
                            {
                                downloader.DownloadFileCompleted += updateDone;
                                downloader.DownloadFileAsync(new Uri("http://handsfreeleveler.com/HFL.exe?Random=" + rnd.Next(0, 20000)), "HFLNEW.exe");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Program.traceReporter("Server is down for version checking");
                    MessageBox.Show("Server is down for version checking, Law should make it online soon. Starting version:"+ Program.version);
                }
            }
        }

        public static void updateDone(object sender, AsyncCompletedEventArgs e)
        {

            if (File.Exists("HFLNEW.exe"))
            {
                System.IO.File.Move("HFL.exe", "HFLOLD.exe");
                System.IO.File.Move("HFLNEW.exe", "HFL.exe");
                System.Diagnostics.Process.Start("HFL.exe");
                System.Environment.Exit(1);
            }
        }
    }
}
