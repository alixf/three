import cs.NativeArray;
import cs.system.collections.*;
import unityengine.*;

class Character extends unityengine.MonoBehaviour
{
	var trajectory : Array<Transform>;
	var trajectoryMode = false;
	var trajectoryLine : LineRenderer;

	function Start()
	{
		trajectoryLine = cast GameObject.Find("trajectory").GetComponent("LineRenderer");
		trajectory = new Array<Transform>();
	}

	function Update()
	{
		var outlineWidth = 0.0;

		var ray = Camera.main.ScreenPointToRay(new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0));
		var hit = new RaycastHit();
		if(untyped __cs__("UnityEngine.Physics.Raycast(ray, out hit)"))
		{
			if(hit.transform == transform)
			{
				outlineWidth = 0.2;

				if(Input.GetMouseButton(0))
				{	
					//selected = true;
				}
			}
		}
		
		if(trajectoryMode && !Input.GetMouseButton(0))
		{
			trajectoryMode = false;	
			var realTrajectory = trajectory;
			trajectory = new Array<Transform>();
			trajectoryLine.SetVertexCount(trajectory.length);
			StartCoroutine(move(realTrajectory));
		}
		if(trajectoryMode)
		{
			outlineWidth = 0.2;

			if(hit.transform.CompareTag("Cube"))
			{
				if(trajectory.length == 0
					|| (trajectory[trajectory.length-1] != hit.transform
						&& Vector2.Distance(new Vector2(hit.transform.position.x, hit.transform.position.z), new Vector2(trajectory[trajectory.length-1].position.x, trajectory[trajectory.length-1].position.z)) <= 1.0))
				{
					var index = Lambda.indexOf(trajectory, hit.transform);
					if(index > -1)
						trajectory = trajectory.slice(0, index);
					trajectory.push(hit.transform);
				}

				if(trajectory.length > 0)
				{
					trajectoryLine.SetVertexCount(trajectory.length);
					var i = 0;
					for(point in trajectory)
						trajectoryLine.SetPosition(i++, new Vector3(point.position.x, 1, point.position.z));
				}
			}
		}
		
		renderer.material.SetFloat("_outlineWidth", outlineWidth);
	}

	public function move(trajectory : Array<Transform>) : IEnumerator
	{
		var duration = 0.25;
		trajectory.shift();
		while(trajectory.length > 0)
		{
			var t = trajectory.shift();
			untyped __cs__("yield return StartCoroutine(singleMove(t, duration))");
		}
		return untyped __cs__("false");
	}

	public function singleMove(position : Transform, duration : Float) : IEnumerator
	{
		var clock = 0.0;
		var start = transform.position;
		var end = position.position;

		while(clock < duration)
		{
			clock += Time.deltaTime;
			transform.position = Vector3.Lerp(start, end, clock / duration);
			untyped __cs__("yield return false");
		}

		transform.position = end;
		return untyped __cs__("false");
	}
}