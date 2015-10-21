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

namespace HandsFreeLeveler
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class Dashboard : Window
    {
        public Dashboard()
        {
            InitializeComponent();
            smurfListDashBoard.ItemsSource = App.smurfList;
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
    }
}
