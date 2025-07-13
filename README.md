# Quiz
Quiz
Uses MVC and is heavy with the viewcontroller - requires to be moved to MVVC

// temp x64 check
using System;
using System.Diagnostics;
using System.Windows;

namespace WpfApp2
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            try
            {
                using (var process = new Process())
                {
                    process.StartInfo = new ProcessStartInfo
                    {
                       // FileName = @"C:\WINDOWS\system32\TaskMgr.exe", // Ensure this path is valid
                        FileName = @"C:\Program Files\PowerToys\Tools\PowerToys.StylesReportTool.exe",
                        Arguments = "--mode fast --output \"C:\\Results\\output.txt\"",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    };

                    process.Start();
                    string output = process.StandardOutput.ReadToEnd();
                    string error = process.StandardError.ReadToEnd();
                    process.WaitForExit();

                    // Output to debug window instead of console
                    Debug.WriteLine($"Output:\n{output}");
                    Debug.WriteLine($"Error:\n{error}");

                    if (process.ExitCode != 0)
                    {
                        Debug.WriteLine($"Process exited with code: {process.ExitCode}");
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Process failed: {ex.Message}");
                // Optionally show error to user via MessageBox
                MessageBox.Show($"Process failed: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
