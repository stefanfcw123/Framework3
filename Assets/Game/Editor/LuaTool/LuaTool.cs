using System.Collections;
using System.Collections.Generic;
using System.IO;
using QFramework;
using UnityEditor;
using UnityEngine;

public class LuaTool
{
    [MenuItem("Framework/LuaTool/MoveLuaFiles")]
    public static void MoveLuaFiles()
    {
        var luaPath = LuaSystem.LuaRoot();
        var resPath = Application.dataPath + "/Game/Resources/LuaFiles";

        resPath.DeleteDirIfExists();
        resPath.CreateDirIfNotExists();

        IOHelper.DirectoryCopy(luaPath, resPath, ".txt");
        AssetDatabase.Refresh();
        Debug.Log("执行完毕");
    }
}