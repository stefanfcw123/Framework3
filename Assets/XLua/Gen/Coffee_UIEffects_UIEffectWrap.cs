#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class CoffeeUIEffectsUIEffectWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Coffee.UIEffects.UIEffect);
			Utils.BeginObjectRegister(type, L, translator, 0, 3, 9, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMaterialHash", _m_GetMaterialHash);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ModifyMaterial", _m_ModifyMaterial);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ModifyMesh", _m_ModifyMesh);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "uvMaskChannel", _g_get_uvMaskChannel);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "effectFactor", _g_get_effectFactor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "colorFactor", _g_get_colorFactor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "blurFactor", _g_get_blurFactor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "effectMode", _g_get_effectMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "colorMode", _g_get_colorMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "blurMode", _g_get_blurMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "paramTex", _g_get_paramTex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "advancedBlur", _g_get_advancedBlur);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "effectFactor", _s_set_effectFactor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "colorFactor", _s_set_colorFactor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "blurFactor", _s_set_blurFactor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "effectMode", _s_set_effectMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "colorMode", _s_set_colorMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "blurMode", _s_set_blurMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "advancedBlur", _s_set_advancedBlur);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					Coffee.UIEffects.UIEffect gen_ret = new Coffee.UIEffects.UIEffect();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Coffee.UIEffects.UIEffect constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMaterialHash(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Material _material = (UnityEngine.Material)translator.GetObject(L, 2, typeof(UnityEngine.Material));
                    
                        UnityEngine.Hash128 gen_ret = gen_to_be_invoked.GetMaterialHash( _material );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ModifyMaterial(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Material _newMaterial = (UnityEngine.Material)translator.GetObject(L, 2, typeof(UnityEngine.Material));
                    UnityEngine.UI.Graphic _graphic = (UnityEngine.UI.Graphic)translator.GetObject(L, 3, typeof(UnityEngine.UI.Graphic));
                    
                    gen_to_be_invoked.ModifyMaterial( _newMaterial, _graphic );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ModifyMesh(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.UI.VertexHelper _vh = (UnityEngine.UI.VertexHelper)translator.GetObject(L, 2, typeof(UnityEngine.UI.VertexHelper));
                    UnityEngine.UI.Graphic _graphic = (UnityEngine.UI.Graphic)translator.GetObject(L, 3, typeof(UnityEngine.UI.Graphic));
                    
                    gen_to_be_invoked.ModifyMesh( _vh, _graphic );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_uvMaskChannel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.uvMaskChannel);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_effectFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.effectFactor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_colorFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.colorFactor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_blurFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.blurFactor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_effectMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.effectMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_colorMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.colorMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_blurMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.blurMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_paramTex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.paramTex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_advancedBlur(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.advancedBlur);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_effectFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.effectFactor = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_colorFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.colorFactor = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_blurFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.blurFactor = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_effectMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                Coffee.UIEffects.EffectMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.effectMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_colorMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                Coffee.UIEffects.ColorMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.colorMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_blurMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                Coffee.UIEffects.BlurMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.blurMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_advancedBlur(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Coffee.UIEffects.UIEffect gen_to_be_invoked = (Coffee.UIEffects.UIEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.advancedBlur = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
