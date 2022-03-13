using System.Collections;
using System.Collections.Generic;
using System.IO;
using Unity.VisualScripting;
using Unity.VisualScripting.FullSerializer;
using UnityEditor;
using UnityEditor.VersionControl;
using UnityEngine;

namespace ABE
{
     public class AssetBundleExportHelper : MonoBehaviour
     {
          private Transform obj;

          public void Out(Transform export, EquipmentType type)
          {
               if (export != null) obj = export;
               switch (type)
               {
                    case EquipmentType.线:
                         LineOut();
                         break;
                    case EquipmentType.点位:
                         PointOut();
                         break;
               }
          }

          private void LineOut()
          {
               var grandFa = obj.GetComponentsInChildren<LineRenderer>(true);
               Vector3[] v3 = new Vector3[2] {new Vector3(0, 0, 0), new Vector3(0, 0, 10)};
               foreach (LineRenderer child in grandFa)
               {
                    child.SetPositions(v3);
               }

               string path;
               BuildAssetsBundles(SavePrefab(obj, out path), path);
          }
          
          private void PointOut()
          {
               
          }

          static Transform SavePrefab(Transform obj, out string path)
          {
               if (!Directory.Exists(GetPath("AssetBundleExportHelper") + "/Export"))
                    Directory.CreateDirectory(GetPath("AssetBundleExportHelper") + "/Export");
               path = GetPath("AssetBundleExportHelper") + "/Export/" + obj.name + ".prefab";
               path = AssetDatabase.GenerateUniqueAssetPath(path);
               bool prefabSuccess;
               GameObject go = PrefabUtility.SaveAsPrefabAsset(obj.gameObject, path, out prefabSuccess);
               if (prefabSuccess)
                    Debug.Log("Prefab 保存成功");
               else
                    Debug.Log("Prefab 保存失败" + prefabSuccess);
               return go.transform;
          }

          static void BuildAssetsBundles(Transform go,string prefabPath)
          {
               //创建路径
               if (Directory.Exists(Application.streamingAssetsPath) == false)
               {
                    Directory.CreateDirectory(Application.streamingAssetsPath);
               }
               AssetBundleBuild[] buildMap = new AssetBundleBuild[1];

               buildMap[0].assetBundleName = go.name;
               string[] enemyAssets = new string[1];
               enemyAssets[0] = prefabPath;

               buildMap[0].assetNames = enemyAssets;
               //使用LZMA算法打包
               BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath, buildMap,
                    BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);
          }
          
          //获取当前脚本的文件夹路径，参数为脚本的名字
          static string GetPath(string _scriptName)
          {
               string[] path = UnityEditor.AssetDatabase.FindAssets(_scriptName);
               if(path.Length>1)
               {
                    Debug.LogError("有同名文件"+_scriptName+"获取路径失败");
                    return null;
               }
               //将字符串中得脚本名字和后缀统统去除掉
               string _path = AssetDatabase.GUIDToAssetPath(path[0]).Replace((@"/"+_scriptName+".cs"),"");
               return _path;
          }
     }
}
