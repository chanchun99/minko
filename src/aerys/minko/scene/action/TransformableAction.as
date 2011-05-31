package aerys.minko.scene.action
{
	import aerys.minko.render.renderer.IRenderer;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.ITransformable;
	import aerys.minko.scene.visitor.ISceneVisitor;
	
	public class TransformableAction implements IAction
	{
		private static var _instance	: TransformableAction;
		
		public static function get transformableAction() : TransformableAction
		{
			return _instance || (_instance = new TransformableAction());
		}
		
		public function get name() : String
		{
			return "TransformAction";
		}
		
		public function prefix(scene : IScene, visitor : ISceneVisitor, renderer : IRenderer) : Boolean
		{
			var transformable : ITransformable = scene as ITransformable;
			
			if (!transformable)
				throw new Error("TransformAction can only be applied to ITransformable nodes.");
			
			visitor.localData.world.push()
							 .multiply(transformable.transform);
			
			return true;
		}
		
		public function infix(scene : IScene, visitor : ISceneVisitor, renderer : IRenderer) : Boolean
		{
			return true;
		}
		
		public function postfix(scene : IScene, visitor : ISceneVisitor, renderer : IRenderer) : Boolean
		{
			visitor.localData.world.pop();
			
			return true;
		}
	}
}