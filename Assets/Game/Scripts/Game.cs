using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    public const string SystemSuffix = "System";
    public static Game I;
    private readonly Dictionary<string, Panel> _panels = new Dictionary<string, Panel>();
    private readonly Dictionary<string, GameSystem> _systems = new Dictionary<string, GameSystem>();
    public static Transform CanvasTrans => GameObject.Find("Game/Canvas").transform;

    private Game()
    {
    }

    private void Start()
    {
        var config = Factorys.GetAssetFactory()
    .LoadScriptableObject<ProductConfigList>().list[0];
        SetMatchWidthOrHeight(config);

        /*if (Game.VData.Debug == true)
        {
            GameObject.Find("Reporter").SetActive(true);
        }
        else
        {
            GameObject.Find("Reporter").SetActive(false);
        }*/

        Initinal();
    }

    public void Update()
    {
        InputProcess();
        foreach (var s in _systems.Values) s.EachFrame();
        foreach (var p in _panels.Values) p.EachFrame();
    }

    private void OnDestroy()
    {
        Release();
    }

    public LuaSystem luaSystem { get; set; }
    public HotUpdateSystem HotUpdateSystem { get; set; }

    //public MainPanel _mainPanel { get; set; }
    //public TipPanel tipPanel { get; set; }

    public static VersionToolData VData => AF.LoadScriptableObject<VersionToolData>();

    public static IAssetFactory AF => Factorys.GetAssetFactory();

    //public VersionToolData _versionToolData { get; set; }

    private void Reset()
    {

    }

    public void Initinal()
    {
        DontDestroyOnLoad(gameObject);

        I = this;

        HotUpdateSystem = AddSystem<HotUpdateSystem>();
        luaSystem = AddSystem<LuaSystem>();

        /*_mainPanel = AddPanel<MainPanel>();
        tipPanel = AddPanel<TipPanel>();*/
    }

    private void Release()
    {
        foreach (var s in _systems.Values) s.Release();
        foreach (var p in _panels.Values) p.Release();
    }

    private void InputProcess()
    {
    }

    private T AddSystem<T>() where T : GameSystem
    {
        var systemName = typeof(T).Name;
        var t = GetComponentInChildren<T>();
        var go = t.gameObject;

        go.transform.LocalReset();

        _systems.Add(systemName, t);
        _systems[systemName].Initialize();

        return _systems[systemName] as T;
    }

    public T AddPanel<T>() where T : Panel
    {
        var panelName = typeof(T).Name;
        if (!_panels.ContainsKey(panelName))
        {
            GameObject
                go = Resources
                    .Load<GameObject>(panelName) as GameObject; //  Factorys.GetAssetFactory().LoadPanel(panelName);
            GameObject tempGo = Instantiate(go) as GameObject;
            tempGo.Name(panelName);

            _panels.Add(panelName, tempGo.GetComponent<Panel>());
            _panels[panelName].Initialize();
        }

        return _panels[panelName] as T;
    }

    private static void SetMatchWidthOrHeight(ProductConfig config) //横1竖0
    {
        float longNumber = config.ScreenLong;
        float shortNumber = config.ScreenShort;

        var canvasScaler = Game.CanvasTrans.GetComponent<CanvasScaler>();
        canvasScaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;

        if (config.LandScape)
        {
            canvasScaler.referenceResolution = new Vector2(longNumber, shortNumber);
            canvasScaler.matchWidthOrHeight = 1;
        }
        else
        {
            canvasScaler.referenceResolution = new Vector2(shortNumber, longNumber);
            canvasScaler.matchWidthOrHeight = 0;
        }
    }
}