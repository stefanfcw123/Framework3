using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using QFramework;
using UnityEngine;
using UnityEngine.Networking;

[Serializable]
public class Ver
{
    public int Number;
    public string Explain;
}

public class HotUpdateSystem : GameSystem
{
    private Ver RemoteVar;

    public HotUpdateSystem(Game game) : base(game)
    {
    }

    public override void Initialize()
    {
        base.Initialize();

        StartCoroutine(StartUpdate());
    }

    private IEnumerator StartUpdate()
    {
        var f = Factorys.GetAssetFactory();
        Log.LogParas(f);
        yield return null;

        CopyFiles();
        yield return null;

        Log.LogParas("yiled break");
        yield break;

        var localVer = LoadVersion(File.ReadAllText(LocalVersionPath, Encoding.UTF8));
        yield return StartCoroutine(LoadRemoteVersion());

        Log.LogParas("rNumber", RemoteVar.Number, "lNumber", localVer.Number);
        if (RemoteVar.Number > localVer.Number)
        {
            Log.LogParas("开始执行LoadRemoteABFiles");
            yield return StartCoroutine(LoadRemoteABFiles());
        }

        yield return null;
        Incident.SendEvent(new StartPlay());
    }

    private IEnumerator LoadRemoteABFiles()
    {
        string bin = "asset_bindle_config.bin";
        string mainfest = ".manifest";
        string android = "Android";

        var webRequest = UnityWebRequest.Get(Path.Combine(GetIA(), bin));

        yield return webRequest.SendWebRequest();
        if (webRequest.isHttpError || webRequest.isNetworkError)
        {
        }
        else
        {
            using (Stream openS = new MemoryStream(webRequest.downloadHandler.data))
            {
                var serializeData =
                    (ResDatas.SerializeData) SerializeHelper.DeserializeBinary(openS);

                GetPA().DeleteDirIfExists();
                GetPA().CreateDirIfNotExists();
                Log.LogPrint("清空了:" + GetPA());

                List<string> abNameList = new List<string>();
                abNameList.Add(bin);

                abNameList.Add(android);
                abNameList.Add(android + mainfest);

                foreach (var gData in serializeData.AssetDataGroup)
                {
                    abNameList.Add(gData.key);
                    abNameList.Add(gData.key + mainfest);
                }

                abNameList.Add("version.txt");

                for (var index = 0; index < abNameList.Count; index++)
                {
                    var fileName = abNameList[index];
                    var www = UnityWebRequest.Get(Path.Combine(GetIA(), fileName));
                    yield return www.SendWebRequest();
                    if (www.isHttpError || www.isNetworkError)
                    {
                    }
                    else
                    {
                        IOHelper.CreateFile(Path.Combine(GetPA(), fileName), www.downloadHandler.data);
                    }
                }
            }
        }
    }

    private IEnumerator LoadRemoteVersion()
    {
        var webRequest = UnityWebRequest.Get(RomoteVersionPath);

        yield return webRequest.SendWebRequest();

        if (webRequest.isHttpError || webRequest.isNetworkError)
        {
        }
        else
        {
            RemoteVar = LoadVersion(webRequest.downloadHandler.text);
        }
    }

    private void UpdateError()
    {
        Log.LogParas("UpdateError");
    }

    private Ver LoadVersion(string strContent)
    {
        var xmlDocument = new XmlDocument();
        xmlDocument.LoadXml(strContent);
        var contentXmls = xmlDocument.GetElementsByTagName("Ver");

        var contentXml = contentXmls[contentXmls.Count - 1];

        var VerClass = new Ver
        {
            Number = int.Parse(contentXml.Attributes["Number"].Value),
            Explain = contentXml.Attributes["Explain"].Value
        };
        return VerClass;
    }

    private static string RomoteVersionPath => Path.Combine(GetIA(), "version.txt");
    private static string LocalVersionPath => Path.Combine(GetPA(), "version.txt");


    public static string GetI()
    {
        return "http://192.168.101.19/HFS";
    }

    private static string GetIA()
    {
        return Path.Combine(GetI(), GetA());
    }

    public static string GetPA()
    {
        return Path.Combine(Application.persistentDataPath, GetA());
    }

    public static string GetSA()
    {
        return Path.Combine(Application.streamingAssetsPath, GetA());
    }

    public static string GetA()
    {
        return "AssetBundles/" + AssetBundleSettings.GetPlatformName();
    }

    private void CopyFiles()
    {
        if (AssetBundleSettings.LoadAssetResFromStreammingAssetsPath)
        {
            GetPA().DeleteDirIfExists();
            GetPA().CreateDirIfNotExists();

            Log.LogParas(Directory.Exists(Application.streamingAssetsPath), Application.streamingAssetsPath);
            Log.LogParas(Directory.Exists(Application.streamingAssetsPath + "/AssetBundles"));
            Log.LogParas(Directory.Exists(Application.streamingAssetsPath + "/AssetBundles/Android"));

            Log.LogParas("sa", Directory.Exists(GetSA()));
            IOHelper.DirectoryCopy2(GetSA(), GetPA(), true);

            AssetBundleSettings.LoadAssetResFromStreammingAssetsPath = false;
        }
    }

    public override void Release()
    {
        base.Release();
    }

    //auto
    private void Awake()
    {
    }
}