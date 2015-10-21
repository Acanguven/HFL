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
    /// Interaction logic for SmurfListWindow.xaml
    /// </summary>
    /// 
    public partial class SmurfListWindow : Window
    {

        
        public SmurfListWindow()
        {
            InitializeComponent();
            smurfLister.ItemsSource = App.smurfList;
        }

        private void addNewSmurfButton_Click(object sender, RoutedEventArgs e)
        {
            AddSmurfWindow addNew = new AddSmurfWindow();
            addNew.Show();
        }

        private void clear_Click(object sender, RoutedEventArgs e)
        {
            var itemsToRemove = App.smurfList.Where(smu => (smu.thread == null)).ToList();

            foreach (var itemToRemove in itemsToRemove)
            {
                App.smurfList.Remove(itemToRemove);
            }

            Settings.update();
        }

        public string smurfCount(){
            return "Calculated Ram Usage: " + (App.smurfList.Count * 630).ToString();
        }


        void DataGrid_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            DataGrid dg = sender as DataGrid;
            if (dg != null)
            {
                dynamic curSmurf = dg.CurrentItem;
                if (curSmurf.thread != null)
                {
                    e.Handled = true;
                }
                else
                {
                    DataGridRow dgr = (DataGridRow)(dg.ItemContainerGenerator.ContainerFromIndex(dg.SelectedIndex));
                    if (e.Key == Key.Delete && !dgr.IsEditing)
                    {
                        // User is attempting to delete the row
                        var result = MessageBox.Show(
                            "About to delete the current row.\n\nProceed?",
                            "Delete",
                            MessageBoxButton.YesNo,
                            MessageBoxImage.Question,
                            MessageBoxResult.No);
                        e.Handled = (result == MessageBoxResult.No);
                    }
                    Settings.update();
                }
            }
        }
    }
}
