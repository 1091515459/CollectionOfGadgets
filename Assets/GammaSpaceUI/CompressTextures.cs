using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;


/// <summary>
/// ��������ͼƬ����������
/// </summary>
public class ChangeAllAttributesOfOutTexture
{
    // zhangxu 2021-12-02 [ ��GammerͼƬת����LinearͼƬ ]
    public static Texture2D GammerToLiner(Texture2D texture)
    {
        //��������Ⱦ����
        RenderTexture renderTexture = RenderTexture.GetTemporary(texture.width, texture.height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        //�����ɶ���Texture2D
        Texture2D texture2D = new Texture2D(texture.width, texture.height, TextureFormat.ARGB32, false, true);
        //��¼ԭRenderTexture�������Ⱦ����
        RenderTexture oldActive = RenderTexture.active;
        //λ�鴫�ͣ�����texture����renderTexture
        Graphics.Blit(texture, renderTexture);
        //�޸�RenderTexture����Ⱦ����
        RenderTexture.active = renderTexture;
        //��ȡRenderTexture����Ⱦ����������Ϣ���洢Ϊ��������(Texture2D)
        texture2D.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
        //Ӧ��ǰ���texture2D�Ĳ���
        texture2D.Apply();
        //��ԭRenderTexture��ԭ��Ⱦ����
        RenderTexture.active = oldActive;
        //�ͷ���ʱ��Ⱦ����
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

