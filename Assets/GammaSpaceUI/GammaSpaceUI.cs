using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GammaSpaceUI : MonoBehaviour
{
	public Camera UICamera;
	public Material UICompositeMaterial;

	private int uitex_id = Shader.PropertyToID("_UITex");

	void Awake()
	{
		UICamera.enabled = false;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		RenderTexture UIRenderTexture = RenderTexture.GetTemporary(src.width, src.height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
		UICamera.targetTexture = UIRenderTexture;
		UICamera.Render();
		UICamera.targetTexture = null;

		UICompositeMaterial.SetTexture(uitex_id, UIRenderTexture);

		// GL.sRGBWrite used to avoid an additional conversion in the shader. Probably won't work on mobile.
	#if !UNITY_ANDROID && !UNITY_IOS
		GL.sRGBWrite = false;
	#endif

		Graphics.Blit(src, dst, UICompositeMaterial, 0);

	#if !UNITY_ANDROID && !UNITY_IOS
		GL.sRGBWrite = true;
	#endif

		RenderTexture.ReleaseTemporary(UIRenderTexture);
	}
}
