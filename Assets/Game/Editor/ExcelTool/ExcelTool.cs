/*⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵
☠ ©2020 Chengdu Mighty Vertex Games. All rights reserved.                                                                        
⚓ Author: SkyAllen                                                                                                                  
⚓ Email: 894982165@qq.com                                                                                  
⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵⛵*/

using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Excel;
using UnityEditor;
using UnityEngine;

public class ExcelTool : EditorWindow
{
    private const string format = "\r\n\t";
    public const string ScriptableObjectReadPath = "Assets/Game/Scripts/ScriptableObject";
    public const string ScriptableObjectWritePath = "Assets/Game/Resources";

    public static Dictionary<string, GridMessage> BigDic;
    private static DataRowCollection collection;
    private static int row;
    private static int col;
    public static string ReadExcelPath = EditorGame.GetMyOtherPath();


    [MenuItem("Framework/ExcelTool/CreateScriptableObject")]
    public static void CreateScriptableObject()
    {
        var lists = GetFixedFilePaths();
        foreach (var s in lists)
        {
            ReadExcel(s);
            FillBigDic();
            CreateCS(s);
        }
    }

    [MenuItem("Framework/ExcelTool/SetScriptableObjectData")]
    public static void SetScriptableObjectData()
    {
        var lists = GetFixedFilePaths();
        foreach (var s in lists)
        {
            ReadExcel(s);
            FillBigDic();
            SetConfigGenenal<ProductConfigList, ProductConfig>(s);
        }
    }

    [MenuItem("Framework/ExcelTool/CreateSetLuaData")]
    public static void CreateSetLuaData()
    {
        var lists = GetFixedFilePaths();
        foreach (var s in lists)
        {
            ReadExcel(s);
            FillBigDic();
            CreateLua(s);
        }
    }

    private static List<string> GetFixedFilePaths()
    {
        var lists = IOHelper.GetAllFilePaths(EditorGame.GetMyOtherPath(), "*.xlsx");
        List<string> res = new List<string>();
        foreach (var s in lists)
        {
            if (s.Contains("~$"))
            {
                continue;
            }

            res.Add(IOHelper.GetFileName(s));
        }

        return res;
    }

    private static void SetConfigGenenal<TList, TItem>(string FileName)
        where TList : ScriptableObject where TItem : class, new()
    {
        var listObj = CreateInstance<TList>();

        var f = typeof(TList).GetField("list");

        var t1List = new List<TItem>();
        for (var i = 1; i < row; i++)
        {
            var t1 = new TItem();

            foreach (var kv in BigDic)
            {
                var fName = kv.Key;
                var fType = kv.Value._createFieldType;

                var info = typeof(TItem).GetField(fName);

                switch (fType)
                {
                    case CreateFieldType.Null:
                        break;
                    case CreateFieldType.INT:
                        info.SetValue(t1, CovertInt(GetItemItemStr(fName, i)));
                        break;
                    case CreateFieldType.STRING:
                        info.SetValue(t1, CovertString(GetItemItemStr(fName, i)));
                        break;
                    case CreateFieldType.DOUBLE:
                        info.SetValue(t1, CovertDouble(GetItemItemStr(fName, i)));
                        break;
                    case CreateFieldType.BOOL:
                        info.SetValue(t1, CovertBoolean(GetItemItemStr(fName, i)));
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }
            }

            t1List.Add(t1);
        }

        f.SetValue(listObj, t1List);

        var path = $"{ScriptableObjectWritePath}/{FileName}List.asset";
        AssetDatabase.CreateAsset(listObj, path);
        EditorGame.Refresh();
        Log.LogPrint("SetConfig Success");
    }

    private static string GetItemItemStr(string filed, int row)
    {
        var col = BigDic[filed].belongColumn;
        var res = GetFixedCollectionGrid(row, col);
        return res;
    }

    private static string GetFixedCollectionGrid(int row, int col)
    {
        string res = collection[row][col].ToString().Trim();

        if (row == 0 && string.IsNullOrWhiteSpace(res))
        {
            throw new Exception("Key is empty error!");
        }

        return res;
    }

    private static void ReadExcel(string FileName, int sheetIndex = 0)
    {
        var excelFullPath = $"{ReadExcelPath}/{FileName}.xlsx";
        var stream = File.Open(excelFullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        var excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
        var result = excelReader.AsDataSet();
        var t = result.Tables[sheetIndex];

        collection = t.Rows;
        row = t.Rows.Count;
        col = t.Columns.Count;

        stream.Close();
        excelReader.Close();
    }

    private static void FillBigDic()
    {
        BigDic = new Dictionary<string, GridMessage>();

        var contents = new List<string>();
        for (var c = 0; c < col; c++) contents.Add(GetFixedCollectionGrid(0, c));

        for (var index = 0; index < contents.Count; index++)
        {
            var str = contents[index];
            var t = GetType(str);

            if (BigDic.ContainsKey(t.Item2) == false)
            {
                var g = new GridMessage();
                g.belongColumn = index;
                g._createFieldType = t.Item1;
                BigDic.Add(t.Item2, g);
            }
            else
            {
                throw new Exception("Same Key");
            }
        }
    }

    private static string GetMainContent()
    {
        var res = "";
        foreach (var kv in BigDic)
        {
            var name = kv.Key;
            var g = kv.Value;

            res = $"{res}public {GetCreateFieldTypeStr(g._createFieldType)} {name};{format}";
        }

        return res;
    }

    private static string GetListContent(string FileName)
    {
        var sb = new StringBuilder();
        sb.Append($"using System;{format}");
        sb.Append($"using System.Collections.Generic;{format}");
        sb.Append($"using UnityEngine;{format}");
        sb.Append($"[Serializable]{format}");
        sb.Append($"[CreateAssetMenu]{format}");
        sb.Append($"public class {FileName}List : ScriptableObject{format}");
        sb.Append("{");
        sb.Append($"public List<{FileName}> list = new List<{FileName}>();{format}");
        sb.Append("}");
        return sb.ToString();
    }

    private static string GetItemContent(string FileName)
    {
        var sb = new StringBuilder();
        sb.Append($"using UnityEngine;{format}");
        sb.Append($"[System.Serializable]{format}");
        sb.Append($"public class {FileName}{format}");
        sb.Append("{");
        sb.Append(GetMainContent());
        sb.Append("}");
        return sb.ToString();
    }

    public static int CovertInt(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return 0;
        }
        else
        {
            return Convert.ToInt32(content);
        }
    }

    public static string CovertString(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return "";
        }
        else
        {
            return Convert.ToString(content);
        }
    }

    public static double CovertDouble(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return 0;
        }
        else
        {
            return Convert.ToDouble(content);
        }
    }

    public static bool CovertBoolean(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return false;
        }
        else
        {
            return Convert.ToBoolean(content);
        }
    }

    private static void CreateLua(string FileName)
    {
        /*foreach (var key in BigDic.Keys)
        {
            Log.LogParas(key, BigDic[key].belongColumn, BigDic[key]._createFieldType);
        }*/

        StringBuilder sb = new StringBuilder();
        sb.Append($"{FileName}={{");

        for (var i = 1; i < row; i++)
        {
            StringBuilder sbPer = new StringBuilder();
            sbPer.Append("{");
            foreach (var kv in BigDic)
            {
                var fName = kv.Key;
                var fType = kv.Value._createFieldType;

                string s = "";
                switch (fType)
                {
                    case CreateFieldType.Null:
                        break;
                    case CreateFieldType.INT:
                        s = CovertInt(GetItemItemStr(fName, i)).ToString();
                        break;
                    case CreateFieldType.STRING:
                        s = $"'{CovertString(GetItemItemStr(fName, i))}'";
                        break;
                    case CreateFieldType.DOUBLE:
                        s = CovertDouble(GetItemItemStr(fName, i)).ToString();
                        break;
                    case CreateFieldType.BOOL:
                        s = CovertBoolean(GetItemItemStr(fName, i)).ToString().ToLower();
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }

                sbPer.Append($"{fName}={s},{format}");
            }

            sbPer.Append("},");

            sb.Append(sbPer);
        }

        sb.Append("}");

        var path = $"{Path.Combine(LuaSystem.LuaRoot(), "data")}/{FileName}.lua";
        IOHelper.CreateFileByStream(path, sb.ToString());
        Log.LogParas($"Excel To Lua {FileName} Success");
    }

    private static void CreateCS(string FileName)
    {
        IOHelper.CreateFileByStream(EditorGame.GetAssetsPathAbsolute(ScriptableObjectReadPath) + $"/{FileName}.cs",
            GetItemContent(FileName));
        IOHelper.CreateFileByStream(
            EditorGame.GetAssetsPathAbsolute(ScriptableObjectReadPath) + $"/{FileName}List.cs",
            GetListContent(FileName));

        EditorGame.Refresh();
        Log.LogPrint("Create CS File Success");
    }


    private static string GetCreateFieldTypeStr(CreateFieldType type)
    {
        var res = type.ToString();
        return res.ToLower();
    }

    private static (CreateFieldType, string) GetType(string field)
    {
        CreateFieldType res = default;
        var r = new Regex(@"(?<=\()(\w+)(?=\))");
        var val = r.Match(field).Value;

        if (val == GetCreateFieldTypeStr(CreateFieldType.INT))
            res = CreateFieldType.INT;
        else if (val == GetCreateFieldTypeStr(CreateFieldType.STRING))
            res = CreateFieldType.STRING;
        else if (val == GetCreateFieldTypeStr(CreateFieldType.DOUBLE))
            res = CreateFieldType.DOUBLE;
        else if (val == GetCreateFieldTypeStr(CreateFieldType.BOOL))
            res = CreateFieldType.BOOL;
        else
            throw new Exception("CreateFieldTypeNull");

        var rName = new Regex(@"(\w+)(?=\()");
        var valName = rName.Match(field).Value;
        if (string.IsNullOrEmpty(valName)) throw new Exception("Name is Null");

        return (res, valName);
    }

    public class GridMessage
    {
        public CreateFieldType _createFieldType;
        public int belongColumn;
    }
}

public enum CreateFieldType
{
    Null,
    INT,
    STRING,
    DOUBLE,
    BOOL
}