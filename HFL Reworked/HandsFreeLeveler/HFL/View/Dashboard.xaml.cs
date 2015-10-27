using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.ComponentModel;

namespace HandsFreeLeveler
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class Dashboard : Window
    {
        private static BackgroundWorker bgWorker = new BackgroundWorker();
        public Dashboard()
        {
            InitializeComponent();
            smurfListDashBoard.ItemsSource = App.smurfList;

            bgWorker.WorkerSupportsCancellation = false;
            bgWorker.WorkerReportsProgress = false;
            bgWorker.DoWork += dashworker;
            bgWorker.RunWorkerAsync();

            UsernameLabel.Content = "Usarname: " + User.username;
            if(User.multiSmurf){
                PType.Content = "Package Type: Multi Smurf";
            }else{
                PType.Content = "Package Type: Single Smurf";
            }
            TrLabel.Content = "Trial: Unlimited";
        }

        private void Account_Button_Click(object sender, RoutedEventArgs e)
        {
            Account accWindow = new Account();
            accWindow.Show();
        }

        private void smurfListButton_Click(object sender, RoutedEventArgs e)
        {
            SmurfListWindow smurfList = new SmurfListWindow();
            smurfList.Show();
        }

        private static void dashworker(object sender, DoWorkEventArgs e)
        {
            
        }

        private void bw_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {

        }

        private void bw_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {

        }
    }
}
