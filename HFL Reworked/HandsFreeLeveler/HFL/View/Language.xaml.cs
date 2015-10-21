﻿using System;
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
    /// Interaction logic for Language.xaml
    /// </summary>
    public partial class Language : Window
    {
        public static Dictionary dic = new Dictionary(); 
        public Language()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Login userScreen = new Login();
            userScreen.Show();
            this.Close();
        }

        private void EnButton_Checked(object sender, RoutedEventArgs e)
        {
            Settings.language = "English";
            contBut.Content = dic.text("continue");
        }

        private void TrButton_Checked(object sender, RoutedEventArgs e)
        {
            Settings.language = "Türkçe";
            contBut.Content = dic.text("continue");
        }

        private void EsButton_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void PrButton_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void JpButton_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void ChButton_Checked(object sender, RoutedEventArgs e)
        {

        }
    }
}
