using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Xml.Linq;
using System.Collections.ObjectModel;
using System.Xml.Serialization;
using System.Collections.Specialized;
using System.IO;

namespace HandsFreeLeveler
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    /// 


    public partial class App : Application
    {
        public static ObservableCollection<Smurf> smurfList = new ObservableCollection<Smurf>();
        private async void Application_Startup_2(object sender, StartupEventArgs e)
        {
            bool updateExists = await Connection.updateCheck();
            if (updateExists)
            {
                HandsFreeLeveler.HFL.View.Update updater = new HandsFreeLeveler.HFL.View.Update();
                updater.Show();
            }
            else
            {
                if (FileHandler.settingsExists())
                {
                    var xs = new XmlSerializer(typeof(ObservableCollection<Smurf>));
                    using (Stream s = File.OpenRead("Smurfs.xml"))
                    {
                        smurfList = (ObservableCollection<Smurf>)xs.Deserialize(s);
                    }

                    XDocument settings = XDocument.Load("settings.xml");
                    Settings.firstTime = false;
                    string username = settings.Element("HFL").Element("Account").Element("Username").Value.ToString();
                    string password = settings.Element("HFL").Element("Account").Element("Password").Value.ToString();
                    User.username = username;
                    User.password = password;

                    Settings.update();

                    string loginStatus = await Connection.login(User.username, User.password, HWID.Generate());

                    if (loginStatus == "true")
                    {
                        //Bol bolde = new Bol();
                        //bolde.Show();
                        Dashboard home = new Dashboard();
                        home.Show();
                    }
                    else
                    {
                        Login loginWindow = new Login();
                        loginWindow.Show();
                    }
                }
                else
                {
                    Settings.firstTime = true;
                    Settings.update();
                    Language selector = new Language();
                    selector.Show();
                }
            }
        }
    }
}
