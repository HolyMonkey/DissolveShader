using UnityEngine;
using System.Collections;

public class Present : MonoBehaviour {

	public bool over, rotate;
	public float _Range;

	void Update () {
		_Range += over ? Time.deltaTime : -Time.deltaTime;
		_Range = Mathf.Clamp(_Range, 0, 3);
		renderer.material.SetFloat("_Range", _Range);

		if(rotate)
		   transform.Rotate(transform.right / 4);
	
	}

	void OnMouseEnter()
	{
		_Range = renderer.material.GetFloat("_Range");
		over = false;
	}

	void OnMouseExit()
	{
		_Range = renderer.material.GetFloat("_Range");
		over = true;
	}
}
