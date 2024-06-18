class fake_binary
{
    [DllImport("user32.dll")]
    static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("Kernel32")]
    public static extern IntPtr GetConsoleWindow();

    const int SW_HIDE = 0;
    const int SW_SHOW = 5;

    public static void Main()
    {
        IntPtr hWnd = GetConsoleWindow();
        ShowWindow(hWnd, SW_HIDE);
        while (true)
        {
            Thread.Sleep(30000);
        }
    }
}