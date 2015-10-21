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
using System.Windows.Shapes;

namespace HandsFreeLeveler
{
    /// <summary>
    /// Interaction logic for Account.xaml
    /// </summary>
    public partial class Account : Window
    {
        public Account()
        {
            InitializeComponent();
            username.Content = "Username: " + User.username;
            password.Content = "Password: " + User.password;
            Trial.Content = "Trial Remaining: 1000 minutes";
            multiButton.Visibility = System.Windows.Visibility.Hidden;
            singleButton.Visibility = System.Windows.Visibility.Hidden;
            upButton.Visibility = System.Windows.Visibility.Hidden;

            if (User.multiSmurf)
            {
                AccountType.Content = "Account Type: Multi Smurf";
            }else{
                AccountType.Content = "Account Type: Single Smurf";
                upButton.Visibility = System.Windows.Visibility.Visible;
            }
        }

        private void multiButton_Click(object sender, RoutedEventArgs e)
        {

        }

        private void singleButton_Click(object sender, RoutedEventArgs e)
        {

        }

        private void upButtonClick(object sender, RoutedEventArgs e)
        {

        }
    }
}
