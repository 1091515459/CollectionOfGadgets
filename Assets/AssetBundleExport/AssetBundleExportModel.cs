using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.SearchService;
using UnityEngine;

namespace ABE
{

    [CreateAssetMenu(fileName = "AssetBundleExport", menuName = "AssetBundleExport", order = 12)]
    public class AssetBundleExportModel : ScriptableObject
    {
        public Object Bundle;
        private AssetBundle bundleAsset;
        
        public IEnumerator Download(string path)
        {
            yield return GetBundle(path);
            if (bundleAsset == null)
            {
                Debug.LogWarning("Bundle Failed To Download");
            }

            var objs = bundleAsset.LoadAllAssets();
            foreach (var obj in objs)
            {
                
            }
        }

        private IEnumerator GetBundle(string path)
        {
            WWW request = WWW.LoadFromCacheOrDownload(path, 0);
            while(!request.isDone)
            {
                Debug.Log(request.progress);
                yield return null;
            }

            if (request.error == null)
            {
                bundleAsset = request.assetBundle;
            }
            else
            {
                Debug.Log(request.error);
            }
        }
    }
}
