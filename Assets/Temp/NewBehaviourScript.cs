using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class NewBehaviourScript : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var k = DOTween.Sequence();
        k.Complete();
        transform.DOScale(2, 2);
        transform.DOScale(2f, 2f);
        DOTween.Pause(k);
        DOTween.Play(k);
        k.IsPlaying();
        k.PlayForward();
        k.Pause();
        k.Complete();
        k.IsPlaying();
        RectTransform re = transform as RectTransform;
        re.DOAnchorPosY(10, 2).SetRelative(true);
        re.DOAnchorPosY(3, 2);
        //re.DOAnchorPos(Vector2.one, 2f)
        Image g;
    }

    // Update is called once per frame
    void Update()
    {
    }
}