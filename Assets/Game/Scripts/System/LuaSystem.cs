﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Resources;
using UnityEngine;
using UnityEngine.Networking;
using XLua;
using XLua.LuaDLL;

public enum ArgTypes
{
    Float,
    Int,
    Boolean,
    String,
    GameObject,
    LuaTable,
    LuaFunction,
}

[System.Serializable]
public class LuaArg
{
    public ArgTypes ArgType;
    public string ArgValue;
}

//[DefaultExecutionOrder(1)]
public class LuaSystem : GameSystem
{
    public static LuaEnv LuaEnv = new LuaEnv();

    public override void Release()
    {
        base.Release();

        if (LuaEnv != null)
        {
            LuaEnv = null;
        }
    }

    public static string LuaRoot()
    {
        return Application.dataPath + "/Game/LuaFiles";
    }

    public override void Initialize()
    {
        base.Initialize();
    }

    public static void HotReload()
    {
        LuaEnv.DoString("require('functions.Hotfix')");
    }

    private byte[] CustomLoader(ref string filepath)
    {
        if (Differences.Ediotr())
        {
            if (Game.VData.Debug == false)
            {
                /*var full = filepath.Split('.');
                var name = $"{full[full.Length - 1]}";
                TextAsset txt = Factorys.GetAssetFactory().LoadTextAsset($"{name}.lua");
                return System.Text.Encoding.UTF8.GetBytes(txt.text);*/

                filepath = "LuaFiles/" + filepath.Replace('.', '/') + ".lua";
                TextAsset file = Factorys.GetAssetFactory().LoadTextAsset(filepath);
                return file.bytes;
            }
            else
            {
                filepath = Application.dataPath + "/Game/LuaFiles/" + filepath.Replace('.', '/') + ".lua";
                return File.ReadAllBytes(filepath);
            }
        }
        else
        {
            filepath = "LuaFiles/" + filepath.Replace('.', '/') + ".lua";
            Debug.Log("filePath:" + filepath);
            TextAsset file = Factorys.GetAssetFactory().LoadTextAsset(filepath);
            Debug.Log(file);
            return file.bytes;
        }
    }

    public static LuaTable GetLua(GameObject go, LuaTable baseClass
    )
    {
        LuaMono[] behaviourLuas = go.GetComponents<LuaMono>();

        foreach (var behaviour in behaviourLuas)
        {
            if (behaviour.LuaClass.GetHashCode() == baseClass.GetHashCode())
            {
                return behaviour.TableIns;
            }
        }

        return null;
    }

    private static Dictionary<string, List<LuaArg>> VerifyArgsDic = new Dictionary<string, List<LuaArg>>();

    public static object[] GetAllChange(List<LuaArg> args, string luaClassName)
    {
        if (!VerifyArgsDic.ContainsKey(luaClassName))
        {
            VerifyArgsDic.Add(luaClassName, args);
        }
        else
        {
            var tempArgs = VerifyArgsDic[luaClassName];

            if (!VerifyArgsRight(tempArgs, args))
            {
                throw new Exception($"LuaTable {luaClassName} 's ctor args disunion.");
            }
        }


        List<object> objs = new List<object>();

        foreach (var luaArg in args)
        {
            switch (luaArg.ArgType)
            {
                case ArgTypes.Int:
                    objs.Add(ChangeInt(luaArg.ArgValue));
                    break;
                case ArgTypes.Float:
                    objs.Add(ChangeFloat(luaArg.ArgValue));
                    break;
                case ArgTypes.String:
                    objs.Add(ChangeString(luaArg.ArgValue));
                    break;
                case ArgTypes.Boolean:
                    objs.Add(ChangeBoolean(luaArg.ArgValue));
                    break;
                case ArgTypes.LuaTable:
                    objs.Add(ChangeTable(luaArg.ArgValue));
                    break;
                case ArgTypes.LuaFunction:
                    objs.Add(ChangeFunction(luaArg.ArgValue));
                    break;
                case ArgTypes.GameObject:
                    objs.Add(ChangeGameObject(luaArg.ArgValue));
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        return objs.ToArray();
    }

    private static bool VerifyArgsRight(List<LuaArg> cacheArgs, List<LuaArg> newArgs)
    {
        bool bo1 = (cacheArgs.Count == newArgs.Count);

        if (bo1 == false)
        {
            return false;
        }

        int count = cacheArgs.Count;
        for (var index = 0; index < count; index++)
        {
            var cacheArg = cacheArgs[index];
            var newArg = newArgs[index];

            if (cacheArg.ArgType != newArg.ArgType)
            {
                return false;
            }
        }

        return true;
    }

    public static int ChangeInt(string val)
    {
        return Convert.ToInt32(val);
    }

    public static float ChangeFloat(string val)
    {
        return Convert.ToSingle(val);
    }

    public static string ChangeString(string val)
    {
        return Convert.ToString(val);
    }

    public static bool ChangeBoolean(string val)
    {
        return Convert.ToBoolean(val);
    }

    public static LuaTable ChangeTable(string val)
    {
        throw new Exception("Wait realize.");
    }

    public static LuaFunction ChangeFunction(string val)
    {
        throw new Exception("Wait realize.");
    }

    public static GameObject ChangeGameObject(string val)
    {
        return GameObject.Find(val);
    }

    public LuaSystem(Game game) : base(game)
    {
    }

    private void StartPlayCallback(StartPlay obj)
    {
        LuaEnv.AddLoader(CustomLoader);
        LuaEnv.DoString("require('main')", "main");
        var mono = gameObject.AddComponent<LuaMono>();
    }

    //auto
    private void Awake()
    {
        Incident.DeleteEvent<StartPlay>(StartPlayCallback);
        Incident.RigisterEvent<StartPlay>(StartPlayCallback);
    }

    internal static float lastGCTime = 0;
    internal const float GCInterval = 1; //1 second 

    public override void EachFrame()
    {
        base.EachFrame();
        if (Time.time - lastGCTime > GCInterval)
        {
            LuaSystem.LuaEnv.Tick();
            lastGCTime = Time.time;
        }
    }
}