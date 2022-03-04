using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace ABE
{
    [CustomEditor(typeof(AssetBundleExportModel), true)]
    [CanEditMultipleObjects]
    public class AssetBundleExport : Editor
    {
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            if (GUILayout.Button("Out"))
            {
                
            }
        }

        [MenuItem("Example/Load Textures To Folder")]
        static void Apply()
        {
            string path = EditorUtility.OpenFolderPanel("Load png Textures", "", "");
            string[] files = Directory.GetFiles(path);

            foreach (string file in files)
                if (file.EndsWith(".png"))
                    File.Copy(file, EditorApplication.currentScene);
        }
    }
}
