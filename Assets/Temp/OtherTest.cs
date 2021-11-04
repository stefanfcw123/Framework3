using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class OtherTest : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Image img = GameObject.Find("Canvas/Image").GetComponent<Image>();
        var s = Resources.Load<Sprite>("bar1");
        print(s.rect.width);
        print(s.rect.height);
        img.sprite = s;
        img.SetNativeSize();
        Text t = default;
        GameObject s22 = null;
        print(s22.activeInHierarchy);
    }

    private IEnumerator Wait(Tween _tweener)
    {
        yield return _tweener.WaitForCompletion();
        //执行玩2次之后
        //yield return _tweener.WaitForElapsedLoops(2);
        //等等动画执行几秒后执行
        //yield return _tweener.WaitForPosition();
        //yield return _tweener.WaitForRewind();
        //yield return _tweener.WaitForStart();
    }
}

public class GFG
{
    /* arr[] ---> Input Array
chosen[] ---> Temporary array to store indices of
                current combination
start & end ---> Starting and Ending indexes in arr[]
r ---> Size of a combination to be printed */
    static void CombinationRepetitionUtil(int[] chosen, int[] arr,
        int index, int r, int start, int end)
    {
        // Since index has become r, current combination is
        // ready to be printed, print
        if (index == r)
        {
            for (int i = 0; i < r; i++)
            {
                Debug.Log(arr[chosen[i]] + " ");
            }

            Debug.Log("----------");
            return;
        }

        // One by one choose all elements (without considering
        // the fact whether element is already chosen or not)
        // and recur
        for (int i = start; i <= end; i++)
        {
            chosen[index] = i;
            CombinationRepetitionUtil(chosen, arr, index + 1,
                r, i, end);
        }

        return;
    }

// The main function that prints all combinations of size r
// in arr[] of size n with repetitions. This function mainly
// uses CombinationRepetitionUtil()
    static void CombinationRepetition(int[] arr, int n, int r)
    {
        // Allocate memory
        int[] chosen = new int[r + 1];

        // Call the recursive function
        CombinationRepetitionUtil(chosen, arr, 0, r, 0, n - 1);
    }

// Driver program to test above functions
    public static void Main()
    {
        int[] arr = {1, 2, 3};
        int n = arr.Length;
        int r = 2;
        CombinationRepetition(arr, n, r);
    }
}