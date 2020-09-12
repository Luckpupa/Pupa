using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectSpawn : MonoBehaviour
{
    public GameObject Effect;

    // Start is called before the first frame update
    void Start()
    {
        InvokeRepeating("Spawn", 2f, 2f);
    }

    void Spawn()
    {
        Instantiate(Effect);
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
