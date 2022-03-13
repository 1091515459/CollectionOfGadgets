using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.SearchService;
using UnityEngine;

namespace ABE
{
    public enum EquipmentType
    {
        线,
        点位
    } 

    [CreateAssetMenu(fileName = "AssetBundleExport", menuName = "AssetBundleExport", order = 12)]
    public class AssetBundleExportModel : ScriptableObject
    {

        public EquipmentType type;
    }
}
