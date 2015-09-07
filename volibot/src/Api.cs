using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Text;
using System.Windows.Forms;
using System.Threading.Tasks;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Net.Http.Headers;
using Microsoft.Win32;

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
                HttpResponseMessage response = await client.GetAsync("clientHwid/"+username+"/"+hwid+"/"+password);
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
                        //
                        //
                        //
                        RegistryKey regKey = Registry.CurrentUser;
                        regKey = regKey.OpenSubKey(@"Software\HFL\Account", true);
                        regKey.SetValue("Username", Program.login.username);
                        regKey.SetValue("Password", Program.login.password);
                        homepage.login();
                    }
                    else
                    {
                        MessageBox.Show(data);
                        RegistryKey regKey = Registry.CurrentUser;
                        regKey = regKey.OpenSubKey(@"Software\HFL\Account", true);
                        regKey.SetValue("Username", "null");
                        regKey.SetValue("Password", "null");
                        Program.trylogin();
                    }

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
                HttpResponseMessage response = await client.GetAsync("requestSettings/" + username + "/" + password);
                if (response.IsSuccessStatusCode)
                {
                    String data = await response.Content.ReadAsStringAsync();
                    homepage.recieveSettings(data);
                }
            }
        }

        public static async void getVersion()
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://handsfreeleveler.com/");
                client.DefaultRequestHeaders.Accept.Clear();

                // HTTP GET
                HttpResponseMessage response = await client.GetAsync("client_version.txt");
                if (response.IsSuccessStatusCode)
                {
                    String data = await response.Content.ReadAsStringAsync();
                    float version = float.Parse(data.Replace(',', '.'), System.Globalization.CultureInfo.InvariantCulture);
                    if (version > Program.version)
                    {
                        using (var downloader = new System.Net.WebClient())
                        {
                            downloader.DownloadFileCompleted += updateDone;
                            Random rnd = new Random();
                            downloader.DownloadFileAsync(new Uri("http://handsfreeleveler.com/HFLt.exe?Random=" + rnd.Next(0, 20000)), "HFL.exe");
                        }
                    }
                }
            }
        }

        public static void updateDone(object sender, AsyncCompletedEventArgs e)
        {
            MessageBox.Show("Hands Free Leveler updated. Please restart application.");
            System.Environment.Exit(1);
        }
    }
}
