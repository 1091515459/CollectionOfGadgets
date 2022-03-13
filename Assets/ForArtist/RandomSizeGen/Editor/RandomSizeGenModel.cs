#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GD.MinMaxSlider;
using Unity.VisualScripting;
using UnityEditor;

namespace RandomSizeGen
{
    public class RandomSizeGenModel : ScriptableObject
    {
        [MinMaxSlider(0, 1)] public Vector2 胖瘦 = new Vector2(0.9f, 1f);
        [MinMaxSlider(0, 1)] public Vector2 高低 = new Vector2(0.9f, 1f);
        [MinMaxSlider(0, 360)] public Vector2 旋转 = new Vector2(0f, 360f);
        // [MinMaxSlider(0, 10)] public Vector2Int 间隔;
        [HideInInspector]
        public bool 单级子物体 = true;
        public float 放大倍数 = 1.5f;
        // public float 间隔 = 0.1f;
        [HideInInspector]
        public Model 模式 = Model.作用于子级;

        public Dictionary<Transform, Vector3[]> TMap = new Dictionary<Transform, Vector3[]>();
    }
}
#endif