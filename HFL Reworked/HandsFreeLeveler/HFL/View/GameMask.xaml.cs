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
using System.Collections.ObjectModel;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using System.Threading;

namespace HandsFreeLeveler
{
    /// <summary>
    /// Interaction logic for GameMask.xaml
    /// </summary>
    public partial class GameMask : Window
    {

        [DllImport("user32.dll")]
        private static extern IntPtr SendMessage(IntPtr Handle, int Msg, int wParam, int lParam);
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
        [DllImport("user32.dll")]
        private static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
        [DllImport("user32.dll", SetLastError = true)]
        static extern IntPtr SetParent(IntPtr hWndChild, IntPtr hWndNewParent);
        [DllImport("user32.dll", SetLastError = true)]
        internal static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

        private static BackgroundWorker bgWorker = new BackgroundWorker();
        public static ObservableCollection<handle> smurfList = new ObservableCollection<handle>();
        public GameMask()
        {
            InitializeComponent();
            this.DataContext = this;
            runningSmurfs.ItemsSource = smurfList;
            bgWorker.WorkerSupportsCancellation = false;
            bgWorker.WorkerReportsProgress = true;
            bgWorker.DoWork += worker;
            //bgWorker.RunWorkerAsync();

            handle newSmurf = new handle(null, "test");
            smurfList.Add(newSmurf);
        }

        public void addWindow(Process exe, string smurfName)
        {
            IntPtr windowHandle = new WindowInteropHelper(this).Handle;
            SetParent(exe.MainWindowHandle, windowHandle);
            MoveWindow(exe.MainWindowHandle, 120, 40, 200, 200, true);
            SetWindowLong(exe.MainWindowHandle, -16, 0x11800000);

            handle newSmurf = new handle(exe, smurfName);
            smurfList.Add(newSmurf);
        }

        public class handle{
            public string smurfName { get; set; }
            internal Process process;

            public handle(Process _pro, string _smuf)
            {
                process = _pro;
                smurfName = _smuf;
            }
        }

        public static void worker(object sender, DoWorkEventArgs e)
        {
            while (true)
            {
                foreach (handle proc in smurfList)
                {
                    if (proc.process.HasExited)
                    {
                        smurfList.Remove(proc);
                    }
                }
                Thread.Sleep(300);
            }
        }
    }
}
