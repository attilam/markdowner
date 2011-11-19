% Code Tester
%
%

Some code:

	class Actor extends MonoBehaviour {
		var health:int = 100;

		function Awake() {
			Debug.Log(gameObject.name+" woke up.");
		}
	}

and that's it...