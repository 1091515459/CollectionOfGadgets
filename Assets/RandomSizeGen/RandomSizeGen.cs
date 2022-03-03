using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GD.MinMaxSlider;
using Unity.VisualScripting;
using UnityEditor;

namespace RandomSizeGen
{
    [CustomEditor(typeof(RandomSizeGenHelper))]
    public class RandomSizeGen : Editor
    {
        private RandomSizeGenHelper gen { get { return serializedObject.targetObject as RandomSizeGenHelper; } }
        public override void OnInspectorGUI()
        {
            gen.OnStart();
            base.OnInspectorGUI();
            if (GUILayout.Button("Run")) 
            {
                gen.Play();
            }
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.Label("----------------------------------");
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            if (GUILayout.Button("Clear")) 
            {
                gen.Clear();
            }
        }
    }
}
