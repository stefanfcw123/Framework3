using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class aa : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var go = transform.Find("Cube");
        go.gameObject.SetActive(true);
        print(go.gameObject.activeInHierarchy);
    }

    // Update is called once per frame
    void Update()
    {
    }
}