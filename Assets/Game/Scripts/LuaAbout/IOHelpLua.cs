using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public static class IOHelpLua
{
    private static string targetDir = "Game/Resources/Text";

    public static string GetFullPath()
    {
        return Path.Combine(Application.dataPath, targetDir);
    }

    public static string GetLVFullPath(int lv)
    {
        string str = $"Lv{lv}";
        return Path.Combine(GetFullPath(), str);
    }

    public static void CreateText(string path, string content)
    {
        IOHelper.CreateText(path, content);
    }

    public static void CreateTemp(string content)
    {
        string path = Path.Combine(GetLVFullPath(1), "1.txt");
        IOHelper.CreateText(path, content);
    }
}