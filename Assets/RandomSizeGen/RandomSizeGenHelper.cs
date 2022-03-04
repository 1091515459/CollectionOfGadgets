using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GD.MinMaxSlider;
using UnityEditor;
using Random = UnityEngine.Random;

namespace RandomSizeGen
{
    public enum Model // your custom enumeration
    {
        无,
        作用于自己,
        作用于子级,
        重置
    };
    public class RandomSizeGenHelper : MonoBehaviour
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

        public void OnStart()
        {
            foreach (Transform child in this.transform)
            {
                if (!TMap.ContainsKey(child))
                {
                    Vector3[] dic = new Vector3[2] {child.localScale, child.eulerAngles};
                    TMap.Add(child,dic);
                }
            }
        }

        // void OnValidate(){}
        
        // [ContextMenu("Play")]
        public void Play()
        {
            play(模式);
        }
        // [ContextMenu("Clear")]
        public void Clear()
        {
            play(Model.重置);
        }

        void play(Model m=Model.无)
        {
            if (m == Model.作用于子级)
            {
                if (单级子物体)
                {
                    foreach (Transform child in this.transform)
                    {
                        var p = child.position;
                        var s = child.localScale;
                        var tr = child.eulerAngles;
                        float h = Random.Range(高低.x, 高低.y)*放大倍数;
                        float w = Random.Range(胖瘦.x, 胖瘦.y)*放大倍数;
                        float r = Random.Range(旋转.x, 旋转.y)*放大倍数;
                        child.localScale = new Vector3(w, h, w);
                        child.eulerAngles = new Vector3(tr.x, r, tr.z);
                        var b = child.position - transform.position;
                        // if (模式 == Model.有间隔孩子 && b.magnitude < 0.01f)
                        //     child.position = new Vector3(transform.position.x, transform.position.y,
                        //         transform.position.z + 间隔 * child.GetSiblingIndex());
                    }
                }
                else
                {
                    var grandFa = GetComponentsInChildren<Transform>(true);
                    foreach (Transform child in grandFa)
                    {
                        if (child == transform) continue;
                        var p = child.position;
                        var s = child.localScale;
                        var tr = child.eulerAngles;
                        float h = Random.Range(高低.x, 高低.y)*放大倍数;
                        float w = Random.Range(胖瘦.x, 胖瘦.y)*放大倍数;
                        float r = Random.Range(旋转.x, 旋转.y)*放大倍数;
                        child.localScale = new Vector3(w, h, w);
                        child.eulerAngles = new Vector3(tr.x, r, tr.z);
                        var b = child.position - transform.position;
                        // if (模式 == Model.有间隔孩子 && b.magnitude < 0.01f)
                        //     child.position = new Vector3(transform.position.x, transform.position.y,
                        //         transform.position.z + 间隔 * child.GetSiblingIndex());
                    }
                }
            }
            else if (m == Model.作用于自己)
            {
                var s = transform.localScale;
                var tr = transform.eulerAngles;
                float h = Random.Range(高低.x, 高低.y)*放大倍数;
                float w = Random.Range(胖瘦.x, 胖瘦.y)*放大倍数;
                float r = Random.Range(旋转.x, 旋转.y)*放大倍数;
                transform.localScale = new Vector3(w, h, w);
                transform.eulerAngles = new Vector3(tr.x, r, tr.z);
            }
            else if (m == Model.重置)
            {
                //ZX 2022-03-04 10:27 [还原]
                // foreach (var child in TMap)
                // {
                //     child.Key.localScale = child.Value[0];
                //     child.Key.eulerAngles = child.Value[1];
                // }
                //ZX 2022-03-04 10:27 [重置]
                float s = 放大倍数;
                if (单级子物体)
                {
                    foreach (Transform child in this.transform)
                    {
                        child.localScale = new Vector3(s, s, s);
                        child.eulerAngles = new Vector3(0, 0, 0);
                    }
                }
                else if (模式 == Model.作用于自己)
                {
                    transform.localScale = new Vector3(s, s, s);
                    transform.eulerAngles = new Vector3(0, 0, 0);
                }
                else
                {
                    var grandFa = GetComponentsInChildren<Transform>(true);
                    foreach (Transform child in grandFa)
                    {
                        child.localScale = new Vector3(s, s, s);
                        child.eulerAngles = new Vector3(0, 0, 0);
                    }
                }
            }
        }
    }
}