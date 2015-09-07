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


    public static string ShowFileDialog(string FileName,string fileFull)
    {
        string selectedPath = "";
        var t = new Thread((ThreadStart)(() =>
        {
            FileDialog fbd = new OpenFileDialog();
            fbd.Filter = FileName+"|" + fileFull;
            if (fbd.ShowDialog() == DialogResult.OK)
            {
                selectedPath = fbd.FileName;
            }
        }));
        t.SetApartmentState(ApartmentState.STA);
        t.Start();

        t.Join();
        return selectedPath;
    }
}