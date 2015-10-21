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
using System.Threading;

namespace HandsFreeLeveler.HFL.View
{
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Update : Window
    {
        public Update()
        {
            InitializeComponent();
            startDownloadUpdate();
        }

        public void startDownloadUpdate(){
            downloadProgress.Value = 56;
        }

        public void restartNewVersion()
        {

        }
    }
}
