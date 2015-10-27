using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Net.Http;
using System.Windows;
using System.Text.RegularExpressions;

namespace HandsFreeLeveler
{
    public static class Connection
    {
        public static async Task<string> login(string username, string password, string hwid)
        {
            var client = new HttpClient();
            client.BaseAddress = new Uri("http://handsfreeleveler.com/api/");
            client.DefaultRequestHeaders.Accept.Clear();

            // HTTP GET

            try
            {
                HttpResponseMessage response = await client.GetAsync("clientHwid/" + username + "/" + hwid + "/" + password);
                if (response.IsSuccessStatusCode)
                {
                    String data = await response.Content.ReadAsStringAsync();
                    if (data.IndexOf("Authenticated") > -1 || data.IndexOf("is now registered") > -1)
                    {
                        Match match = Regex.Match(data, "(.*) (.*) ");
                        if (match.Length < 1)
                        {
                            User.multiSmurf = true;
                            User.username = username;
                            User.password = password;
                            User.hwid = hwid;
                            Settings.update();
                            return "true";
                        }
                        else
                        {
                            User.multiSmurf = false;
                            User.username = username;
                            User.password = password;
                            User.hwid = hwid;
                            Settings.update();
                            return "true";
                        }
                    }
                    else
                    {
                        return data;
                    }
                }
                else
                {
                    return "An error occured while trying to login";
                }
            }
            catch (Exception ex)
            {
                return "You don't have a valid internet connection.";
            }

        }

        public static async Task<string> register(string username, string password, string hwid)
        {
            Thread.Sleep(3000);
            return "true";
        }


        public static async Task<bool> updateCheck()
        {
            Thread.Sleep(3000);
            return false;
        }
    }
}
