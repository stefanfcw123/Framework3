using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tmepPanl : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var c = GetComponent<Canvas>();
        c.overrideSorting = true;
        c.sortingOrder = 3;
    }

    // Update is called once per frame
    void Update()
    {
    }
}