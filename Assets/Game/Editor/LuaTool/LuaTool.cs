using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class LuaTool
{
    [MenuItem("Framework/LuaTool/MoveLuaFiles")]
    public static void MoveLuaFiles()
    {
        var luaPath = Application.dataPath + "/Game/LuaFiles";
        var resPath = Application.dataPath + "/Game/Lua";

        Directory.Delete(resPath, true);

        if (Directory.Exists(resPath) == false)
        {
            Directory.CreateDirectory(resPath);
        }

        IOHelper.DirectoryCopy(luaPath, resPath, ".txt");
        AssetDatabase.Refresh();
        Debug.Log("执行完毕");
    }
}