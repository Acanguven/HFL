using System;
using System.Windows.Forms;
using System.Threading;
using System.Threading.Tasks;


public static class Prompt
{
    public static string ShowDialog(string text, string caption)
    {
        Form prompt = new Form();
        prompt.Width = 200;
        prompt.Height = 150;
        prompt.FormBorderStyle = FormBorderStyle.FixedDialog;
        prompt.Text = caption;
        prompt.StartPosition = FormStartPosition.CenterScreen;
        Label textLabel = new Label() { Left = 20, Top = 20, Text = text };
        TextBox textBox = new TextBox() { Left = 20, Top = 50, Width = 150 };
        Button confirmation = new Button() { Text = "Ok", Left = 40, Width = 100, Top = 80, DialogResult = DialogResult.OK };
        confirmation.Click += (sender, e) => { prompt.Close(); };
        prompt.Controls.Add(textBox);
        prompt.Controls.Add(confirmation);
        prompt.Controls.Add(textLabel);
        prompt.AcceptButton = confirmation;

        return prompt.ShowDialog() == DialogResult.OK ? textBox.Text : "";
    }


    public static string ShowFileDialog(string FileName, string fileFull, System.Windows.Forms.FileDialog dialog,Form parent)
    {
        string selectedPath = "";
        var t = new Thread((ThreadStart)(() =>
        {
            HandsFreeLeveler.Program.homePage.BeginInvoke(new Action(
            delegate()
            {
                parent.Activate();
                parent.TopMost = true;  // important
                parent.TopMost = false; // important
                parent.Focus();
                parent.BringToFront();
            }));
            dialog.Filter = FileName + "|" + fileFull;
            dialog.FileName = FileName;
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                selectedPath = dialog.FileName;
            }
        }));

        t.SetApartmentState(ApartmentState.STA);
        t.Start();
        t.Join();
        return selectedPath;
    }
}