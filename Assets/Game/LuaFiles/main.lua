if jit then
    jit.off();
    jit.flush()
end

print(jit, jit.version, _VERSION)

UnityEngine = CS.UnityEngine;
Canvas = UnityEngine.Canvas
GameObject = CS.UnityEngine.GameObject;
Transform = CS.UnityEngine.Transform;
RectTransform = CS.UnityEngine.RectTransform;
Vector3 = CS.UnityEngine.Vector3;
Vector2 = CS.UnityEngine.Vector2;
CanvasGroup = CS.UnityEngine.CanvasGroup;
Time = CS.UnityEngine.Time;
Random = CS.UnityEngine.Random;
Quaternion = CS.UnityEngine.Quaternion;
Physics2D = CS.UnityEngine.Physics2D;
AudioSource = CS.UnityEngine.AudioSource;
Resources = CS.UnityEngine.Resources;
Color = CS.UnityEngine.Color;
Tweening = CS.DG.Tweening;
RotateMode = Tweening.RotateMode;
Ease = Tweening.Ease;
DOTween = CS.DG.Tweening.DOTween
SpriteRenderer = CS.UnityEngine.SpriteRenderer;
UI = CS.UnityEngine.UI;
Button = UI.Button;
Text = CS.UnityEngine.UI.Text;
InputField = UnityEngine.UI.InputField;
Image = UI.Image;
Text = UI.Text;
Slider = UI.Slider;
WaitForSeconds = CS.UnityEngine.WaitForSeconds;
WaitForEndOfFrame = CS.UnityEngine.WaitForEndOfFrame;
WaitUntil = CS.UnityEngine.WaitUntil;
AF = CS.Factorys.GetAssetFactory();

