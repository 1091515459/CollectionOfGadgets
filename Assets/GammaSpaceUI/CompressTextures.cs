using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;


/// <summary>
/// 更改外链图片的所有属性
/// </summary>
public class ChangeAllAttributesOfOutTexture
{
    // zhangxu 2021-12-02 [ 将Gammer图片转换成Linear图片 ]
    public static Texture2D GammerToLiner(Texture2D texture)
    {
        //创建新渲染纹理
        RenderTexture renderTexture = RenderTexture.GetTemporary(texture.width, texture.height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        //创建可读的Texture2D
        Texture2D texture2D = new Texture2D(texture.width, texture.height, TextureFormat.ARGB32, false, true);
        //记录原RenderTexture激活的渲染纹理
        RenderTexture oldActive = RenderTexture.active;
        //位块传送，拷贝texture纹理到renderTexture
        Graphics.Blit(texture, renderTexture);
        //修改RenderTexture的渲染纹理
        RenderTexture.active = renderTexture;
        //读取RenderTexture的渲染纹理像素信息，存储为纹理数据(Texture2D)
        texture2D.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
        //应用前面对texture2D的操作
        texture2D.Apply();
        //还原RenderTexture的原渲染纹理
        RenderTexture.active = oldActive;
        //释放临时渲染纹理
        RenderTexture.ReleaseTemporary(renderTexture);

        return texture2D;
    }

    public static Material material {
        get
        {
            Material loadm = Resources.Load("Dawn-UI-Default") as Material;
            return loadm;
        }
    }

}

