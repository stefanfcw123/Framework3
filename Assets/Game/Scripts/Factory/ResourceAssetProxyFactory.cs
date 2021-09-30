using System.Collections.Generic;
using QFramework;
using UnityEngine;
using UnityEngine.U2D;

// 做為ResourceAssetFactory的Proxy代理者,會記錄已經載入過的資源
public class ResourceAssetProxyFactory : IAssetFactory
{
    private readonly Dictionary<string, AudioClip> m_Audios;
    private readonly Dictionary<string, Object> m_Effects;
    private readonly ResourceAssetFactory m_ResFactory; // 實際負責載入的AssetFactory
    //private readonly QFResourceAssetFactory m_QFFactory; 
    private readonly Dictionary<string, Sprite> m_Sprites;

    public ResourceAssetProxyFactory()
    {
        /*ResKit.Init();
        m_QFFactory = new QFResourceAssetFactory();*/
        m_ResFactory = new ResourceAssetFactory();
        m_Effects = new Dictionary<string, Object>();
        m_Audios = new Dictionary<string, AudioClip>();
        m_Sprites = new Dictionary<string, Sprite>();
    }

    // 產生特效
    public override GameObject LoadEffect(string AssetName)
    {
        /*if (m_Effects.ContainsKey(AssetName) == false)
        {
            var res =
                m_ResFactory.LoadGameObjectFromResourcePath(ResourceAssetFactory.EffectPath + AssetName);
            m_Effects.Add(AssetName, res);
        }

        return Object.Instantiate(m_Effects[AssetName]) as GameObject;*/

        return m_ResFactory.LoadEffect(AssetName);
    }

    // 產生AudioClip
    public override AudioClip LoadAudioClip(string ClipName)
    {
        return m_ResFactory.LoadAudioClip(ClipName);
    }

    // 產生Sprite
    public override Sprite LoadSprite(string SpriteName)
    {
        if (m_Sprites.ContainsKey(SpriteName) == false)
        {
            var res = m_ResFactory.LoadSprite(SpriteName);
            m_Sprites.Add(SpriteName, res);
        }
        return m_Sprites[SpriteName];

        //return m_QFFactory.LoadSprite(spriteName);
    }

    public override Material LoadMaterial(string name)
    {
        return m_ResFactory.LoadMaterial(name);
    }

    public override Font LoadFont(string name)
    {
        return m_ResFactory.LoadFont(name);
    }

    public override TextAsset LoadTextAsset(string name)
    {
        return m_ResFactory.LoadTextAsset(name);
    }

    public override SpriteAtlas LoadSpriteAtlas(string name)
    {
        return null;
    }

    public override GameObject LoadPanel(string name)
    {
        return m_ResFactory.LoadPanel(name);
    }

    public override GameObject LoadPool(string name)
    {
        return m_ResFactory.LoadPool(name);
    }

    public override GameObject loadGameObject(string name)
    {
        //return m_QFFactory.loadGameObject(name);
        return m_ResFactory.loadGameObject(name);
    }

    public override T LoadScriptableObject<T>()
    {
        return m_ResFactory.LoadScriptableObject<T>();
    }
}