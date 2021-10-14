using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class rotateImage : MonoBehaviour
{
    private float speed = 150;

    private RectTransform rect;
    private float initY = 0;

    private float origin = 0;
    public bool isStop = false;

    // Start is called before the first frame update
    void Start()
    {
        rect = GetComponent<RectTransform>();
        initY = rect.anchoredPosition.y;
        origin = initY;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            rect.anchoredPosition = new Vector2(rect.anchoredPosition.x, origin);
            isStop = true;
            float delay = 0.1f;
            rect.DOAnchorPosY(-30, delay).SetRelative(true).OnComplete(() =>
            {
                rect.DOAnchorPosY(30, delay).SetRelative(true).SetEase(Ease.InOutQuart);
            });
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            isStop = false;
        }

        if (isStop == true)
        {
            return;
        }

        for (int i = 0; i < speed; i++)
        {
            initY -= 0.1f;
            if (initY <= -200)
            {
                initY = 200;
            }

            rect.anchoredPosition = new Vector2(rect.anchoredPosition.x, initY);
        }
    }
}