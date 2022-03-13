#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GD.MinMaxSlider;
using Unity.VisualScripting;
using UnityEditor;

namespace RandomSizeGen
{
    [CustomEditor(typeof(RandomSizeGenModel), true)]
    // [CustomEditor(typeof(RandomSizeGenHelper))]
    [CanEditMultipleObjects]
    public class RandomSizeGen : Editor
    {
        private RandomSizeGenModel ranModel { get { return serializedObject.targetObject as RandomSizeGenModel; } }
        private RandomSizeGenHelper ran = null;
        private Object t = null;

        public override void OnInspectorGUI()
        {
            ran = new RandomSizeGenHelper();
            base.OnInspectorGUI();
            t = EditorGUILayout.ObjectField("Boss", t, typeof(Transform), true);
            if (t != null) ran.OnStart(t as Transform);
            ran.放大倍数 = ranModel.放大倍数;
            ran.胖瘦 = ranModel.胖瘦;
            ran.高低 = ranModel.高低;
            ran.旋转 = ranModel.旋转;
            ran.模式 = ranModel.模式;
            ran.单级子物体 = ranModel.单级子物体;

            if (GUILayout.Button("Run"))
            {
                if (t != null) ran.Play(t as Transform);
            }
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.Label("----------------------------------");
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            if (GUILayout.Button("Clear"))
            {
                if (t != null) ran.Clear(t as Transform);
            }
        }
    }
}
#endif
