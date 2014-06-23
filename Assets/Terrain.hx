import cs.NativeArray;
import unityengine.*;

@:meta(UnityEngine.ExecuteInEditMode)
class Terrain extends unityengine.MonoBehaviour
{
	var size : Int;
	var spawns : cs.NativeArray<Transform>;
	var cubes : Array<Array<Transform>>;
	var character : Transform;

	function Start()
	{
		cubes = new Array<Array<Transform>>();
		for(x in 0...size)
		{
			cubes.push(new Array<Transform>());
			for(y in 0...size)
			{
				var height = Math.random()*0.2;
				var spawn = switch(height)
				{
					case i if(i > 0.1) : spawns[0];
					default : spawns[1];
				}
				var object : Transform = cast Object.Instantiate(spawn, new Vector3(-size/2 + x, height, -size/2 + y), Quaternion.identity);
				object.parent = transform;
				object.renderer.material = cast Object.Instantiate(object.renderer.material);
				object.renderer.material.color = Color.Lerp(object.renderer.material.color, Color.white, Math.random()*0.1);
				cubes[x].push(object);
			}
		}

		Object.Instantiate(character, new Vector3(cubes[0][0].position.x-0.25,cubes[0][0].position.y+0.5,cubes[0][0].position.z-0.25), character.rotation);
	}
}